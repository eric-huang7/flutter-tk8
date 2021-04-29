import 'package:flutter/foundation.dart';
import 'package:tk8/data/models/article.model.dart';

class ArticleDetailsViewModel extends ChangeNotifier {
  final Article article;

  ArticleDetailsViewModel(this.article);
}
