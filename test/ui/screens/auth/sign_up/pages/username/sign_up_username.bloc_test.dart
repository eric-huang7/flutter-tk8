import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/data/repositories/user.repository.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/auth/sign_up/pages/username/sign_up_username.bloc.dart';

import '../../../../../../_helpers/i18n.dart';
import '../../../../../../_helpers/mocks.dart';
import '../../../../../../_helpers/service_injection.dart';

void main() {
  final navigationMock = NavigationServiceMock();
  final userRepositoryMock = UserRepositoryMock();

  setUp(() {
    getIt.reset();
    initializeServiceInjectionForTesting();
    getIt.registerLazySingleton<NavigationService>(() => navigationMock);
    getIt.registerLazySingleton<UserRepository>(() => userRepositoryMock);
  });

  setUpAll(() {
    reset(navigationMock);
    reset(userRepositoryMock);
  });

  group('sign up username page', () {
    const name = 'John Doe';

    group('state', () {
      test('should use constructor parameters', () async {
        // arrange
        const valid = false;
        const error = 'Some error';
        const checkingUsername = true;
        // act
        const state = SignUpUsernameState(
          username: name,
          isUsernameValid: valid,
          errorMessage: error,
          checkingUsername: checkingUsername,
        );
        // assert
        expect(state.username, name);
        expect(state.isUsernameValid, valid);
        expect(state.errorMessage, error);
        expect(state.checkingUsername, checkingUsername);
      });

      test('should initiate with valid username', () async {
        // arrange
        // act
        final state = SignUpUsernameState.initial(name);
        // assert
        expect(state.username, name);
        expect(state.isUsernameValid, true);
        expect(state.errorMessage, '');
        expect(state.checkingUsername, false);
      });

      test('should initiate with invalid username', () async {
        // act
        final state = SignUpUsernameState.initial('');
        // assert
        expect(state.username, '');
        expect(state.isUsernameValid, false);
        expect(state.errorMessage, '');
        expect(state.checkingUsername, false);
      });

      test('should copy state with given parameters', () async {
        // arrange
        final state = SignUpUsernameState.initial('');
        const error = 'Error message';
        const valid = true;
        const checkingUsername = true;
        // act
        final stateCopy = state.copyWith(
          username: name,
          errorMessage: error,
          isUsernameValid: valid,
          checkingUsername: checkingUsername,
        );
        // assert
        expect(stateCopy.username, name);
        expect(stateCopy.isUsernameValid, valid);
        expect(stateCopy.errorMessage, error);
        expect(stateCopy.checkingUsername, checkingUsername);
      });
    });

    group('bloc', () {
      initializeTranslationsForTests();

      blocTest<SignUpUsernameBloc, SignUpUsernameState>(
        'should start with given valid date',
        build: () => SignUpUsernameBloc(name),
        verify: (cubit) => cubit.state == SignUpUsernameState.initial(name),
      );

      blocTest<SignUpUsernameBloc, SignUpUsernameState>(
        'should emit valid state when invalid username is given',
        build: () {
          when(userRepositoryMock.validateUsername(any))
              .thenAnswer((_) async => UsernameValidationResult.ok);
          return SignUpUsernameBloc('some old name');
        },
        act: (cubit) => cubit.upateUsername(name),
        expect: [
          const SignUpUsernameState(
            username: 'some old name',
            isUsernameValid: true,
            errorMessage: '',
            checkingUsername: true,
          ),
          const SignUpUsernameState(
            username: name,
            isUsernameValid: true,
            errorMessage: '',
            checkingUsername: false,
          )
        ],
        verify: (cubit) {
          verify(userRepositoryMock.validateUsername(name));
        },
      );

      blocTest<SignUpUsernameBloc, SignUpUsernameState>(
        'should emit invalid state when invalid username is given',
        build: () {
          when(userRepositoryMock.validateUsername(any)).thenAnswer(
              (_) async => UsernameValidationResult.invalidUsername);
          return SignUpUsernameBloc(name);
        },
        act: (cubit) => cubit.upateUsername(''),
        expect: [
          const SignUpUsernameState(
            username: name,
            isUsernameValid: true,
            errorMessage: '',
            checkingUsername: true,
          ),
          const SignUpUsernameState(
            username: '',
            isUsernameValid: false,
            errorMessage: 'screens.signUp.errors.invalidUsername',
            checkingUsername: false,
          )
        ],
        verify: (cubit) {
          verify(userRepositoryMock.validateUsername(''));
        },
      );

      blocTest<SignUpUsernameBloc, SignUpUsernameState>(
        'should emit invalid state and show alert when name validation fails',
        build: () {
          when(userRepositoryMock.validateUsername(any))
              .thenThrow((_) => Exception());
          return SignUpUsernameBloc(name);
        },
        act: (cubit) => cubit.upateUsername(''),
        expect: [
          const SignUpUsernameState(
            username: name,
            isUsernameValid: true,
            errorMessage: '',
            checkingUsername: true,
          ),
          const SignUpUsernameState(
            username: '',
            isUsernameValid: false,
            errorMessage: '',
            checkingUsername: false,
          )
        ],
        verify: (cubit) {
          verify(userRepositoryMock.validateUsername(''));
          verify(navigationMock.showGenericErrorAlertDialog());
        },
      );
    });
  });
}
