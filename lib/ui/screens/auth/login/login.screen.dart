import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/screens/auth/common/widgets/background.dart';

import 'login.viewmodel.dart';
import 'pages/enter_email/enter_email.page.dart';
import 'pages/enter_otp/enter_otp.page.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildSignUpBackground() {
    return AuthBackground(
        backgroundTitle: translate("screens.login.title"),
        isInputMode: true,
        keyboardVisible: true);
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Consumer<LoginViewModel>(
        builder: (context, model, child) => IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: model.goBack,
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, model, child) {
      switch (model.currentStep) {
        case LoginStep.enterEmail:
          return const EnterEmailPage();
        case LoginStep.enterOTP:
          return const EnterOtpPage();
      }

      return Container();
    });
  }
}
