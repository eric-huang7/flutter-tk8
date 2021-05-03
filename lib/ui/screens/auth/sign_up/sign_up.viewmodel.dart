import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/services/services.dart';

enum SignUpMode {
  createAccount,
  waitingForInvitation,
  activateAccount,
}

enum SignUpPageType {
  welcome,
  username,
  birthday,
  email,
  waitingForInvitation,
}

final _backgroundTitle = {
  SignUpPageType.welcome: translate('screens.signUp.pages.welcome.title'),
  SignUpPageType.waitingForInvitation:
      translate('screens.signUp.pages.waitingForInvitation.title'),
};

@visibleForTesting
const signUpInputPages = [
  SignUpPageType.username,
  SignUpPageType.birthday,
  SignUpPageType.email,
];

@visibleForTesting
const createInactiveAccountSteps = [
  SignUpPageType.welcome,
  SignUpPageType.username,
  SignUpPageType.birthday,
];

@visibleForTesting
const createActiveAccountSteps = [
  SignUpPageType.welcome,
  SignUpPageType.username,
  SignUpPageType.birthday,
  SignUpPageType.email,
];

@visibleForTesting
const activateAccountSteps = [
  SignUpPageType.email,
];

@visibleForTesting
const waitingForInvitationSteps = [
  SignUpPageType.waitingForInvitation,
];

class SignUpViewModel extends ChangeNotifier {
  final _auth = getIt<AuthService>();
  final _navigator = getIt<NavigationService>();

  final SignUpMode signUpMode;
  final String invitationCode;

  String _username;
  DateTime _birthdate;
  String _email;

  @visibleForTesting
  List<SignUpPageType> signUpSteps;

  SignUpPageType _currentPageType;
  int _currentPageIndex = 0;
  bool _flowCompleted = false;
  bool _isBusy = false;

  SignUpViewModel({
    @required this.signUpMode,
    this.invitationCode,
  }) : assert(signUpMode != null) {
    switch (signUpMode) {
      case SignUpMode.waitingForInvitation:
        _flowCompleted = true;
        signUpSteps = waitingForInvitationSteps;
        break;
      case SignUpMode.activateAccount:
        assert(invitationCode != null);
        signUpSteps = activateAccountSteps;
        break;
      case SignUpMode.createAccount:
      default:
        signUpSteps = invitationCode == null
            ? createInactiveAccountSteps
            : createActiveAccountSteps;
    }
    _currentPageType = signUpSteps[0];
  }

  SignUpPageType get currentPageType => _currentPageType;
  String get username => _username;
  DateTime get birthdate => _birthdate;
  String get email => _email;
  bool get isBusy => _isBusy;

  String get backgroundTitle => _backgroundTitle[currentPageType];
  bool get isCurrentPageInput => signUpInputPages.contains(currentPageType);
  bool get canGoBack => _currentPageIndex > 0 && !isBusy;

  /// update sign up data

  void setUserName(String username) {
    _username = username;
    goToNextPage();
  }

  void setBirthdate(DateTime birthdate) {
    _birthdate = birthdate;
    goToNextPage();
  }

  void setEmail(String email) {
    _email = email;
    goToNextPage();
  }

  /// navigation

  void goToNextPage() {
    if (_currentPageIndex == signUpSteps.length - 1) {
      if (!_flowCompleted) _completeFlow();
      return;
    }

    _currentPageIndex += 1;
    _currentPageType = signUpSteps[_currentPageIndex];

    notifyListeners();
  }

  void goToPreviousPage() {
    if (_currentPageIndex == 0 || _flowCompleted) return;

    _currentPageIndex -= 1;
    _currentPageType = signUpSteps[_currentPageIndex];

    notifyListeners();
  }

  void goToLogin() {
    _navigator.openLogin();
  }

  /// actions

  Future<void> _completeFlow() async {
    switch (signUpMode) {
      case SignUpMode.createAccount:
        if (invitationCode == null) {
          _createInactiveAccount();
        } else {
          _createActiveAccount();
        }
        break;
      case SignUpMode.activateAccount:
        _activateAccount();
        break;
      default:
        assert(false, 'invalid sign up mode');
    }
  }

  Future<void> _createInactiveAccount() async {
    assert(username != null && username.isNotEmpty);
    assert(birthdate != null);

    _isBusy = true;
    notifyListeners();

    try {
      await _auth.signUp(
        username: username,
        birthdate: birthdate,
      );
      _flowCompleted = true;
    } on Exception {
      await _navigator.showGenericErrorAlertDialog(
        onRetry: () => _createInactiveAccount(),
      );
    }

    _isBusy = false;
    _currentPageType = SignUpPageType.waitingForInvitation;
    notifyListeners();
  }

  Future<void> _createActiveAccount() async {
    assert(username != null && username.isNotEmpty);
    assert(email != null && email.isNotEmpty);
    assert(birthdate != null);

    _isBusy = true;
    notifyListeners();

    try {
      await _auth.signUp(
        username: username,
        birthdate: birthdate,
        email: email,
        invitationCode: invitationCode,
      );
      _flowCompleted = true;
    } on Exception {
      await _navigator.showGenericErrorAlertDialog(
        onRetry: () => _createActiveAccount(),
      );
    }

    _isBusy = false;
    notifyListeners();
  }

  Future<void> _activateAccount() async {
    assert(email != null && email.isNotEmpty);

    _isBusy = true;
    notifyListeners();

    try {
      await _auth.activateAccount(
        email: email,
        invitationCode: invitationCode,
      );
      _flowCompleted = true;
    } on Exception {
      await _navigator.showGenericErrorAlertDialog(
        onRetry: () => _activateAccount(),
      );
    }

    _isBusy = false;
    notifyListeners();
  }
}
