import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/auth/login/login.viewmodel.dart';

class EnterEmailViewModel extends ChangeNotifier {
  final _authService = getIt<AuthService>();
  final _navigator = getIt<NavigationService>();
  final LoginViewModel _loginViewModel;

  String _lastEnteredEmail;
  bool _isSubmitting = false;
  bool _canSubmit = false;

  String get lastEnteredEmail => _lastEnteredEmail;

  bool get canSubmit => _canSubmit;

  bool get isSubmitting => _isSubmitting;

  EnterEmailViewModel(this._loginViewModel) {
    _lastEnteredEmail = _loginViewModel.usersEmail;
    _canSubmit = _isValid(lastEnteredEmail ?? "");
  }

  void emailEntered(String value) {
    _lastEnteredEmail = value;
    _canSubmit = _isValid(lastEnteredEmail ?? "");
    notifyListeners();
  }

  Future<void> submit() async {
    final emailToSubmit = lastEnteredEmail;
    _isSubmitting = true;
    notifyListeners();
    final result = await _authService.requestOTP(email: emailToSubmit);

    if (result) {
      _loginViewModel.submitEmail(emailToSubmit);
    } else {
      await _navigator.showGenericErrorAlertDialog(onRetry: () => submit());
    }

    _isSubmitting = false;
    notifyListeners();
  }

  bool _isValid(String email) {
    return EmailValidator.validate(email);
  }
}
