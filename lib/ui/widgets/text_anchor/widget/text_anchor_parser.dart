import 'parser.dart';
import 'phrase.dart';

class TextAnchorParser extends Parser {
  @override
  List<Phrase> getPhrases(String text) {
    if (text == null || text.isEmpty) {
      return [];
    }
    final breakpoints = _findIndexPositionForPhrase(text);
    return _buildPhrases(breakpoints, text);
  }

  List _findIndexPositionForPhrase(String text) {
    final regxPlainMarkdownUrl = RegExp(regxForBothSimpleAndMarkdownUrl);
    final iterable = regxPlainMarkdownUrl.allMatches(text);
    final indexPositions = [];
    indexPositions.add(0);
    for (final element in iterable) {
      indexPositions.add(element.start);
      indexPositions.add(element.end);
    }
    indexPositions.add(text.length);
    return indexPositions;
  }

  List<Phrase> _buildPhrases(List indexPositions, String text) {
    final phrases = <Phrase>[];
    for (int i = 0; i < indexPositions.length - 1; i++) {
      final startPosition = indexPositions[i];
      final endPosition = indexPositions[i + 1];
      final substring = text.substring(startPosition, endPosition);
      final regxPlainUrl = RegExp(regxForJustUrl);
      final node = Phrase(inputText: substring);
      if (regxPlainUrl.hasMatch(substring)) {
        final match = regxPlainUrl.firstMatch(substring);
        node.link = substring.substring(match.start, match.end);
        final regxMarkdownUrl = RegExp(regxForGitMarkdownUrl);
        if (regxMarkdownUrl.hasMatch(substring)) {
          final regxBracedWord = RegExp(regxForTextInBraces);
          final matchMarkDown = regxBracedWord.firstMatch(substring);
          node.outputText = substring.substring(
              matchMarkDown.start + 1, matchMarkDown.end - 1);
        } else {
          node.outputText = substring.substring(match.start, match.end);
        }
      } else {
        node.outputText = substring;
      }
      phrases.add(node);
    }
    return phrases;
  }
}
