import 'package:flutter_translate/flutter_translate.dart';

void initializeTranslationsForTests() {
  final translations = <String, dynamic>{};
  Localization.load(translations);
}
