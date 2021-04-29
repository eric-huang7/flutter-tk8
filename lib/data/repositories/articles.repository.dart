import 'package:rxdart/rxdart.dart';
import 'package:tk8/data/models/article.model.dart';

class ArticlesRepository {
  final Map<String, Article> _articles = {};
  final _articlesController = BehaviorSubject<Map<String, Article>>.seeded({});

  Stream<Map<String, Article>> get articlesStream => _articlesController.stream;

  Stream<Article> getArticleStream(String articleId) =>
      _articlesController.stream.map((articles) => articles[articleId]);

  void updateStreamWithArticles(List<Article> articles) {
    for (final article in articles.where((element) => element != null)) {
      _articles[article.id] = article;
    }
    _articlesController.add(_articles);
  }
}
