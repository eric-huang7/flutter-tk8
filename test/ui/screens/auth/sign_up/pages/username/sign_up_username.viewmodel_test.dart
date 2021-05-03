import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/auth/sign_up/pages/username/sign_up_username.viewmodel.dart';

import '../../../../../../_helpers/i18n.dart';
import '../../../../../../_helpers/mocks.dart';
import '../../../../../../_helpers/service_injection.dart';

void main() {
  initializeServiceInjectionForTesting();
  initializeTranslationsForTests();

  final navigationMock = NavigationServiceMock();
  final userRepositoryMock = UserRepositoryMock();
  final signUpViewModelMock = SignUpViewModelMock();

  const username = 'tonik';

  setUpAll(() {
    getIt.registerLazySingleton<NavigationService>(() => navigationMock);
    getIt.registerLazySingleton<UserRepository>(() => userRepositoryMock);
  });

  setUp(() {
    reset(signUpViewModelMock);
  });

  group('SignUpUsernameViewModel', () {
    group('initialization', () {
      test('should initialize with username from sign up view model', () async {
        // arrange
        when(signUpViewModelMock.username).thenReturn(username);
        // act
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // assert
        expect(model.username, username);
        expect(model.errorMessage, isNull);
        expect(model.isUsernameValid, isTrue);
      });
      test(
          'should initialize with invalid username when sign up view model has no username',
          () async {
        // arrange

        // act
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // assert
        expect(model.username, isNull);
        expect(model.errorMessage, isNull);
        expect(model.isUsernameValid, isFalse);
      });
    });
    group('updateUsername', () {
      test('should set username invalid when empty username string is given',
          () async {
        // arrange

        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // act
        model.updateUsername('');
        // assert
        expect(model.username, '');
        expect(model.errorMessage, 'screens.signUp.errors.invalidUsername');
        expect(model.isUsernameValid, isFalse);
        expect(model.checkingUsername, isFalse);
        verifyZeroInteractions(userRepositoryMock);
        verifyZeroInteractions(navigationMock);
      });
      test(
          'should validate username with user repository when a non empty username string is given',
          () async {
        // arrange
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // act
        await model.updateUsername(username);
        // assert
        verify(userRepositoryMock.validateUsername(username));
        verifyNoMoreInteractions(userRepositoryMock);
        verifyZeroInteractions(navigationMock);
      });
      test('should show error alert when name validation fails', () async {
        // arrange
        when(userRepositoryMock.validateUsername(any)).thenThrow(Exception());
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // act
        await model.updateUsername(username);
        // assert
        expect(model.isUsernameValid, isFalse);
        expect(model.checkingUsername, isFalse);
        verify(navigationMock.showGenericErrorAlertDialog());
        verifyNoMoreInteractions(navigationMock);
      });
      test('should set invalid username when the given name is already used',
          () async {
        // arrange
        when(userRepositoryMock.validateUsername(any))
            .thenAnswer((_) async => UsernameValidationResult.invalidUsername);
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // act
        await model.updateUsername(username);
        // assert
        expect(model.isUsernameValid, isFalse);
        expect(model.checkingUsername, isFalse);
        expect(model.errorMessage, 'screens.signUp.errors.invalidUsername');
      });
      test('should set valid username when an unused username is given',
          () async {
        // arrange
        when(userRepositoryMock.validateUsername(any))
            .thenAnswer((_) async => UsernameValidationResult.ok);
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // act
        await model.updateUsername(username);
        // assert
        expect(model.username, username);
        expect(model.isUsernameValid, isTrue);
        expect(model.checkingUsername, isFalse);
        expect(model.errorMessage, '');
      });
    });

    group('submitUsername', () {
      test('should call setUserName on sign up view model', () async {
        // arrange
        when(signUpViewModelMock.username).thenReturn(username);
        final model = SignUpUsernameViewModel(signUpViewModelMock);
        // act
        model.submitUsername();
        // assert
        verify(signUpViewModelMock.setUserName(username));
      });
    });
  });
}
