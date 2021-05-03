import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/field_container.dart';
import '../../../sign_up/sign_up.viewmodel.dart';
import 'sign_up_birthdate.viewmodel.dart';

class SignUpBirthdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpViewModel = context.watch<SignUpViewModel>();
    return ChangeNotifierProvider(
      create: (_) => SignUpBirthdateViewModel(signUpViewModel),
      child: SignUpBirthdatePageView(),
    );
  }
}

class SignUpBirthdatePageView extends StatefulWidget {
  @override
  _SignUpBirthdatePageViewState createState() =>
      _SignUpBirthdatePageViewState();
}

class _SignUpBirthdatePageViewState extends State<SignUpBirthdatePageView> {
  @override
  void initState() {
    super.initState();
    final birthdate = context.read<SignUpBirthdateViewModel>().birthdate;
    if (birthdate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _selectDate(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<SignUpBirthdateViewModel>();
    return AuthFieldContainer(
      title: translate('screens.signUp.pages.birthdate.field.label'),
      buttonTitle: translate('screens.signUp.actions.next.title'),
      onActionPressed: () {
        context.read<SignUpBirthdateViewModel>().submit();
      },
      errorMessage: pageState.errorMessage,
      child: GestureDetector(
        onTap: () async => _selectDate(context),
        child: Container(
          height: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            boxShadow: [
              BoxShadow(
                color: Color(0x260c2246),
                blurRadius: 15,
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: pageState.birthdate == null
              ? const SizedBox(width: double.infinity)
              : Center(
                  child: Text(
                    DateFormat.yMMMMd().format(pageState.birthdate),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gotham",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final model = context.read<SignUpBirthdateViewModel>();
    final picked = await showDatePicker(
      context: context,
      initialDate: model.birthdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      fieldLabelText:
          translate('screens.signUp.pages.birthdate.datePicker.label'),
      helpText:
          translate('screens.signUp.pages.birthdate.datePicker.helperText'),
    );
    if (picked != null && picked != model.birthdate) {
      model.updateBirthdate(picked);
    }
  }
}
