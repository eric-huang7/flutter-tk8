import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/services/services.dart';

enum SignUpPageType {
  welcome,
  username,
  birthday,
  createUser,
  done,
}

final _backgroundTitle = {
  SignUpPageType.welcome: translate('screens.signUp.pages.welcome.title'),
  SignUpPageType.createUser: translate('screens.signUp.pages.done.title'),
};

const _signUpInputPages = [
  SignUpPageType.username,
  SignUpPageType.birthday,
];

class SignUpState {
  final String username;
  final DateTime birthdate;
  final int currentPageIndex;
  final SignUpPageType currentPageType;
  final bool isBusy;

  String get backgroundTitle => _backgroundTitle[currentPageType];

  bool get isCurrentPageInput => _signUpInputPages.contains(currentPageType);

  bool get canGoBack => currentPageIndex > 0 && !isBusy;

  const SignUpState({
    this.username,
    this.birthdate,
    this.currentPageIndex,
    this.currentPageType,
    this.isBusy,
  });

  const SignUpState.initial()
      : username = null,
        birthdate = null,
        isBusy = false,
        currentPageIndex = 0,
        currentPageType = SignUpPageType.welcome;

  SignUpState copyWith({
    String username,
    DateTime birthdate,
    int currentPageIndex,
    SignUpPageType currentPageType,
    bool isBusy,
  }) {
    return SignUpState(
      username: username ?? this.username,
      birthdate: birthdate ?? this.birthdate,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      currentPageType: currentPageType ?? this.currentPageType,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

const _signUpSteps = [
  SignUpPageType.welcome,
  SignUpPageType.username,
  SignUpPageType.birthday,
  SignUpPageType.createUser,
];

class SignUpBloc extends Cubit<SignUpState> {
  SignUpBloc() : super(const SignUpState.initial());

  final _auth = getIt<AuthService>();
  final _navigator = getIt<NavigationService>();

  void goToNextPage() {
    if (state.currentPageIndex == _signUpSteps.length - 1) return;

    final nextPageIndex = state.currentPageIndex + 1;
    final currentPageType = _signUpSteps[nextPageIndex];
    emit(state.copyWith(
      currentPageIndex: nextPageIndex,
      currentPageType: currentPageType,
    ));

    if (currentPageType == SignUpPageType.createUser) {
      signUp();
    }
  }

  void goToPreviousPage() {
    if (state.currentPageIndex == 0) return;
    final nextPageIndex = state.currentPageIndex - 1;
    emit(state.copyWith(
      currentPageIndex: nextPageIndex,
      currentPageType: _signUpSteps[nextPageIndex],
    ));
  }

  void setUserName(String username) {
    emit(state.copyWith(username: username));
    goToNextPage();
  }

  void setBirthdate(DateTime birthdate) {
    emit(state.copyWith(birthdate: birthdate));
    goToNextPage();
  }

  Future<bool> signUp() async {
    emit(state.copyWith(isBusy: true));
    try {
      await _auth.signUp(
        username: state.username,
        birthdate: state.birthdate,
      );
      emit(state.copyWith(isBusy: false));
      return true;
    } on Exception {
      await _navigator.showGenericErrorAlertDialog();
      emit(state.copyWith(isBusy: false));
      return false;
    }
  }

  void goToLogin() {
    _navigator.openLogin();
  }
}
