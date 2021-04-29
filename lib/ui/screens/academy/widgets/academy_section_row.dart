import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/config/styles.config.dart';

// TODO: theming
const _padding = 15.0;

class AcademySectionRow extends StatelessWidget {
  final String title;
  final VoidCallback onShowAll;

  const AcademySectionRow({
    Key key,
    @required this.title,
    @required this.onShowAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, primary: TK8Colors.ocean),
              onPressed: onShowAll,
              child: Text(
                translate("screens.academy.categoryTile.showAll"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
