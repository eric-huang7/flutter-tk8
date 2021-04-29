import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/services/media_library.service.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';

class ExerciseFeedbackViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();

  final String _chapterId;
  final String _exerciseId;

  bool _isUploadingVideo = false;

  ExerciseFeedbackViewModel(this._chapterId, this._exerciseId);

  bool get isUploadingVideo => _isUploadingVideo;

  Future<void> onUploadClicked() async {
    _isUploadingVideo = true;
    notifyListeners();

    try {
      final file = await getIt<MediaLibraryService>().selectVideoFromGallery();
      await _api.uploadVideo(file,
          chapterId: _chapterId, exerciseId: _exerciseId);
      _navigator.showAlertDialog(
        AlertInfo(
          title: translate('screens.chapterDetails.uploadSuccessAlert.title'),
          text: translate('screens.chapterDetails.uploadSuccessAlert.text'),
          actions: [
            AlertAction(
                title: translate('alerts.actions.ok.title'),
                onPressed: () =>
                    _navigator.openExerciseDoneScreen(_chapterId, _exerciseId))
          ],
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

  void onLaterClicked() {
    _navigator.openExerciseDoneScreen(_chapterId, _exerciseId);
  }
}
