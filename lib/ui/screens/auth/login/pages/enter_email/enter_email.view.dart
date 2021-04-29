import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/screens/auth/common/widgets/auth_input_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/field_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/next_button.dart';
import 'package:tk8/ui/screens/auth/login/pages/enter_email/enter_email.viewmodel.dart';
import 'package:tk8/ui/widgets/space.dart';

class EnterEmailPageView extends StatefulWidget {
  const EnterEmailPageView({Key key}) : super(key: key);

  @override
  _EnterEmailPageViewState createState() => _EnterEmailPageViewState();
}

class _EnterEmailPageViewState extends State<EnterEmailPageView> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: context.read<EnterEmailViewModel>().lastEnteredEmail ?? '');
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
            child: Consumer<EnterEmailViewModel>(
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
                  model.emailEntered(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Consumer<EnterEmailViewModel>(
      builder: (context, model, child) => AuthNextButton(
          title: translate('screens.login.pages.enterEmail.next'),
          onPressed: model.canSubmit ? model.submit : null,
          isLoading: model.isSubmitting),
    );
  }

  Widget _buildExplanationText() {
    return Expanded(
        child: Text(translate("screens.login.pages.enterEmail.explanation"),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: "Gotham",
                fontStyle: FontStyle.normal,
                fontSize: 10.0)));
  }
}
