import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _kDefaultAndroidSize = 36.0;

class AdaptiveProgressIndicator extends StatelessWidget {
  final double size;

  const AdaptiveProgressIndicator({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(radius: (size ?? 20) / 2);
    }
    return SizedBox(
      width: size ?? _kDefaultAndroidSize,
      height: size ?? _kDefaultAndroidSize,
      child: const AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
