import 'package:flutter/material.dart';

const _backgroundDecorationEdgeOffset = 3;
const _defaultTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: "RevxNeue",
  fontStyle: FontStyle.normal,
  fontSize: 8.0,
);

class LabelTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;

  const LabelTag(
    this.text, {
    Key key,
    this.backgroundColor = Colors.black,
    this.textStyle = _defaultTextStyle,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: LabelTagBackgroundDecoration(color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 1, left: 9, right: 9),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

class LabelTagBackgroundDecoration extends Decoration {
  final Color color;
  final EdgeInsets insets;

  const LabelTagBackgroundDecoration({
    @required this.color,
    this.insets = EdgeInsets.zero,
  }) : assert(color != null);

  @override
  BoxPainter createBoxPainter([_]) {
    return _CustomDecorationPainter(color: color, insets: insets);
  }
}

class _CustomDecorationPainter extends BoxPainter {
  final Color color;
  final EdgeInsets insets;
  _CustomDecorationPainter({this.color, this.insets});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final path = Path();
    final offsetWithInsets = offset.translate(insets.left, insets.top);
    final size = Size(
      configuration.size.width - insets.left - insets.right,
      configuration.size.height - insets.top - insets.bottom,
    );

    path.addPolygon([
      Offset(
        offsetWithInsets.dx + _backgroundDecorationEdgeOffset,
        offsetWithInsets.dy,
      ),
      Offset(
        offsetWithInsets.dx + size.width,
        offsetWithInsets.dy,
      ),
      Offset(
        offsetWithInsets.dx + size.width - _backgroundDecorationEdgeOffset,
        offsetWithInsets.dy + size.height,
      ),
      Offset(
        offsetWithInsets.dx,
        offsetWithInsets.dy + size.height,
      ),
    ], true);

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2,
    );
  }
}
