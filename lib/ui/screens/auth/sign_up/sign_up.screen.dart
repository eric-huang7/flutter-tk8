import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_up.view.dart';
import 'sign_up.viewmodel.dart';
export 'sign_up.viewmodel.dart' show SignUpMode;

class SignUpScreen extends StatelessWidget {
  final SignUpMode signUpMode;
  final String invitationCode;
  final SignUpViewModel _viewModel;

  SignUpScreen({
    Key key,
    @required this.signUpMode,
    this.invitationCode,
  })  : _viewModel = SignUpViewModel(
          signUpMode: signUpMode,
          invitationCode: invitationCode,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: SignUpScreenView(),
    );
  }
}
