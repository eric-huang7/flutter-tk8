import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';
import 'package:tk8/ui/screens/auth/common/widgets/auth_input_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/field_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/next_button.dart';
import 'package:tk8/ui/widgets/text_anchor/flutter_text_anchor.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../../sign_up.viewmodel.dart';
import 'sign_up_username.viewmodel.dart';

class _PrivacyLinks {
  static const termsOfService = 'http://tos';
  static const privacyPolicy = 'http://privacy';
}

class SignUpUsernamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpViewModel = context.watch<SignUpViewModel>();
    return ChangeNotifierProvider(
      create: (_) => SignUpUsernameViewModel(signUpViewModel),
      child: SignUpUsernamePageView(),
    );
  }
}

class SignUpUsernamePageView extends StatefulWidget {
  @override
  _SignUpUsernamePageViewState createState() => _SignUpUsernamePageViewState();
}

class _SignUpUsernamePageViewState extends State<SignUpUsernamePageView> {
  final _navigator = getIt<NavigationService>();
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<SignUpUsernameViewModel>().username,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<SignUpUsernameViewModel>();
    return AuthFieldContainer(
      title: translate('screens.signUp.pages.username.field.label'),
      errorMessage: pageState.errorMessage ?? '',
      customActionsArea: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextAnchor(
              translate('screens.signUp.pages.username.legal'),
              onTapLink: _onTapMessageLink,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Gotham",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              linkStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Gotham",
                  decoration: TextDecoration.underline,
                  fontSize: 10.0),
            ),
          ),
          const Space.horizontal(10),
          AuthNextButton(
            title: translate('screens.signUp.actions.next.title'),
            onPressed: pageState.isUsernameValid && !pageState.checkingUsername
                ? () => context.read<SignUpUsernameViewModel>().submitUsername()
                : null,
          ),
        ],
      ),
      child: AuthInputContainer(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration.collapsed(hintText: ''),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  if (pageState.isUsernameValid) {
                    context.read<SignUpUsernameViewModel>().submitUsername();
                  }
                },
                onChanged: (value) {
                  context.read<SignUpUsernameViewModel>().updateUsername(value);
                },
              ),
            ),
            if (pageState.isUsernameValid && !pageState.checkingUsername)
              const Icon(
                Icons.check,
                color: TK8Colors.ocean,
              ),
            if (pageState.checkingUsername)
              const AdaptiveProgressIndicator(size: 20),
          ],
        ),
      ),
    );
  }

  void _onTapMessageLink(link) {
    // this is temporary, so no need to add this alert texts in translations
    if (link == _PrivacyLinks.termsOfService) {
      _navigator.showAlertDialog(AlertInfo(
        title: 'Terms of Service',
        actions: const [AlertAction(title: 'ok')],
      ));
    }
    if (link == _PrivacyLinks.privacyPolicy) {
      _navigator.showAlertDialog(AlertInfo(
        title: 'Privacy Policy',
        actions: const [AlertAction(title: 'ok')],
      ));
    }
  }
}
