import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_alert.dart';

@immutable
class AlertAction {
  final String title;
  final VoidCallback onPressed;
  final bool isDefault;
  final bool isDestructive;
  final bool popOnPressed;

  const AlertAction({
    @required this.title,
    this.onPressed,
    this.popOnPressed = true,
    this.isDefault = false,
    this.isDestructive = false,
  }) : assert(onPressed != null || popOnPressed);
}

@immutable
class AlertInfo {
  final String title;
  final String text;
  final List<AlertAction> actions;
  final bool isVerticalActionsAlignment;

  const AlertInfo(
      {this.title,
      this.text,
      @required this.actions,
      this.isVerticalActionsAlignment = false})
      : assert(actions != null && actions.length > 0);
}

Future<T> showAlertDialog<T>(BuildContext context, AlertInfo alertInfo) async {
  if (alertInfo == null) return Future.value();
  return showDialog(
    context: context,
    barrierDismissible: Platform.isAndroid,
    builder: (BuildContext context) => TK8AlertDialog(
      alertInfo: alertInfo,
    ),
  );
}
