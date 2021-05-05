import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import 'package:tk8/data/models/user.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/profile/me/edit/bloc/edit_profile.bloc.dart';

import '../../../../../../_fixtures/fixture_reader.dart';
import '../../../../../../_helpers/i18n.dart';
import '../../../../../../_helpers/mocks.dart';
import '../../../../../../_helpers/service_injection.dart';

void main() {
  initializeTranslationsForTests();
  initializeServiceInjectionForTesting();

  final user = User.fromMap(fixtureAsMap('user/user.json'));
  final userRepositoryMock = UserRepositoryMock();
  final navigatorMock = NavigationServiceMock();
  final mediaLibraryMock = MediaLibraryServiceMock();

  getIt.registerLazySingleton<UserRepository>(() => userRepositoryMock);
  getIt.registerLazySingleton<NavigationService>(() => navigatorMock);
  getIt.registerLazySingleton<MediaLibraryService>(() => mediaLibraryMock);

  EditProfileState _initialStateWithUser({
    bool isBusy,
    bool isProfileImageChanged,
    bool isBackgroundImageChanged,
    ProfileImageData profileImage,
    ProfileImageData backgroundImage,
    ProfileDataField<String> username,
    ProfileDataField<String> birthdate,
  }) =>
      const EditProfileState.initial().copyWith(
        isBusy: isBusy ?? false,
        isProfileImageChanged: isProfileImageChanged ?? false,
        isBackgroundImageChanged: isBackgroundImageChanged ?? false,
        username: username ?? ProfileDataField(user.username),
        birthdate: birthdate ??
            ProfileDataField(DateFormat.yMMMMd().format(user.birthdate)),
        profileImage:
            profileImage ?? ProfileImageData.web(user.profileImage.fullUrl),
        backgroundImage: backgroundImage ??
            ProfileImageData.web(user.backgroudImage.fullUrl),
      );

  setUp(() {
    reset(userRepositoryMock);
    reset(navigatorMock);
    reset(mediaLibraryMock);
    when(userRepositoryMock.myProfileUser).thenReturn(user);
  });

  group('edit my profile screen bloc', () {
    blocTest<EditProfileBloc, EditProfileState>(
      'should start with user data from repository',
      build: () => EditProfileBloc(),
      verify: (cubit) =>
          cubit.state ==
          EditProfileState(
            backgroundImage: ProfileImageData.web(user.backgroudImage.fullUrl),
            profileImage: ProfileImageData.web(user.profileImage.fullUrl),
            username: ProfileDataField(user.username),
            birthdate:
                ProfileDataField(DateFormat.yMMMMd().format(user.birthdate)),
          ),
    );

    group('saveChanges', () {
      blocTest<EditProfileBloc, EditProfileState>(
        'should exit without saving when there are no changes',
        build: () => EditProfileBloc(),
        act: (cubit) => cubit.saveChanges(),
        verify: (cubit) {
          verify(navigatorMock.pop());
          verify(userRepositoryMock.myProfileUser);
          verifyNoMoreInteractions(navigatorMock);
          verifyNoMoreInteractions(userRepositoryMock);
          verifyZeroInteractions(mediaLibraryMock);
        },
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'should show alert when there is invalid data',
        build: () => EditProfileBloc(),
        act: (cubit) {
          cubit.updateUsername('');
          return cubit.saveChanges();
        },
        verify: (cubit) {
          verify(navigatorMock.showAlertDialog(any));
          verify(userRepositoryMock.myProfileUser);
          verifyNoMoreInteractions(navigatorMock);
          verifyNoMoreInteractions(userRepositoryMock);
          verifyZeroInteractions(mediaLibraryMock);
        },
        expect: [
          _initialStateWithUser(
            username: const ProfileDataField(
              '',
              error: 'screens.myProfile.edit.validations.invalidUsername',
            ),
          )
        ],
      );

      group('should update user when there are changes', () {
        const name = 'new_name';
        final initial =
            _initialStateWithUser(username: const ProfileDataField(name));
        blocTest<EditProfileBloc, EditProfileState>(
          '',
          build: () => EditProfileBloc(),
          act: (cubit) {
            cubit.updateUsername(name);
            return cubit.saveChanges();
          },
          verify: (cubit) {
            verify(userRepositoryMock.myProfileUser);
            verify(userRepositoryMock.updateUser(username: 'new_name'));
            verifyNoMoreInteractions(userRepositoryMock);
          },
          expect: [
            initial,
            initial.copyWith(isBusy: true),
          ],
        );
      });

      group('to user profile image', () {
        final initial = _initialStateWithUser(
          isProfileImageChanged: true,
          profileImage: ProfileImageData.file(File('/some/path/crop')),
        );

        setUp(() {
          when(navigatorMock.showAlertDialog(any))
              .thenAnswer((realInvocation) async => 'gallery');
          when(mediaLibraryMock.cropImageFile(any, any, circularCrop: true))
              .thenAnswer((realInvocation) async => File('/some/path/crop'));
          when(mediaLibraryMock.selectPhotoFromGallery())
              .thenAnswer((realInvocation) async => File('/some/path'));
        });

        group('should be updated when it is changed', () {
          setUp(() {
            when(userRepositoryMock.uploadUserProfileImage(any))
                .thenAnswer((realInvocation) async => ImageUploadResult.ok);
          });

          blocTest<EditProfileBloc, EditProfileState>(
            '',
            build: () => EditProfileBloc(),
            act: (cubit) async {
              await cubit.selectProfileImage();
              return cubit.saveChanges();
            },
            verify: (cubit) {
              verify(userRepositoryMock.myProfileUser);
              verify(userRepositoryMock.uploadUserProfileImage(any));
              verify(navigatorMock.showAlertDialog(any));
              verify(navigatorMock.pop());
              verifyNoMoreInteractions(userRepositoryMock);
              verifyNoMoreInteractions(navigatorMock);
            },
            expect: [
              initial,
              initial.copyWith(isBusy: true),
            ],
          );
        });

        group('should show error alert when update fails', () {
          setUp(() {
            when(userRepositoryMock.uploadUserProfileImage(any)).thenAnswer(
                (realInvocation) async => ImageUploadResult.invalidImage);
          });

          blocTest<EditProfileBloc, EditProfileState>(
            '',
            build: () => EditProfileBloc(),
            act: (cubit) async {
              await cubit.selectProfileImage();
              return cubit.saveChanges();
            },
            verify: (cubit) {
              verify(userRepositoryMock.myProfileUser);
              verify(userRepositoryMock.uploadUserProfileImage(any));
              verify(navigatorMock.showAlertDialog(any));
              verify(navigatorMock.showGenericErrorAlertDialog());
              verifyNoMoreInteractions(userRepositoryMock);
              verifyNoMoreInteractions(navigatorMock);
            },
            expect: [
              initial,
              initial.copyWith(isBusy: true),
              initial.copyWith(isBusy: false),
            ],
          );
        });
      });

      group('to user profile background image', () {
        final initial = _initialStateWithUser(
          isBackgroundImageChanged: true,
          backgroundImage: ProfileImageData.file(File('/some/path/crop')),
        );

        setUp(() {
          when(mediaLibraryMock.cropImageFile(any, any))
              .thenAnswer((realInvocation) async => File('/some/path/crop'));
          when(mediaLibraryMock.selectPhotoFromGallery())
              .thenAnswer((realInvocation) async => File('/some/path'));
        });

        group('should be updated when it is changed', () {
          setUp(() {
            when(userRepositoryMock.uploadUserProfileBackgroundImage(any))
                .thenAnswer((realInvocation) async => ImageUploadResult.ok);
          });

          blocTest<EditProfileBloc, EditProfileState>('', build: () {
            return EditProfileBloc();
          }, act: (cubit) async {
            await cubit.selectBackgroundImage();
            return cubit.saveChanges();
          }, verify: (cubit) {
            verify(userRepositoryMock.myProfileUser);
            verify(userRepositoryMock.uploadUserProfileBackgroundImage(any));
            verify(navigatorMock.pop());
            verifyNoMoreInteractions(userRepositoryMock);
            verifyNoMoreInteractions(navigatorMock);
          }, expect: [
            initial,
            initial.copyWith(isBusy: true),
          ]);
        });

        group('should show error alert when update fails', () {
          setUp(() {
            when(userRepositoryMock.uploadUserProfileBackgroundImage(any))
                .thenAnswer(
                    (realInvocation) async => ImageUploadResult.invalidImage);
          });

          blocTest<EditProfileBloc, EditProfileState>('', build: () {
            return EditProfileBloc();
          }, act: (cubit) async {
            await cubit.selectBackgroundImage();
            return cubit.saveChanges();
          }, verify: (cubit) {
            verify(userRepositoryMock.myProfileUser);
            verify(userRepositoryMock.uploadUserProfileBackgroundImage(any));
            verify(navigatorMock.showGenericErrorAlertDialog());
            verifyNoMoreInteractions(userRepositoryMock);
            verifyNoMoreInteractions(navigatorMock);
          }, expect: [
            initial,
            initial.copyWith(isBusy: true),
            initial.copyWith(isBusy: false),
          ]);
        });
      });
    });

    group('closeScreen', () {
      blocTest<EditProfileBloc, EditProfileState>(
        'should exit when there are no changes',
        build: () {
          when(navigatorMock.showAlertDialog(any))
              .thenAnswer((realInvocation) async => false);
          return EditProfileBloc();
        },
        act: (cubit) => cubit.closeScreen(),
        verify: (cubit) {
          verify(navigatorMock.pop());
          verify(userRepositoryMock.myProfileUser);
          verifyNoMoreInteractions(navigatorMock);
          verifyNoMoreInteractions(userRepositoryMock);
          verifyZeroInteractions(mediaLibraryMock);
        },
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'should show alert when there are changes',
        build: () {
          when(navigatorMock.showAlertDialog(any))
              .thenAnswer((realInvocation) async => false);
          return EditProfileBloc();
        },
        act: (cubit) {
          cubit.updateUsername('some name');
          return cubit.closeScreen();
        },
        verify: (cubit) {
          verify(navigatorMock.showAlertDialog(any));
          verify(userRepositoryMock.myProfileUser);
          verifyNoMoreInteractions(navigatorMock);
          verifyNoMoreInteractions(userRepositoryMock);
          verifyZeroInteractions(mediaLibraryMock);
        },
      );
    });

    group('validateUsername', () {
      test('should ignore if the name did not change', () async {
        // arrange
        final bloc = EditProfileBloc();
        // act
        final result = bloc.validateUsername(user.username);
        // assert
        expect(result, null);
      });
      test('should fail if the name is empty', () async {
        // arrange
        final bloc = EditProfileBloc();
        // act
        final result = bloc.validateUsername('');
        // assert
        expect(result, 'screens.myProfile.edit.validations.invalidUsername');
      });
    });

    group('updateUsername', () {
      const name = 'new name';
      blocTest<EditProfileBloc, EditProfileState>(
        'should update with new name when name is valid',
        build: () => EditProfileBloc(),
        act: (cubit) => cubit.updateUsername(name),
        expect: [
          _initialStateWithUser(username: const ProfileDataField(name)),
        ],
      );
      blocTest<EditProfileBloc, EditProfileState>(
        'should update with new name with error when name is not valid',
        build: () => EditProfileBloc(),
        act: (cubit) => cubit.updateUsername(''),
        expect: [
          _initialStateWithUser(
              username: const ProfileDataField(
            '',
            error: 'screens.myProfile.edit.validations.invalidUsername',
          )),
        ],
      );
    });
  });
}
