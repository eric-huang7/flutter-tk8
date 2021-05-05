import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';

import 'edit_profile.state.dart';

export 'edit_profile.state.dart';

class EditProfileBloc extends Cubit<EditProfileState> {
  final _userRepository = getIt<UserRepository>();
  final _navigator = getIt<NavigationService>();
  final _mediaLibrary = getIt<MediaLibraryService>();

  bool get hasChanges =>
      state.isBackgroundImageChanged ||
      state.isProfileImageChanged ||
      isProfileChanged;
  bool get isProfileChanged =>
      state.username.value != (_userRepository.myProfileUser.username);

  EditProfileBloc() : super(_getInitialStateFromRepository());

  // actions

  Future<void> saveChanges() async {
    if (state.username.error != null) {
      _showInvalidUserDataDialog();
      return;
    }
    if (hasChanges) {
      emit(state.copyWith(isBusy: true));
      if (isProfileChanged) {
        try {
          await _userRepository.updateUser(username: state.username.value);
        } catch (e) {
          emit(state.copyWith(isBusy: false));
          if (e is UserRepositoryException &&
              e.error == UserRepositoryError.invalidUserData) {
            _showInvalidUserDataDialog();
          } else {
            _navigator.showGenericErrorAlertDialog();
          }
          return;
        }
      }
      if (state.isBackgroundImageChanged) {
        final result = await _userRepository
            .uploadUserProfileBackgroundImage(state.backgroundImage.file);
        if (result != ImageUploadResult.ok) {
          _navigator.showGenericErrorAlertDialog();
          emit(state.copyWith(isBusy: false));
          return;
        }
      }
      if (state.isProfileImageChanged) {
        final result = await _userRepository
            .uploadUserProfileImage(state.profileImage.file);
        if (result != ImageUploadResult.ok) {
          _navigator.showGenericErrorAlertDialog();
          emit(state.copyWith(isBusy: false));
          return;
        }
      }
    }
    _navigator.pop();
  }

  Future<void> closeScreen() async {
    if (hasChanges) {
      final discardChanges = await _navigator.showAlertDialog(
        AlertInfo(
          title: translate('screens.myProfile.edit.discardChangesAlert.title'),
          text: translate('screens.myProfile.edit.discardChangesAlert.text'),
          actions: [
            AlertAction(
              title: translate('alerts.actions.cancel.title'),
              popOnPressed: false,
              onPressed: () => _navigator.pop(false),
            ),
            AlertAction(
              title: translate(
                  'screens.myProfile.edit.discardChangesAlert.actions.discard.title'),
              popOnPressed: false,
              onPressed: () => _navigator.pop(true),
            ),
          ],
        ),
      );
      if (!(discardChanges ?? false)) return;
    }
    _navigator.pop();
  }

  Future<void> selectProfileImage() async {
    final source = await _navigator.showAlertDialog(AlertInfo(
      title:
          translate('screens.myProfile.edit.profileImageSelectionAlert.title'),
      actions: [
        AlertAction(
          title: translate(
              'screens.myProfile.edit.profileImageSelectionAlert.actions.camera'),
          onPressed: () => _navigator.pop('camera'),
          popOnPressed: false,
        ),
        AlertAction(
          title: translate(
              'screens.myProfile.edit.profileImageSelectionAlert.actions.gallery'),
          onPressed: () => _navigator.pop('gallery'),
          popOnPressed: false,
        ),
        AlertAction(
          title: translate('alerts.actions.cancel.title'),
          isDefault: true,
        ),
      ],
    ));
    if (source == null) return;

    try {
      File sourceFile;
      if (source == 'camera') {
        sourceFile = await _mediaLibrary.selectPhotoFromCamera();
      } else {
        sourceFile = await _mediaLibrary.selectPhotoFromGallery();
      }
      final file = await _mediaLibrary.cropImageFile(
        sourceFile.path,
        translate('screens.myProfile.edit.imageCropTitle.profile'),
        circularCrop: true,
      );
      if (file != null) {
        emit(state.copyWith(
          isProfileImageChanged: true,
          profileImage: ProfileImageData.file(file),
        ));
      }
    } on MediaLibraryServiceException catch (e) {
      switch (e.error) {
        case MediaLibraryServiceError.userCanceled:
          return;
        case MediaLibraryServiceError.accessDenied:
          _showMediaLibraryPermissionsRequired();
          break;
        default:
          _navigator.showGenericErrorAlertDialog();
      }
    } catch (_) {
      _navigator.showGenericErrorAlertDialog();
    }
  }

  Future<void> selectBackgroundImage() async {
    try {
      final sourceFile = await _mediaLibrary.selectPhotoFromGallery();
      final file = await _mediaLibrary.cropImageFile(
        sourceFile.path,
        translate('screens.myProfile.edit.imageCropTitle.background'),
      );
      if (file != null) {
        emit(state.copyWith(
          isBackgroundImageChanged: true,
          backgroundImage: ProfileImageData.file(file),
        ));
      }
    } on MediaLibraryServiceException catch (e) {
      switch (e.error) {
        case MediaLibraryServiceError.userCanceled:
          return;
        case MediaLibraryServiceError.accessDenied:
          _showMediaLibraryPermissionsRequired();
          break;
        default:
          _navigator.showGenericErrorAlertDialog();
      }
    } catch (_) {
      _navigator.showGenericErrorAlertDialog();
    }
  }

  // profile data

  String validateUsername(String value) {
    if (value == _userRepository.myProfileUser.username) return null;
    return value.isEmpty
        ? translate('screens.myProfile.edit.validations.invalidUsername')
        : null;
  }

  void updateUsername(String value) {
    emit(state.copyWith(
      username: ProfileDataField(value, error: validateUsername(value)),
    ));
  }

  // private api

  static EditProfileState _getInitialStateFromRepository() {
    ProfileImageData background;
    ProfileImageData profile;
    final user = getIt<UserRepository>().myProfileUser;
    if (user.backgroudImage != null) {
      background = ProfileImageData.web(user.backgroudImage.fullUrl);
    }
    if (user.profileImage != null) {
      profile = ProfileImageData.web(user.profileImage.fullUrl);
    }
    return const EditProfileState.initial().copyWith(
      backgroundImage: background,
      profileImage: profile,
      username: ProfileDataField(user.username),
      birthdate: ProfileDataField(DateFormat.yMMMMd().format(user.birthdate)),
    );
  }

  void _showMediaLibraryPermissionsRequired() {
    _navigator.showAlertDialog(
      AlertInfo(
        title: translate(
            'screens.myProfile.edit.mediaLibraryPermissionsRequiredAlert.title'),
        text: translate(
            'screens.myProfile.edit.mediaLibraryPermissionsRequiredAlert.text'),
        actions: [AlertAction(title: translate('alerts.actions.ok.title'))],
      ),
    );
  }

  void _showInvalidUserDataDialog() {
    _navigator.showAlertDialog(
      AlertInfo(
        title: translate('screens.myProfile.edit.invalidUserData.title'),
        text: translate('screens.myProfile.edit.invalidUserData.text'),
        actions: [AlertAction(title: translate('alerts.actions.ok.title'))],
      ),
    );
  }
}
