import 'package:flutter/material.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/repositories/academy.repository.dart';
import 'package:tk8/data/repositories/exercise.repository.dart';
import 'package:tk8/navigation/app_routes.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';

class ExerciseDoneViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _academyRepository = getIt<AcademyRepository>();
  final _exerciseRepository = getIt<ExerciseRepository>();

  final String _chapterId;
  final String _exerciseId;

  ChapterVideoExercise exercise;

  int _minutesTrainedThisSession;

  int get minutesTrainedThisSession => _minutesTrainedThisSession;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ExerciseDoneViewModel(this._chapterId, this._exerciseId) {
    _minutesTrainedThisSession = _exerciseRepository.getTrainedTime();
    _loadChapterDetails();
  }

  Future<void> _loadChapterDetails() async {
    _isLoading = true;

    final chapter = await _academyRepository.getChapterDetails(_chapterId);
    exercise = chapter.videoItems
        .where((element) => element.exercise != null)
        .toList()
        .firstWhere((element) => element.exercise.id == _exerciseId)
        .exercise;

    _isLoading = false;
    notifyListeners();
  }

  void onContinueClicked() {
    _navigator.popBackUntil(AppRoutes.chapterDetails);
  }

  void onRepeatExerciseClicked() {
    _navigator.repeatExercise(_chapterId, _exerciseId);
  }
}
