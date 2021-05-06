import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/screens/auth/common/widgets/next_button.dart';

import '../../../common/widgets/field_container.dart';
import '../../../sign_up/sign_up.viewmodel.dart';
import 'sign_up_birthdate.viewmodel.dart';

const _minimumUserAge = 6;
const _maximumAllowedUserAge = 50;

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
  final lastAvailableDate = DateTime(DateTime.now().year - _minimumUserAge,
      DateTime.now().month, DateTime.now().day);
  final firstAvailableDate = DateTime(
      DateTime.now().year - _maximumAllowedUserAge,
      DateTime.now().month,
      DateTime.now().day);

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
      errorMessage: pageState.errorMessage,
      customActionsArea: _buildNextButton(),
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

  Widget _buildNextButton() {
    return Consumer<SignUpBirthdateViewModel>(
        builder: (context, model, child) => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AuthNextButton(
                  title: translate('screens.signUp.actions.next.title'),
                  onPressed: model.isBirthdateValid
                      ? () => context.read<SignUpBirthdateViewModel>().submit()
                      : null,
                )
              ],
            ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    if (theme.platform == TargetPlatform.iOS) {
      return showCupertinoPicker(context,
          firstDate: firstAvailableDate, lastDate: lastAvailableDate);
    } else {
      return showMaterialPicker(context,
          firstDate: firstAvailableDate, lastDate: lastAvailableDate);
    }
  }

  Future<void> showMaterialPicker(BuildContext context,
      {DateTime firstDate, DateTime lastDate}) async {
    final model = context.read<SignUpBirthdateViewModel>();
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: model.birthdate ?? lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
      fieldLabelText:
          translate('screens.signUp.pages.birthdate.datePicker.label'),
      helpText:
          translate('screens.signUp.pages.birthdate.datePicker.helperText'),
    );
    if (pickedDate != null && pickedDate != model.birthdate) {
      model.updateBirthdate(pickedDate);
    }
  }

  Future<void> showCupertinoPicker(BuildContext context,
      {DateTime firstDate, DateTime lastDate}) async {
    final model = context.read<SignUpBirthdateViewModel>();
    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      translate('alerts.actions.confirm.title'),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (pickedDate) {
                        if (pickedDate != null &&
                            pickedDate != model.birthdate) {
                          model.updateBirthdate(pickedDate);
                        }
                      },
                      initialDateTime: model.birthdate ?? lastDate,
                      minimumDate: firstDate,
                      maximumDate: lastDate),
                ),
                const SizedBox(height: 24)
              ],
            ),
          );
        });
  }
}
