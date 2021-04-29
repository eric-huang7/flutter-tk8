import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/repositories/user.repository.dart';
import 'package:tk8/services/services.dart';

class SignUpUsernameState extends Equatable {
  final String username;
  final String errorMessage;
  final bool isUsernameValid;
  final bool checkingUsername;

  const SignUpUsernameState({
    this.username,
    this.errorMessage,
    this.isUsernameValid,
    this.checkingUsername,
  });

  SignUpUsernameState.initial(this.username)
      : errorMessage = '',
        isUsernameValid = username?.isNotEmpty ?? false,
        checkingUsername = false;

  SignUpUsernameState copyWith({
    String username,
    String errorMessage,
    bool isUsernameValid,
    bool checkingUsername,
  }) {
    return SignUpUsernameState(
      username: username ?? this.username,
      errorMessage: errorMessage ?? this.errorMessage,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      checkingUsername: checkingUsername ?? this.checkingUsername,
    );
  }

  @override
  List<Object> get props => [
        username,
        errorMessage,
        isUsernameValid,
        checkingUsername,
      ];

  @override
  bool get stringify => true;
}

class SignUpUsernameBloc extends Cubit<SignUpUsernameState> {
  SignUpUsernameBloc(String username)
      : super(SignUpUsernameState.initial(username));

  final _userRepository = getIt<UserRepository>();
  final _navigator = getIt<NavigationService>();

  Future<void> upateUsername(String value) async {
    emit(state.copyWith(checkingUsername: true));

    try {
      final result = await _userRepository.validateUsername(value);
      if (result == UsernameValidationResult.ok) {
        emit(state.copyWith(
          username: value,
          isUsernameValid: true,
          errorMessage: '',
          checkingUsername: false,
        ));
      } else {
        emit(state.copyWith(
          username: value,
          isUsernameValid: false,
          errorMessage: translate('screens.signUp.errors.invalidUsername'),
          checkingUsername: false,
        ));
      }
    } catch (_) {
      _navigator.showGenericErrorAlertDialog();
      emit(state.copyWith(
        username: value,
        isUsernameValid: false,
        checkingUsername: false,
      ));
    }
  }
}
