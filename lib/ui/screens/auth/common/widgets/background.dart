import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tk8/ui/resources/app_images.dart';

class AuthBackground extends StatelessWidget {
  final bool keyboardVisible;
  final bool isInputMode;
  final String backgroundTitle;

  const AuthBackground({
    Key key,
    this.keyboardVisible = false,
    this.isInputMode = false,
    this.backgroundTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              TK8Images.backgroundSignup,
              fit: BoxFit.fitWidth,
            ),
          ),
          _buildTitle(context),
          Positioned(
            top: 75,
            left: 20,
            child: SafeArea(
              child: SvgPicture.asset(TK8Images.logoSignup),
            ),
          ),
          if (isInputMode) _buildKeyboardOverlay(context),
          _buildLetsPlayFooter(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (backgroundTitle == null) {
      return const SizedBox();
    }
    return Positioned(
      top: MediaQuery.of(context).size.height / 4,
      left: 20,
      child: Text(
        backgroundTitle,
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: "RevxNeue",
            fontStyle: FontStyle.normal,
            fontSize: 32.0),
      ),
    );
  }

  Widget _buildLetsPlayFooter(BuildContext context) {
    final extraHeight = isInputMode ? 0 : 80;
    return Positioned(
      bottom: 0,
      top: (MediaQuery.of(context).size.height / 3) * 2 - extraHeight,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: keyboardVisible ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: SvgPicture.asset(
          TK8Images.backgroundWelcome,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildKeyboardOverlay(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 310,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0.0023218968531468526),
              end: Alignment(0.5, 0.9720111611688205),
              colors: [Color(0x00ffffff), Color(0x7cffffff), Color(0xffffffff)],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 3,
        ),
      ],
    );
  }
}
