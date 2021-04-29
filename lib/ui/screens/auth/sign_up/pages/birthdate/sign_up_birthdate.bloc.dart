import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SignUpBirthdateState extends Equatable {
  final DateTime birthdate;
  final String errorMessage;
  final bool isBirthdateValid;

  const SignUpBirthdateState({
    this.birthdate,
    this.errorMessage,
    this.isBirthdateValid,
  });

  const SignUpBirthdateState.initial(this.birthdate)
      : isBirthdateValid = birthdate != null,
        errorMessage = '';

  SignUpBirthdateState copyWith({
    DateTime birthdate,
    String errorMessage,
    bool isBirthdateValid,
  }) {
    return SignUpBirthdateState(
      birthdate: birthdate ?? this.birthdate,
      errorMessage: errorMessage ?? this.errorMessage,
      isBirthdateValid: isBirthdateValid ?? this.isBirthdateValid,
    );
  }

  @override
  List<Object> get props => [birthdate, errorMessage, isBirthdateValid];

  @override
  bool get stringify => true;
}

class SignUpBirthdateBloc extends Cubit<SignUpBirthdateState> {
  SignUpBirthdateBloc(DateTime birthdate)
      : super(SignUpBirthdateState.initial(birthdate));

  void updateBirthdate(DateTime value) {
    if (value == null) {
      emit(SignUpBirthdateState(
        isBirthdateValid: false,
        errorMessage: translate('screens.signUp.errors.invalidBirthdate'),
      ));
      return;
    }
    emit(state.copyWith(
      birthdate: value,
      isBirthdateValid: true,
      errorMessage: '',
    ));
  }
}
