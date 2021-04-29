import 'package:flutter/material.dart';

@immutable
class Space extends StatelessWidget {
  final double _width;
  final double _height;

  const Space.horizontal(double size, {Key key})
      : _width = size,
        _height = null,
        super(key: key);

  const Space.vertical(double size, {Key key})
      : _height = size,
        _width = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
    );
  }
}
