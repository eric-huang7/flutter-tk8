import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';

class ChangeEmailViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _userRepository = getIt<UserRepository>();

  String _lastEnteredEmail;
  String _validationError = "";
  bool _isSubmitting = false;

  String get lastEnteredEmail => _lastEnteredEmail;

  String get validationError => _validationError;

  bool get isSubmitting => _isSubmitting;

  bool get canSubmit => 
    _isValid(_lastEnteredEmail) && _lastEnteredEmail != (_userRepository.myProfileUser.email);

  bool get isEmailChanged =>
    _lastEnteredEmail != (_userRepository.myProfileUser.email);

  ChangeEmailViewModel() {
    _lastEnteredEmail = _userRepository.myProfileUser.email;
  }

  void emailEntered(String value) {
    _lastEnteredEmail = value;
    if (!_isValid(_lastEnteredEmail)) {
      _validationError = translate('screens.myProfile.settings.changeEmail.invalidEmail');
    } else {
      _validationError = "";
    }
    notifyListeners();
  }

  Future<void> submit() async {
    final emailToSubmit = lastEnteredEmail;
    _isSubmitting = true;
    notifyListeners();
    try {
      if (_isValid(emailToSubmit)) {
        await _userRepository.updateUserEmail(email: emailToSubmit);
        _navigator.pop();
      }      
    } catch (e) {
      _navigator.showGenericErrorAlertDialog();
      debugPrint("changeEmail submit catch: $e");
    }
    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> closeScreen() async {
    if (isEmailChanged) {
      final discardChanges = await _navigator.showAlertDialog(
        AlertInfo(
          title: translate('screens.myProfile.edit.discardChangesAlert.title'),
          text: translate('screens.myProfile.edit.discardChangesAlert.text'),
          actions: [
            AlertAction(
              title: translate('alerts.actions.cancel.title'),
              popOnPressed: false,
              onPressed: () => _navigator.pop(false),
            ),
            AlertAction(
              title: translate('screens.myProfile.edit.discardChangesAlert.actions.discard.title'),
              popOnPressed: false,
              onPressed: () => _navigator.pop(true),
            ),
          ],
        ),
      );
      if (!(discardChanges ?? false)) return;
    }
    _navigator.pop();
  }

  bool _isValid(String email) {
    return EmailValidator.validate(email);
  }
}