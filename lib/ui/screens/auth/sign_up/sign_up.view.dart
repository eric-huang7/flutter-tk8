import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/screens/auth/sign_up/pages/busy/sign_up_busy.dart';

import '../common/widgets/background.dart';
import 'pages/birthdate/sign_up_birthdate.dart';
import 'pages/email/sign_up_email.dart';
import 'pages/username/sign_up_username.dart';
import 'pages/waiting_invitation/sign_up_waiting_invitation.dart';
import 'pages/welcome/sign_up_welcome.dart';
import 'sign_up.viewmodel.dart';

class SignUpScreenView extends StatefulWidget {
  @override
  _SignUpScreenViewState createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreenView> {
  StreamSubscription<bool> keyboardListener;
  bool _isKeyboardVisible;

  @override
  void initState() {
    super.initState();
    final keyboardVisibilityController = KeyboardVisibilityController();
    _isKeyboardVisible = keyboardVisibilityController.isVisible;
    keyboardListener =
        keyboardVisibilityController.onChange.listen((isVisible) {
      _onKeyboardVisibilityChange(isVisible);
    });
  }

  @override
  void dispose() {
    keyboardListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildSignUpBackground(),
          Positioned.fill(
            child: Column(
              children: [
                _buildAppBar(),
                _buildPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBackground() {
    final model = context.watch<SignUpViewModel>();
    return AuthBackground(
        keyboardVisible: _isKeyboardVisible,
        backgroundTitle: model.backgroundTitle,
        isInputMode: model.isCurrentPageInput);
  }

  Widget _buildAppBar() {
    final model = context.watch<SignUpViewModel>();
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: model.canGoBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: TK8Colors.ocean,
              ),
              onPressed: () {
                context.read<SignUpViewModel>().goToPreviousPage();
              },
            )
          : null,
    );
  }

  Widget _buildPage() {
    final model = context.watch<SignUpViewModel>();
    if (model.isBusy) return SignUpBusyPage();

    switch (model.currentPageType) {
      case SignUpPageType.welcome:
        return SignUpWelcomePage();
      case SignUpPageType.username:
        return SignUpUsernamePage();
      case SignUpPageType.birthday:
        return SignUpBirthdatePage();
      case SignUpPageType.email:
        return SignUpEmailPage();
      case SignUpPageType.waitingForInvitation:
        return SignUpWaitingInvitationPage();
      default:
        return Center(
          child: Text('Page of type ${model.currentPageType} not implemented'),
        );
    }
  }

  void _onKeyboardVisibilityChange(bool isVisible) {
    setState(() => _isKeyboardVisible = isVisible);
  }
}
