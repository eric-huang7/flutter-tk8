import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../my_profile.bloc.dart';

class MyProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          _buildProfileBackgroundImage(context),
          _buildProfileHeaderInfo(context),
          _buildTitleAndActions(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderInfo(BuildContext context) {
    final state = context.watch<MyProfileBloc>().state;
    return Positioned(
      bottom: 25,
      left: 30,
      right: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserProfileImage(context),
          const Space.horizontal(25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Space.vertical(5),
              Text(
                state.username,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              const Space.vertical(5),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/iconUser.svg',
                    color: Colors.white,
                    height: 13,
                  ),
                  const Space.horizontal(5),
                  Text(
                    translate(
                      'screens.myProfile.view.header.age',
                      args: {'age': state.age},
                    ),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Gotham",
                        fontStyle: FontStyle.normal,
                        fontSize: 9.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileImage(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: TK8Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [BoxShadow(color: Color(0x330c2246), blurRadius: 15)],
      ),
      child: ClipOval(child: _profileImage(context)),
    );
  }

  Widget _buildProfileBackgroundImage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _backgroundImage(context)),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0x260c2246), blurRadius: 15)],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0.0023218968531468526),
              end: Alignment(0.5, 1),
              colors: [Color(0x33000000), Color(0xd9000000)],
            ),
          ),
        )
      ],
    );
  }

  Widget _profileImage(BuildContext context) {
    final state = context.watch<MyProfileBloc>().state;
    if (state.profileImageUrl == null) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          'assets/svg/iconUser.svg',
          color: Colors.white,
        ),
      );
    }
    return NetworkImageView(imageUrl: state.profileImageUrl);
  }

  Widget _backgroundImage(BuildContext context) {
    final state = context.watch<MyProfileBloc>().state;
    if (state.backgroundImageUrl == null) {
      return Image.asset(
        TK8Images.backgroundProfileDefault,
        fit: BoxFit.cover,
      );
    }

    return NetworkImageView(
      imageUrl: state.backgroundImageUrl,
    );
  }

  Widget _buildTitleAndActions(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgIconButton(
                onPressed: () => context.read<MyProfileBloc>().editProfile(),
                iconFileName: 'iconEdit',
                iconColor: Colors.white,
              ),
              Text(
                translate('screens.myProfile.view.header.title'),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SvgIconButton(
                onPressed: () => context.read<MyProfileBloc>().openProfileSettings(),
                iconFileName: 'iconSettings',
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
