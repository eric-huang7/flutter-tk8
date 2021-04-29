import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/ui/screens/auth/sign_up/pages/birthdate/sign_up_birthdate.bloc.dart';

import '../../../../../../_helpers/i18n.dart';

void main() {
  group('sign up birthdate page', () {
    final date = DateTime(2000, 1, 2);
    final date2 = DateTime(2000, 10, 20);

    group('state', () {
      test('should use constructor parameters', () async {
        // arrange
        const error = 'Error message';
        const valid = false;
        // act
        final state = SignUpBirthdateState(
          birthdate: date,
          isBirthdateValid: valid,
          errorMessage: error,
        );
        // assert
        expect(state.birthdate, date);
        expect(state.isBirthdateValid, valid);
        expect(state.errorMessage, error);
      });

      test('should initiate with valid birthdate', () async {
        // act
        final state = SignUpBirthdateState.initial(date);
        // assert
        expect(state.birthdate, date);
        expect(state.isBirthdateValid, true);
        expect(state.errorMessage, '');
      });

      test('should initiate with invalid birthdate', () async {
        // act
        const state = SignUpBirthdateState.initial(null);
        // assert
        expect(state.birthdate, null);
        expect(state.isBirthdateValid, false);
        expect(state.errorMessage, '');
      });

      test('should copy state with given parameters', () async {
        // arrange
        const state = SignUpBirthdateState.initial(null);
        const error = 'Error message';
        const valid = true;
        // act
        final stateCopy = state.copyWith(
          birthdate: date,
          errorMessage: error,
          isBirthdateValid: valid,
        );
        // assert
        expect(stateCopy.birthdate, date);
        expect(stateCopy.isBirthdateValid, valid);
        expect(stateCopy.errorMessage, error);
      });
    });

    group('bloc', () {
      initializeTranslationsForTests();

      blocTest<SignUpBirthdateBloc, SignUpBirthdateState>(
        'should start with given valid date',
        build: () => SignUpBirthdateBloc(date),
        verify: (cubit) => cubit.state == SignUpBirthdateState.initial(date),
      );

      blocTest<SignUpBirthdateBloc, SignUpBirthdateState>(
        'should emit invalid state when no date is given',
        build: () => SignUpBirthdateBloc(date),
        act: (cubit) => cubit.updateBirthdate(null),
        expect: [
          const SignUpBirthdateState(
              isBirthdateValid: false,
              errorMessage: 'screens.signUp.errors.invalidBirthdate')
        ],
      );

      blocTest<SignUpBirthdateBloc, SignUpBirthdateState>(
        'should emit valid state when a date is given',
        build: () => SignUpBirthdateBloc(date),
        act: (cubit) => cubit.updateBirthdate(date2),
        expect: [
          SignUpBirthdateState(
            birthdate: date2,
            isBirthdateValid: true,
            errorMessage: '',
          )
        ],
      );
    });
  });
}
