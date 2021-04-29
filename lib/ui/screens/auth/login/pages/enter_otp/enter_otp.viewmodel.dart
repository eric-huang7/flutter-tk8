import 'package:flutter/material.dart';

import '../../login.viewmodel.dart';

class EnterOtpViewModel extends ChangeNotifier {
  final RegExp _otpPattern = RegExp(r"^[0-9A-Za-z]{6}$");
  final LoginViewModel _loginViewModel;

  bool _canSubmit = false;
  bool _isSubmitting = false;
  String _lastEnteredOtp;

  String get lastEnteredOtp => _lastEnteredOtp;

  bool get canSubmit => _canSubmit;

  bool get isSubmitting => _isSubmitting;

  EnterOtpViewModel(this._loginViewModel);

  void otpEntered(String value) {
    _lastEnteredOtp = value;

    _canSubmit = _isValid(value);
    notifyListeners();
  }

  Future<void> submit() async {
    _isSubmitting = true;
    notifyListeners();
    await _loginViewModel.submitOTP(lastEnteredOtp);
    _isSubmitting = false;
    notifyListeners();
  }

  bool _isValid(String value) {
    return _otpPattern.hasMatch(value);
  }
}
