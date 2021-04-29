import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../alert_dialog.dart';

const _dividerWidth = 2.0;

class TK8AlertDialog extends StatelessWidget {
  final AlertInfo alertInfo;

  const TK8AlertDialog({Key key, @required this.alertInfo})
      : assert(alertInfo != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            boxShadow: [
              BoxShadow(
                color: Color(0x260c2246),
                blurRadius: 15,
              )
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContent(),
              if (alertInfo.actions.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  height: _dividerWidth,
                  color: TK8Colors.superLightGrey,
                ),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (alertInfo.title != null)
            Text(
              alertInfo.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0),
            ),
          if (alertInfo.text != null) ...[
            const Space.vertical(16),
            Text(
              alertInfo.text,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Gotham",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.center,
            )
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (alertInfo.actions.length <= 2 &&
            alertInfo.isVerticalActionsAlignment == false) {
          final actionWidth = constraints.maxWidth / alertInfo.actions.length -
              _dividerWidth * (alertInfo.actions.length - 1);
          return SizedBox(
            height: 44,
            width: double.infinity,
            child: Row(
              children: alertInfo.actions.fold<List<Widget>>([], (prev, cur) {
                final result = [...prev];
                if (result.isNotEmpty) {
                  result.add(Container(
                    width: _dividerWidth,
                    height: double.infinity,
                    color: TK8Colors.superLightGrey,
                  ));
                }
                result.add(
                  SizedBox(
                    width: actionWidth,
                    child: TK8AlertDialogAction(action: cur),
                  ),
                );
                return result;
              }).toList(),
            ),
          );
        }
        return SizedBox(
          height: min(
              160,
              44.0 * alertInfo.actions.length +
                  _dividerWidth * (alertInfo.actions.length - 1)),
          child: SingleChildScrollView(
            child: Column(
              children: alertInfo.actions.fold<List<Widget>>([], (prev, cur) {
                final result = [...prev];
                if (result.isNotEmpty) {
                  result.add(Container(
                    width: double.infinity,
                    height: _dividerWidth,
                    color: TK8Colors.superLightGrey,
                  ));
                }
                result.add(TK8AlertDialogAction(action: cur));
                return result;
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class TK8AlertDialogAction extends StatelessWidget {
  final _navigation = getIt<NavigationService>();
  final AlertAction action;

  TK8AlertDialogAction({Key key, @required this.action})
      : assert(action != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (action.onPressed != null) action.onPressed();
          if (action.popOnPressed) return _navigation.pop();
        },
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Center(
              child: Text(action.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: _getActionTextColor(),
                      fontWeight: (action.isDefault || action.isDestructive)
                          ? FontWeight.bold
                          : FontWeight.w400,
                      fontFamily: "Gotham",
                      fontSize: 13.0),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  Color _getActionTextColor() {
    if (action.isDestructive) return TK8Colors.pink;
    if (action.isDefault) return TK8Colors.ocean;
    return Colors.black;
  }
}
