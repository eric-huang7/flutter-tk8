import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tk8/services/services.dart';

import '../../sign_up.viewmodel.dart';

class SignUpUsernameViewModel extends ChangeNotifier {
  final _userRepository = getIt<UserRepository>();
  final _navigator = getIt<NavigationService>();

  final SignUpViewModel signUpViewModel;
  final _validateUsernameSubject = BehaviorSubject<String>();
  String _username;
  String _errorMessage;
  bool _isUsernameValid;
  bool _checkingUsername = false;

  String get username => _username;
  String get errorMessage => _errorMessage;
  bool get isUsernameValid => _isUsernameValid;
  bool get checkingUsername => _checkingUsername;

  SignUpUsernameViewModel(this.signUpViewModel) {
    _username = signUpViewModel.username;
    _isUsernameValid = username?.isNotEmpty ?? false;

    _validateUsernameSubject
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen(validateUsernameListener);
  }

  @override
  void dispose() {
    _validateUsernameSubject.close();
    super.dispose();
  }

  Future<void> updateUsername(String value) async {
    _checkingUsername = true;
    notifyListeners();
    _validateUsernameSubject.add(value);
  }

  void submitUsername() {
    signUpViewModel.setUserName(_username);
  }

  @visibleForTesting
  Future<void> validateUsernameListener(String value) async {
    if (value == null || value.isEmpty) {
      _username = '';
      _isUsernameValid = false;
      _errorMessage = translate('screens.signUp.errors.invalidUsername');
      _checkingUsername = false;
      notifyListeners();
      return;
    }

    _username = value;
    _checkingUsername = true;
    notifyListeners();

    try {
      final result = await _userRepository.validateUsername(value);
      if (result == UsernameValidationResult.ok) {
        _isUsernameValid = true;
        _errorMessage = '';
      } else {
        _isUsernameValid = false;
        _errorMessage = translate('screens.signUp.errors.invalidUsername');
      }
      _checkingUsername = false;
      notifyListeners();
    } catch (_) {
      _isUsernameValid = false;
      _checkingUsername = false;
      notifyListeners();
      _navigator.showGenericErrorAlertDialog();
    }
  }
}
