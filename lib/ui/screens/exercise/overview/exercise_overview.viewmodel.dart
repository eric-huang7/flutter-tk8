import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/data/repositories/academy.repository.dart';
import 'package:tk8/services/media_library.service.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';

class ExerciseOverviewViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();
  final _academyRepository = getIt<AcademyRepository>();

  final String _exerciseId;
  final String _chapterId;

  Chapter _chapter;
  ChapterVideoExercise _exercise;
  Video _exerciseTutorialVideo;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ChapterVideoExercise get exercise => _exercise;

  bool get isFinished => _exercise.totalFinished > 0;

  bool get isVideoUploadAvailable => _exercise.isUploadAvailable;

  bool get hasUserUploadedVideoBefore =>
      _chapter.userVideos.any((element) => element.exerciseId == _exerciseId);

  bool _isUploadingVideo = false;

  bool get isUploadingVideo => _isUploadingVideo;

  ExerciseOverviewViewModel(this._chapterId, this._exerciseId) {
    _loadChapterDetails();
  }

  Future<void> _loadChapterDetails() async {
    _isLoading = true;
    _chapter = await _academyRepository.getChapterDetails(_chapterId);
    final chapterItem = _chapter.videoItems
        .where((element) => element.exercise != null)
        .toList()
        .firstWhere((element) => element.exercise.id == _exerciseId);
    _exerciseTutorialVideo = chapterItem.video;
    _exercise = chapterItem.exercise;

    _isLoading = false;
    notifyListeners();
  }

  void onWatchTutorialClicked() {
    _navigator.openVideoPlayerWithVideo(_exerciseTutorialVideo);
  }

  void onStartExerciseClicked() {
    _navigator.openExerciseScreen(_exercise, _chapterId);
  }

  void onBackClicked() {
    _navigator.pop();
  }

  // TODO: Add loading status check on the screen
  Future<void> onUploadClicked() async {
    _isUploadingVideo = true;
    notifyListeners();

    try {
      final file = await getIt<MediaLibraryService>().selectVideoFromGallery();
      await _api.uploadVideo(file,
          chapterId: _chapterId, exerciseId: exercise.id);
      _navigator.showAlertDialog(
        AlertInfo(
          title: translate('screens.chapterDetails.uploadSuccessAlert.title'),
          text: translate('screens.chapterDetails.uploadSuccessAlert.text'),
          actions: [AlertAction(title: translate('alerts.actions.ok.title'))],
        ),
      );
    } on MediaLibraryServiceException catch (e) {
      switch (e.error) {
        case MediaLibraryServiceError.userCanceled:
          break;
        case MediaLibraryServiceError.accessDenied:
          _showMediaLibraryPermissionsRequired();
          break;
        default:
          _navigator.showGenericErrorAlertDialog();
      }
    } catch (_) {
      _navigator.showGenericErrorAlertDialog();
    }

    _isUploadingVideo = false;
    notifyListeners();
  }

  void _showMediaLibraryPermissionsRequired() {
    _navigator.showAlertDialog(
      AlertInfo(
        title: translate(
            'screens.chapterDetails.mediaLibraryPermissionsRequiredAlert.title'),
        text: translate(
            'screens.chapterDetails.mediaLibraryPermissionsRequiredAlert.text'),
        actions: [AlertAction(title: translate('alerts.actions.ok.title'))],
      ),
    );
  }
}
