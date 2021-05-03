import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:tk8/ui/screens/auth/common/widgets/auth_input_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/field_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/next_button.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../../sign_up.viewmodel.dart';
import 'sign_up_email.viewmodel.dart';

class SignUpEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpViewModel = context.watch<SignUpViewModel>();
    return ChangeNotifierProvider(
      create: (_) => SignUpEmailViewModel(signUpViewModel),
      child: const SignUpEmailPageView(),
    );
  }
}

class SignUpEmailPageView extends StatefulWidget {
  const SignUpEmailPageView({Key key}) : super(key: key);

  @override
  _SignUpEmailPageViewState createState() => _SignUpEmailPageViewState();
}

class _SignUpEmailPageViewState extends State<SignUpEmailPageView> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: context.read<SignUpEmailViewModel>().email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AuthFieldContainer(
      title: translate('screens.login.pages.enterEmail.field.label'),
      customActionsArea: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildExplanationText(),
          const Space.horizontal(10),
          _buildNextButton(),
        ],
      ),
      child: _buildTextInput(),
    );
  }

  Widget _buildTextInput() {
    return AuthInputContainer(
      child: Row(
        children: [
          Expanded(
            child: Consumer<SignUpEmailViewModel>(
              builder: (context, model, child) => TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                autocorrect: false,
                decoration: const InputDecoration.collapsed(hintText: ''),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
                textInputAction: TextInputAction.next,
                onEditingComplete: () {},
                onChanged: (value) {
                  model.updateEmail(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final model = context.watch<SignUpEmailViewModel>();
    return AuthNextButton(
      title: translate('screens.login.pages.enterEmail.next'),
      onPressed: model.canSubmit ? model.submit : null,
    );
  }

  Widget _buildExplanationText() {
    return Expanded(
      child: Text(
        translate("screens.login.pages.enterEmail.explanation"),
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontFamily: "Gotham",
            fontStyle: FontStyle.normal,
            fontSize: 10.0),
      ),
    );
  }
}
