import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../sign_up.viewmodel.dart';

class SignUpEmailViewModel extends ChangeNotifier {
  final SignUpViewModel signUpViewModel;
  String _email;
  bool _canSubmit;

  String get email => _email;
  bool get canSubmit => _canSubmit;

  SignUpEmailViewModel(this.signUpViewModel) {
    _email = signUpViewModel.email;
    _canSubmit = _isValid(_email);
  }

  void updateEmail(String value) {
    _email = value;
    _canSubmit = _isValid(_email);
    notifyListeners();
  }

  void submit() {
    signUpViewModel.setEmail(_email);
  }

  bool _isValid(String email) {
    if (email == null) return false;
    return EmailValidator.validate(email);
  }
}
