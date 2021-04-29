import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../bloc/edit_profile.bloc.dart';

class EditProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          _buildProfileBackgroundImage(context),
          _buildProfileImage(context),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 30,
      child: GestureDetector(
        onTap: () {
          context.read<EditProfileBloc>().selectProfileImage();
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: TK8Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x330c2246), blurRadius: 15)
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipOval(child: _profileImage(context)),
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/svg/iconCamera.svg',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileBackgroundImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<EditProfileBloc>().selectBackgroundImage();
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: _backgroundImage(context),
          ),
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
          ),
          Center(
            child: SvgPicture.asset(
              'assets/svg/iconCamera.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileImage(BuildContext context) {
    final state = context.watch<EditProfileBloc>().state;
    if (state.profileImage == null) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Opacity(
          opacity: 0.25,
          child: SvgPicture.asset(
            'assets/svg/iconUser.svg',
            width: 50,
            color: Colors.white,
          ),
        ),
      );
    }
    if (state.profileImage.type == ProfileImageSourceType.web) {
      return NetworkImageView(
        imageUrl: state.profileImage.location,
      );
    } else {
      return Image.file(
        state.profileImage.file,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _backgroundImage(BuildContext context) {
    final state = context.watch<EditProfileBloc>().state;
    if (state.backgroundImage == null) {
      return Image.asset(
        TK8Images.backgroundProfileDefault,
        fit: BoxFit.cover,
      );
    }

    if (state.backgroundImage.type == ProfileImageSourceType.web) {
      return NetworkImageView(
        imageUrl: state.backgroundImage.location,
      );
    } else {
      return Image.file(
        state.backgroundImage.file,
        fit: BoxFit.cover,
      );
    }
  }
}
