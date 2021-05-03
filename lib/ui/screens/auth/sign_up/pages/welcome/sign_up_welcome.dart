import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/screens/auth/common/widgets/next_button.dart';

import '../../sign_up.viewmodel.dart';

class SignUpWelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.26,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthNextButton(
                      title: translate(
                          'screens.signUp.pages.welcome.actions.next.title'),
                      onPressed: () =>
                          context.read<SignUpViewModel>().goToNextPage(),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () =>
                        context.read<SignUpViewModel>().goToLogin(),
                    child: Text(
                      translate(
                          'screens.signUp.pages.welcome.actions.login.title'),
                      style: const TextStyle(
                          color: TK8Colors.superLightGrey,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
