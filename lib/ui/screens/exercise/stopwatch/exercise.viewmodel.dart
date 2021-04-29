import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/repositories/academy.repository.dart';
import 'package:tk8/data/repositories/exercise.repository.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';

enum ExerciseScreenState { countdown, training }

const _autoEndSecondsTimeout = 1800;

class ExerciseViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _academyRepository = getIt<AcademyRepository>();
  final _exerciseRepository = getIt<ExerciseRepository>();

  final ChapterVideoExercise _exercise;
  final String _chapterId;
  Chapter _chapter;

  ExerciseScreenState _state = ExerciseScreenState.countdown;

  ExerciseScreenState get state => _state;

  ChapterVideoExercise get exercise => _exercise;

  bool get isRevisited => _exercise.totalFinished > 0;

  bool _isFinished = false;

  bool get isFinished => _isFinished;

  bool _isLimitReached = false;

  bool get isLimitReached => _isLimitReached;

  final Stopwatch _stopwatch = Stopwatch();
  Timer _timer;

  Duration get exerciseElapsedTime => _stopwatch.elapsed;
  double _circleProgress = 0.0;

  double get circleProgress => _circleProgress;

  bool get hasUserUploadedVideoBefore =>
      _chapter.userVideos.any((element) => element.exerciseId == _exercise.id);

  ExerciseViewModel(this._exercise, this._chapterId) {
    _loadChapterDetails();
  }

  Future<void> _loadChapterDetails() async {
    _chapter = await _academyRepository.getChapterDetails(_chapterId);
    notifyListeners();
  }

  void onCountdownFinished() {
    _state = ExerciseScreenState.training;
    _startStopwatch();
    notifyListeners();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateProgress();
      _checkIfAutoEndReached();
      notifyListeners();
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer.cancel();
    notifyListeners();
  }

  void _calculateProgress() {
    if (_exercise.totalFinished >= 1) {
      return;
    }
    final double currentProgress =
        _stopwatch.elapsedMilliseconds / exercise.duration.inMilliseconds;
    if (currentProgress >= 1.0) {
      _circleProgress = 1.0;
      _isFinished = true;
    } else {
      _circleProgress = currentProgress;
    }
  }

  void _checkIfAutoEndReached() {
    if (_stopwatch.elapsed.inSeconds == _autoEndSecondsTimeout) {
      _stopStopwatch();
      _isLimitReached = true;
    }
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  void onCancelClicked() {
    _stopStopwatch();
    final alertInfo = AlertInfo(
      title: translate(
        'screens.exercise.cancelTrainingAlert.title',
      ),
      actions: [
        AlertAction(
            isDestructive: true,
            title: translate(
              'screens.exercise.cancelTrainingAlert.actions.cancel.title',
            ),
            onPressed: _navigator.pop),
        AlertAction(
            title: translate(
              'screens.exercise.cancelTrainingAlert.actions.back.title',
            ),
            onPressed: () => _startStopwatch()),
      ],
      isVerticalActionsAlignment: true,
    );
    _navigator.showAlertDialog(alertInfo);
    return;
  }

  Future<void> onFinishExerciseClicked() async {
    _stopStopwatch();

    await _exerciseRepository.performTraining(exercise.id, _stopwatch.elapsed);

    if (exercise.isUploadAvailable && !hasUserUploadedVideoBefore) {
      _navigator.openExerciseFeedbackScreen(_chapterId, exercise.id);
    } else {
      _navigator.openExerciseDoneScreen(_chapterId, exercise.id);
    }
  }

  void onShowSchemeClicked() {
    _stopStopwatch();
    notifyListeners();
  }

  void onCloseSchemeClicked() {
    // Resume timer
    _state = ExerciseScreenState.countdown;
    notifyListeners();
  }
}
