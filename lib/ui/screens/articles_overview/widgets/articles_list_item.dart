import 'package:flutter/material.dart';
import 'package:tk8/data/models/article.model.dart';
import 'package:tk8/ui/widgets/common_list_item.dart';

class ArticlesListItem extends StatelessWidget {
  final Article article;
  final int indexInList;

  const ArticlesListItem(
      {Key key, @required this.article, this.indexInList = -1})
      : assert(article != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonListItem(
        height: 260,
        title: article.headline,
        previewImageUrl: article.previewImageUrl);
  }
}
