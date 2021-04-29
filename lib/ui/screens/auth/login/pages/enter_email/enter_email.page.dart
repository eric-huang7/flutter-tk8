import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/screens/auth/login/login.viewmodel.dart';
import 'package:tk8/ui/screens/auth/login/pages/enter_email/enter_email.view.dart';

import 'enter_email.viewmodel.dart';

class EnterEmailPage extends StatelessWidget {
  const EnterEmailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) => ChangeNotifierProvider(
          create: (_) => EnterEmailViewModel(loginViewModel),
          child: const EnterEmailPageView()),
    );
  }
}
