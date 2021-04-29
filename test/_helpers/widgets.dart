import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(home: widget),
  );
}

void initializeTranslationsForTesting() {
  final translations = <String, dynamic>{};
  Localization.load(translations);
}
