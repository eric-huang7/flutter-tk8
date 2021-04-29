import 'package:flutter/foundation.dart';
import 'package:tk8/services/auth.service.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';

enum LoginStep {
  enterEmail,
  enterOTP,
}

class LoginViewModel extends ChangeNotifier {
  final _authService = getIt<AuthService>();
  final _navigator = getIt<NavigationService>();

  String _usersEmail;
  LoginStep _currentStep = LoginStep.enterEmail;

  String get usersEmail => _usersEmail;

  LoginStep get currentStep => _currentStep;

  void submitEmail(String email) {
    _usersEmail = email;
    _currentStep = LoginStep.enterOTP;
    notifyListeners();
  }

  Future<void> submitOTP(String otp) async {
    final result = await _authService.signIn(email: _usersEmail, otp: otp);

    if (result) {
      _navigator.pop();
    } else {
      await _navigator.showGenericErrorAlertDialog(
          onRetry: () => submitOTP(otp));
    }
  }

  void goBack() {
    switch (currentStep) {
      case LoginStep.enterEmail:
        _navigator.pop();
        break;
      case LoginStep.enterOTP:
        _currentStep = LoginStep.enterEmail;
        notifyListeners();
        break;
    }
  }
}
