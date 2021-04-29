import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'bloc/edit_profile.bloc.dart';
import 'widgets/edit_profile_header.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileBloc(),
      child: EditProfileScreenView(),
    );
  }
}

class EditProfileScreenView extends StatefulWidget {
  @override
  _EditProfileScreenViewState createState() => _EditProfileScreenViewState();
}

class _EditProfileScreenViewState extends State<EditProfileScreenView> {
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<EditProfileBloc>().state;
    _usernameController.text = state.username.value;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<EditProfileBloc>().closeScreen();
        return false;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: EditProfileHeader(),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Divider(height: 0),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildUsernameField(context),
                _buildBirthdateField(context),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField(BuildContext context) {
    final state = context.watch<EditProfileBloc>().state;
    return _fieldRow(
      label: translate('screens.myProfile.edit.fields.username.label'),
      field: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: TextField(
            controller: _usernameController,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: "Gotham",
                fontStyle: FontStyle.normal,
                fontSize: 13.0),
            decoration: InputDecoration(
              errorText: state.username.error,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 10, bottom: 11),
              errorStyle: const TextStyle(
                  color: TK8Colors.pink,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Gotham",
                  fontSize: 11,
                  height: 0.3),
            ),
            onChanged: (value) {
              context.read<EditProfileBloc>().updateUsername(value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBirthdateField(BuildContext context) {
    final state = context.watch<EditProfileBloc>().state;
    return _fieldRow(
      label: translate('screens.myProfile.edit.fields.birthdate.label'),
      field: Text(
        state.birthdate.value,
        style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontFamily: "Gotham",
            fontStyle: FontStyle.normal,
            fontSize: 13.0),
      ),
    );
  }

  Widget _fieldRow({String label, Widget field}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 47,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Gotham",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                ),
              ),
              const Space.horizontal(20),
              field,
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final state = context.watch<EditProfileBloc>().state;
    return SliverAppBar(
      title: Text(translate('screens.myProfile.edit.title')),
      automaticallyImplyLeading: false,
      leading: state.isBusy
          ? null
          : BackButton(
              onPressed: () => context.read<EditProfileBloc>().closeScreen(),
            ),
      actions: [
        if (state.isBusy)
          const SizedBox(
            height: 44,
            width: 44,
            child: Center(child: AdaptiveProgressIndicator()),
          )
        else
          IconButton(
            onPressed: () {
              context.read<EditProfileBloc>().saveChanges();
            },
            icon: const Icon(Icons.check),
          )
      ],
    );
  }
}
