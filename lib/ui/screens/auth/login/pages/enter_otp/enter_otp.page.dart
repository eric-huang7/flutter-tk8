import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/screens/auth/login/login.viewmodel.dart';
import 'package:tk8/ui/screens/auth/login/pages/enter_otp/enter_otp.view.dart';

import 'enter_otp.viewmodel.dart';

class EnterOtpPage extends StatelessWidget {
  const EnterOtpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) => ChangeNotifierProvider(
          create: (_) => EnterOtpViewModel(loginViewModel),
          child: const EnterOtpPageView()),
    );
  }
}
