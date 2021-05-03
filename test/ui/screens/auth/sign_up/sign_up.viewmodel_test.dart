import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/auth/sign_up/sign_up.viewmodel.dart';

import '../../../../_helpers/mocks.dart';
import '../../../../_helpers/service_injection.dart';

void main() {
  final navigationMock = NavigationServiceMock();
  final authServiceMock = AuthServiceMock();

  initializeServiceInjectionForTesting();
  getIt.registerLazySingleton<NavigationService>(() => navigationMock);
  getIt.registerLazySingleton<AuthService>(() => authServiceMock);

  const username = 'tonik8';
  final birthdate = DateTime(2000);
  const email = 'toni@kroos.com';
  const invitationCode = 'AAA123';

  group('SignUpViewModel', () {
    group('initialization', () {
      test(
          'should setup correct sign steps sequence for waiting for invitaiton',
          () async {
        // arrange & act
        final model = SignUpViewModel(
          signUpMode: SignUpMode.waitingForInvitation,
        );
        // assert
        expect(model.signUpSteps, waitingForInvitationSteps);
        expect(model.currentPageType, waitingForInvitationSteps.first);
      });
      test('should setup correct sign steps sequence for activating account',
          () async {
        // arrange & act
        final model = SignUpViewModel(
          signUpMode: SignUpMode.activateAccount,
          invitationCode: invitationCode,
        );
        // assert
        expect(model.signUpSteps, activateAccountSteps);
        expect(model.currentPageType, activateAccountSteps.first);
      });
      test(
          'should setup correct sign steps sequence for sign up with inactive account',
          () async {
        // arrange & act
        final model = SignUpViewModel(
          signUpMode: SignUpMode.createAccount,
        );
        // assert
        expect(model.signUpSteps, createInactiveAccountSteps);
        expect(model.currentPageType, createInactiveAccountSteps.first);
      });
      test(
          'should setup correct sign steps sequence for sign up with active account',
          () async {
        // arrange & act
        final model = SignUpViewModel(
          signUpMode: SignUpMode.createAccount,
          invitationCode: invitationCode,
        );
        // assert
        expect(model.signUpSteps, createActiveAccountSteps);
        expect(model.currentPageType, createActiveAccountSteps.first);
      });
    });

    group('waiting for invitation mode', () {
      test('should always be in waiting for invitaion mode', () async {
        // arrange
        final model =
            SignUpViewModel(signUpMode: SignUpMode.waitingForInvitation);
        // arrange & act
        model.goToNextPage();
        expect(model.currentPageType, SignUpPageType.waitingForInvitation);
        model.goToPreviousPage();
        expect(model.currentPageType, SignUpPageType.waitingForInvitation);
      });
    });

    group('activate account', () {
      test('should set email and activate account', () async {
        // arrange
        final model = SignUpViewModel(
          signUpMode: SignUpMode.activateAccount,
          invitationCode: invitationCode,
        );
        // act & assert
        expect(model.currentPageType, SignUpPageType.email);

        model.setEmail(email);
        expect(model.email, email);

        verify(authServiceMock.activateAccount(
          email: email,
          invitationCode: invitationCode,
        ));
      });
    });

    group('create inactive account', () {
      test(
          'should set username and birthdate, create account and finish in waiting for invitation',
          () async {
        // arrange
        final model = SignUpViewModel(
          signUpMode: SignUpMode.createAccount,
        );
        // act & assert
        model.goToNextPage();
        expect(model.currentPageType, SignUpPageType.username);

        model.setUserName(username);
        expect(model.username, username);
        expect(model.currentPageType, SignUpPageType.birthday);

        model.setBirthdate(birthdate);
        expect(model.birthdate, birthdate);

        await untilCalled(authServiceMock.signUp(
            username: anyNamed('username'), birthdate: anyNamed('birthdate')));

        expect(model.currentPageType, SignUpPageType.waitingForInvitation);

        verify(authServiceMock.signUp(
          username: username,
          birthdate: birthdate,
        ));
      });
    });

    group('create active account', () {
      test('should set username, birthdate and email and then create account',
          () async {
        // arrange
        final model = SignUpViewModel(
          signUpMode: SignUpMode.createAccount,
          invitationCode: invitationCode,
        );
        // act & assert
        model.goToNextPage();

        expect(model.currentPageType, SignUpPageType.username);
        model.setUserName(username);
        expect(model.username, username);

        expect(model.currentPageType, SignUpPageType.birthday);
        model.setBirthdate(birthdate);
        expect(model.birthdate, birthdate);

        expect(model.currentPageType, SignUpPageType.email);
        model.setEmail(email);
        expect(model.email, email);

        verify(authServiceMock.signUp(
          username: username,
          birthdate: birthdate,
          email: email,
          invitationCode: invitationCode,
        ));
      });
    });
  });
}
