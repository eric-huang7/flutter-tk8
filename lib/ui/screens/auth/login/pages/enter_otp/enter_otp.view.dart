import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/screens/auth/common/widgets/auth_input_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/field_container.dart';
import 'package:tk8/ui/screens/auth/common/widgets/next_button.dart';
import 'package:tk8/ui/screens/auth/login/pages/enter_otp/enter_otp.viewmodel.dart';

class EnterOtpPageView extends StatefulWidget {
  const EnterOtpPageView({Key key}) : super(key: key);

  @override
  _EnterOtpPageViewState createState() => _EnterOtpPageViewState();
}

class _EnterOtpPageViewState extends State<EnterOtpPageView> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: context.read<EnterOtpViewModel>().lastEnteredOtp ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AuthFieldContainer(
      title: translate('screens.login.pages.enterOTP.field.label'),
      customActionsArea: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildNextButton()],
      ),
      child: _buildTextInput(),
    );
  }

  Widget _buildNextButton() {
    return Consumer<EnterOtpViewModel>(
      builder: (context, model, child) => AuthNextButton(
        title: translate('screens.login.pages.enterOTP.next'),
        onPressed: model.canSubmit ? model.submit : null,
        isLoading: model.isSubmitting,
      ),
    );
  }

  Widget _buildTextInput() {
    return AuthInputContainer(
      child: Row(
        children: [
          Expanded(
            child: Consumer<EnterOtpViewModel>(
              builder: (context, model, child) => TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
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
                onEditingComplete: () {},
                onChanged: (value) {
                  model.otpEntered(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
