import 'package:flutter/foundation.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/util/more_loader.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services.dart';

class ArticlesOverviewViewModel extends ChangeNotifier
    with MoreLoader<ArticleCategoryItem> {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();
  final AcademyCategory category;

  String get title => category.title;

  ArticlesOverviewViewModel(this.category) {
    addItems(
        category.items.whereType<ArticleCategoryItem>(), category.nextCursor);
  }

  @override
  Future<PaginatedListResponse<ArticleCategoryItem>> loadMoreItems() {
    return _api.getCategoryArticles(category.id, nextCursor: nextCursor);
  }

  @override
  void onError(Error e) {
    _navigator.showGenericErrorAlertDialog(onRetry: () {
      loadMore();
    });
  }

  void openArticle(ArticleCategoryItem article) {
    _navigator.openArticleDetails(article.article);
  }
}
