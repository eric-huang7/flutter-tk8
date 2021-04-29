import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'phrase.dart';
import 'text_anchor_parser.dart';

/// A paragraph for texts including simple links (http://...) or markdown format links ((Some text)[http://...]).
/// This widget is build to identify links present in the paragraph.
///
/// The format supported currently are as follows:
/// 1. http://this.is.a.link.com
/// 2. https://this.is.a.link.com/id?iuyt2uhj2
/// 3. (Youtube)[https://youtube.com/mychannel]
/// 4. (This is post) [http://linktosomepost.com/mypost]
///
/// This widgets identifies the above mentioned links present in the paragraph
/// and present it in a nice way.
///
/// eg. A paragraph like this
/// '''
///Hello, this is (Rana)[https://medium.com/@ranaranvijaysingh9].
///This is my (YouTube)[https://www.youtube.com/channel/UCl7ETvRjLZsm9qXcxAKCd4w] channel.
///You can find this repository here: https://github.com/RanaRanvijaySingh/flutter_text_anchor.
///'''
///
/// will be converted to
///
/// '''
///Hello, this is Rana.
///This is my YouTube channel.
///You can find this repository here: https://github.com/RanaRanvijaySingh/flutter_text_anchor.
///'''
///
/// How to use it?
///
///             TextAnchor(
///                text: 'This is my (YouTube)[https://www.youtube.com/channel/UCl7ETvRjLZsm9qXcxAKCd4w] channel.',
///                onTapLink: (link) {
///                  print(link);
///                },
///              )
///
///This widget internally uses [RichText] and [TextSpan].
///
/// [text] Type: String - It is mandatory field.
/// [onTapLink] Type: Function(String) - It is mandatory field.
/// [style] Type: TextStyle - normal text style.
/// [linkStyle] Type: TextStyle - link text style.
class TextAnchor extends StatelessWidget {
  const TextAnchor(
    this.text, {
    Key key,
    this.style,
    this.linkStyle,
    @required this.onTapLink,
  }) : super(key: key);

  final String text;
  final Function(String) onTapLink;

  final TextStyle style;
  final TextStyle linkStyle;

  @override
  Widget build(BuildContext context) {
    final parser = TextAnchorParser();
    final nodes = parser.getPhrases(text);
    return RichText(
      text: TextSpan(
        children: _createChildren(nodes),
      ),
    );
  }

  List<TextSpan> _createChildren(List<Phrase> nodes) {
    return List<TextSpan>.generate(nodes.length, (int index) {
      final node = nodes[index];
      return TextSpan(
        text: nodes[index].outputText,
        style: node.link == null ? style : linkStyle ?? style,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onTapLink(node.link);
          },
      );
    });
  }
}
