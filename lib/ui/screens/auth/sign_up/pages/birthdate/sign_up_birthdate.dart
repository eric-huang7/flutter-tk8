import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/field_container.dart';
import '../../sign_up.bloc.dart';
import 'sign_up_birthdate.bloc.dart';

class SignUpBirthdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpState = context.watch<SignUpBloc>().state;
    return BlocProvider(
      create: (_) => SignUpBirthdateBloc(signUpState.birthdate),
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
    final birthdate = context.read<SignUpBirthdateBloc>().state.birthdate;
    if (birthdate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _selectDate(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageState = context.watch<SignUpBirthdateBloc>().state;
    return AuthFieldContainer(
      title: translate('screens.signUp.pages.birthdate.field.label'),
      buttonTitle: translate('screens.signUp.actions.next.title'),
      onActionPressed: () {
        context.read<SignUpBloc>().setBirthdate(pageState.birthdate);
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
    final bloc = context.read<SignUpBirthdateBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: bloc.state.birthdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      fieldLabelText:
          translate('screens.signUp.pages.birthdate.datePicker.label'),
      helpText:
          translate('screens.signUp.pages.birthdate.datePicker.helperText'),
    );
    if (picked != null && picked != bloc.state.birthdate) {
      bloc.updateBirthdate(picked);
    }
  }
}
