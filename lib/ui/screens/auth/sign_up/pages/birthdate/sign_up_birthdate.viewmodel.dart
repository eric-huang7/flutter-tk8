import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../sign_up.viewmodel.dart';

class SignUpBirthdateViewModel extends ChangeNotifier {
  final SignUpViewModel signUpViewModel;
  DateTime _birthdate;
  String _errorMessage = '';
  bool _isBirthdateValid;

  DateTime get birthdate => _birthdate;
  String get errorMessage => _errorMessage;
  bool get isBirthdateValid => _isBirthdateValid;

  SignUpBirthdateViewModel(this.signUpViewModel) {
    _birthdate = signUpViewModel.birthdate;
    _isBirthdateValid = _birthdate != null;
  }

  void updateBirthdate(DateTime value) {
    if (value == null) {
      _isBirthdateValid = false;
      _errorMessage = translate('screens.signUp.errors.invalidBirthdate');
    } else {
      _birthdate = value;
      _isBirthdateValid = true;
      _errorMessage = '';
    }
    notifyListeners();
  }

  void submit() {
    signUpViewModel.setBirthdate(_birthdate);
  }
}
