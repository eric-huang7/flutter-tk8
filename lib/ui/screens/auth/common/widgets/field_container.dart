import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'next_button.dart';

class AuthFieldContainer extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final Widget child;
  final VoidCallback onActionPressed;
  final String errorMessage;
  final String hintMessage;
  final Widget messageAreaChild;
  final Widget customActionsArea;

  const AuthFieldContainer({
    Key key,
    @required this.title,
    @required this.child,
    this.onActionPressed,
    this.errorMessage,
    this.hintMessage,
    this.buttonTitle,
    this.messageAreaChild,
    this.customActionsArea,
  })  : assert(
          (onActionPressed != null && buttonTitle != null) ||
              customActionsArea != null,
          'either onActionPressed and buttonTitle or customActionsArea must be set',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: max(MediaQuery.of(context).size.height * 0.35,
                MediaQuery.of(context).viewInsets.bottom + 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "RevxNeue",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                  const Space.vertical(10),
                  child,
                  const Space.vertical(10),
                  if (errorMessage != null)
                    Text(errorMessage ?? '',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Gotham",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0))
                  else
                    Text(hintMessage ?? '',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Gotham",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0)),
                  const Space.vertical(10),
                  if (customActionsArea != null)
                    customActionsArea
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AuthNextButton(
                          title: buttonTitle,
                          onPressed: onActionPressed,
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
