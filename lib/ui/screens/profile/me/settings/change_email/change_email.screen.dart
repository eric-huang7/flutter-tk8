import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/screens/profile/me/settings/change_email/change_email.viewmodel.dart';
import 'package:tk8/ui/widgets/widgets.dart';

class ChangeEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangeEmailViewModel(),
      child: _ChangeEmailScreenView(),
    );
  }
}

class _ChangeEmailScreenView extends StatelessWidget {
  final _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeEmailViewModel>(
      builder: (context, model, child) {
        // Alternative is to use stateful widget's initState
        if (_emailController.text.isEmpty) _emailController.text = model.lastEnteredEmail;
        return WillPopScope(
          onWillPop: () async {
            model.closeScreen();
            return false;
          },
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: ListView(
              children: [
                const SizedBox(height: 20),
                _buildEmailField(context), 
              ],
            ),
          ),
        );
      }
    );
  }
  
  Widget _buildEmailField(BuildContext context) {
    final model = context.read<ChangeEmailViewModel>();
    const _errorTextStyle = TextStyle(
      color: TK8Colors.pink,
      fontWeight: FontWeight.w400,
      fontFamily: "Gotham",
      fontSize: 11,
      height: 0.3,
    );
    const _emailTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontFamily: "Gotham",
      fontStyle: FontStyle.normal,
      fontSize: 15.0,
    );

    return Column(
      children: [
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  autofocus: true,
                  style: _emailTextStyle,
                  decoration: InputDecoration(
                    errorText: model.validationError,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 10),
                    errorStyle: _errorTextStyle,
                  ),
                  onChanged: (value) {
                    model.emailEntered(value);
                  },
                ),
              ),
            ],
          ),
        ),
        if (model.validationError.isEmpty) Container() 
          else const SizedBox(height: 8),
        const Divider(height: 0),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final model = context.read<ChangeEmailViewModel>();
    return AppBar(
      title: Text(translate('screens.myProfile.settings.changeEmail.title')),
      automaticallyImplyLeading: false,
      leading: model.isSubmitting 
        ? null 
        : BackButton(
            onPressed: () => model.closeScreen(),
        ),
      actions: [
        if (model.isSubmitting)
          const SizedBox(
            height: 44,
            width: 44,
            child: Center(child: AdaptiveProgressIndicator()),
          )
        else IconButton(
          onPressed: !model.canSubmit 
            ? null
            : () {
              model.submit();
            },
          icon: const Icon(Icons.check),
        )
      ],
    );
  }
}