import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _defaultButtonSize = Size(44, 44);
const _defaultIconSize = Size(20, 20);

class SvgIconButton extends StatelessWidget {
  final String iconFileName;
  final VoidCallback onPressed;
  final Color iconColor;
  final Size buttonSize;
  final Size iconSize;

  const SvgIconButton({
    Key key,
    @required this.iconFileName,
    @required this.onPressed,
    this.iconColor,
    this.buttonSize = _defaultButtonSize,
    this.iconSize = _defaultIconSize,
  })  : assert(iconFileName != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: buttonSize.width,
        height: buttonSize.height,
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/$iconFileName.svg',
            height: iconSize.height,
            width: iconSize.width,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
