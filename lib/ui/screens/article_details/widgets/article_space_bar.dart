import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tk8/ui/widgets/network_image_view.dart';

class ArticleSpaceBar extends StatefulWidget {
  final String title;
  final String imageUrl;

  const ArticleSpaceBar({
    Key key,
    @required this.title,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  _ArticleSpaceBarState createState() => _ArticleSpaceBarState();
}

class _ArticleSpaceBarState extends State<ArticleSpaceBar> {
  ScrollPosition _position;
  double _opacity = 1;
  final _maxScroll = 150.0;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _removeListener();
    _addListener();
    super.didChangeDependencies();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() => _position?.removeListener(_positionListener);

  void _positionListener() {
    final pos = _position?.pixels ?? 0;

    setState(() {
      _opacity = max(1.0 - pos / _maxScroll, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      NetworkImageView(imageUrl: widget.imageUrl),
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.0, 0.5),
            end: Alignment(0.0, 0.0),
            colors: <Color>[
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
      ),
      PositionedDirectional(
          start: 20,
          bottom: 20,
          end: 20,
          child: Opacity(
            opacity: _opacity,
            child: Text(widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 26,
                )),
          ))
    ]);
  }
}
