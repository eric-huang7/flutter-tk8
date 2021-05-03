import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/ui/screens/auth/sign_up/pages/email/sign_up_email.viewmodel.dart';

import '../../../../../../_helpers/i18n.dart';
import '../../../../../../_helpers/mocks.dart';

void main() {
  initializeTranslationsForTests();

  group('SignUpEmailViewModel', () {
    group('initialization', () {
      test('should intialize with email value from sign up view model',
          () async {
        // arrange
        const email = 'toni@kroos.de';
        final signUpViewModelMock = SignUpViewModelMock();
        when(signUpViewModelMock.email).thenReturn(email);
        // act
        final model = SignUpEmailViewModel(signUpViewModelMock);
        // assert
        expect(model.email, email);
        expect(model.canSubmit, isTrue);
      });
      test(
          'should set can submit to false when sign up view model has no email',
          () async {
        // arrange
        final signUpViewModelMock = SignUpViewModelMock();
        // act
        final model = SignUpEmailViewModel(signUpViewModelMock);
        // assert
        expect(model.email, null);
        expect(model.canSubmit, isFalse);
      });
    });
    group('updateEmail', () {
      test('should accept any valid email', () async {
        // arrange
        const email = 'toni@kroos.de';
        final signUpViewModelMock = SignUpViewModelMock();
        final model = SignUpEmailViewModel(signUpViewModelMock);
        // act
        model.updateEmail(email);
        // assert
        expect(model.email, email);
        expect(model.canSubmit, isTrue);
      });
      test('should set can submit to false when invalid email is given',
          () async {
        // arrange
        const email = 'toni@kroos';
        final signUpViewModelMock = SignUpViewModelMock();
        final model = SignUpEmailViewModel(signUpViewModelMock);
        // act
        model.updateEmail(email);
        // assert
        expect(model.email, email);
        expect(model.canSubmit, isFalse);
      });
      test('should set can submit to false when null email value is given',
          () async {
        // arrange
        final signUpViewModelMock = SignUpViewModelMock();
        final model = SignUpEmailViewModel(signUpViewModelMock);
        // act
        model.updateEmail(null);
        // assert
        expect(model.email, isNull);
        expect(model.canSubmit, isFalse);
      });
    });
    group('submit', () {
      test('should call setEmail on sign up view model', () async {
        // arrange
        const email = 'toni@kroos.de';
        final signUpViewModelMock = SignUpViewModelMock();
        when(signUpViewModelMock.email).thenReturn(email);
        final model = SignUpEmailViewModel(signUpViewModelMock);
        // act
        model.submit();
        // assert
        verify(signUpViewModelMock.setEmail(email));
      });
    });
  });
}
