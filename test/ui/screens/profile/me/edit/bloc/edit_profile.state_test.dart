import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/ui/screens/profile/me/edit/bloc/edit_profile.bloc.dart';

void main() {
  group('edit my profile screen state', () {
    group('ProfileImageData', () {
      test('should use web constructor', () async {
        // arrange
        const url = 'http://some.url/';
        // act
        final imageData = ProfileImageData.web(url);
        // assert
        expect(imageData.type, ProfileImageSourceType.web);
        expect(imageData.location, url);
        expect(imageData.file, null);
      });

      test('should use file constructor', () async {
        // arrange
        final file = File('/some/file/path');
        // act
        final imageData = ProfileImageData.file(file);
        // assert
        expect(imageData.type, ProfileImageSourceType.file);
        expect(imageData.file, file);
        expect(imageData.location, null);
      });
    });

    group('EditProfileState', () {
      const isBusy = true;
      const isProfileImageChanged = true;
      const isBackgroundImageChanged = true;
      final profileImage = ProfileImageData.web('http://some.url/profile.jpg');
      final backgroundImage =
          ProfileImageData.web('http://some.url/background.jpg');
      const username = ProfileDataField('username');
      const birthdate = ProfileDataField('birthdate');

      test('should use constructor parameters', () async {
        // arrange
        // act
        final state = EditProfileState(
          isBusy: isBusy,
          isProfileImageChanged: isProfileImageChanged,
          isBackgroundImageChanged: isBackgroundImageChanged,
          profileImage: profileImage,
          backgroundImage: backgroundImage,
          username: username,
          birthdate: birthdate,
        );
        // assert
        expect(state.isBusy, isBusy);
        expect(state.isProfileImageChanged, isProfileImageChanged);
        expect(state.isBackgroundImageChanged, isBackgroundImageChanged);
        expect(state.profileImage, profileImage);
        expect(state.backgroundImage, backgroundImage);
        expect(state.username, username);
        expect(state.birthdate, birthdate);
      });

      test('should have correct initial data', () async {
        // arrange
        // act
        const state = EditProfileState.initial();
        // assert
        expect(state.isBusy, false);
        expect(state.isProfileImageChanged, false);
        expect(state.isBackgroundImageChanged, false);
        expect(state.profileImage, null);
        expect(state.backgroundImage, null);
        expect(state.username.value, '');
        expect(state.birthdate.value, '');
      });

      test('should copy state with given parameters', () async {
        // arrange
        const state = EditProfileState.initial();
        // act
        final newState = state.copyWith(
          isBusy: isBusy,
          isProfileImageChanged: isProfileImageChanged,
          isBackgroundImageChanged: isBackgroundImageChanged,
          profileImage: profileImage,
          backgroundImage: backgroundImage,
          username: username,
          birthdate: birthdate,
        );
        // assert
        expect(newState.isBusy, isBusy);
        expect(newState.isProfileImageChanged, isProfileImageChanged);
        expect(newState.isBackgroundImageChanged, isBackgroundImageChanged);
        expect(newState.profileImage, profileImage);
        expect(newState.backgroundImage, backgroundImage);
        expect(newState.username, username);
        expect(newState.birthdate, birthdate);
      });
    });
  });
}
