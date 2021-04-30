import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tk8/config/styles.config.dart';

import '../common/widgets/background.dart';
import 'pages/birthdate/sign_up_birthdate.dart';
import 'pages/create_user/sign_up_create_user.dart';
import 'pages/username/sign_up_username.dart';
import 'pages/welcome/sign_up_welcome.dart';
import 'sign_up.bloc.dart';

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
                _buildAppBar(context),
                _buildPage(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBackground() {
    return BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (prevState, curState) =>
            prevState.backgroundTitle != curState.backgroundTitle ||
            prevState.isCurrentPageInput != curState.isCurrentPageInput,
        builder: (context, state) {
          return AuthBackground(
              keyboardVisible: _isKeyboardVisible,
              backgroundTitle: state.backgroundTitle,
              isInputMode: state.isCurrentPageInput);
        });
  }

  Widget _buildAppBar(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: state.canGoBack
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: TK8Colors.ocean,
                  ),
                  onPressed: () {
                    context.read<SignUpBloc>().goToPreviousPage();
                  },
                )
              : null,
        );
      },
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = context.watch<SignUpBloc>();
    switch (bloc.state.currentPageType) {
      case SignUpPageType.welcome:
        return SignUpWelcomePage();
      case SignUpPageType.username:
        return SignUpUsernamePage();
      case SignUpPageType.birthday:
        return SignUpBirthdatePage();
      case SignUpPageType.createUser:
        return SignUpCreateUserPage();
      default:
        return Center(
          child: Text(
              'Page of type ${bloc.state.currentPageType} not implemented'),
        );
    }
  }

  void _onKeyboardVisibilityChange(bool isVisible) {
    setState(() => _isKeyboardVisible = isVisible);
  }
}
