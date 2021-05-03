import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/ui/screens/auth/sign_up/pages/birthdate/sign_up_birthdate.viewmodel.dart';

import '../../../../../../_helpers/i18n.dart';
import '../../../../../../_helpers/mocks.dart';

void main() {
  initializeTranslationsForTests();

  group('SignUpBirthdateViewModel', () {
    group('intialization', () {
      test('should intialize with birthdate value from sign up view model',
          () async {
        // arrange
        final date = DateTime(2000);
        final signUpViewModelMock = SignUpViewModelMock();
        when(signUpViewModelMock.birthdate).thenReturn(date);
        // act
        final model = SignUpBirthdateViewModel(signUpViewModelMock);
        // assert
        expect(model.birthdate, date);
        expect(model.errorMessage, '');
        expect(model.isBirthdateValid, isTrue);
      });
      test(
          'should intialize with invalid birthdate when sign up view model as no birthdate',
          () async {
        // arrange
        final signUpViewModelMock = SignUpViewModelMock();
        // act
        final model = SignUpBirthdateViewModel(signUpViewModelMock);
        // assert
        expect(model.birthdate, isNull);
        expect(model.errorMessage, '');
        expect(model.isBirthdateValid, isFalse);
      });
    });
    group('updateBirthdate', () {
      test('should accept any valid date', () async {
        // arrange
        final signUpViewModelMock = SignUpViewModelMock();
        final model = SignUpBirthdateViewModel(signUpViewModelMock);
        final date = DateTime(2000);
        // act
        model.updateBirthdate(date);
        // assert
        expect(model.birthdate, date);
        expect(model.errorMessage, '');
        expect(model.isBirthdateValid, isTrue);
      });
      test('should set invalid date when null is passed', () async {
        // arrange
        final signUpViewModelMock = SignUpViewModelMock();
        final model = SignUpBirthdateViewModel(signUpViewModelMock);
        // act
        model.updateBirthdate(null);
        // assert
        expect(model.birthdate, null);
        expect(model.errorMessage, 'screens.signUp.errors.invalidBirthdate');
        expect(model.isBirthdateValid, isFalse);
      });
    });

    group('submit', () {
      test('should call setBirthdate on sign up view model', () async {
        // arrange
        final date = DateTime(2000);
        final signUpViewModelMock = SignUpViewModelMock();
        when(signUpViewModelMock.birthdate).thenReturn(date);
        final model = SignUpBirthdateViewModel(signUpViewModelMock);
        // act
        model.submit();
        // assert
        verify(signUpViewModelMock.setBirthdate(date));
      });
    });
  });
}
