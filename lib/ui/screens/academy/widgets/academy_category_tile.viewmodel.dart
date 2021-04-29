import 'package:flutter/material.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/util/more_loader.dart';
import 'package:tk8/services/services.dart';

class AcademyCategoryTileViewModel extends ChangeNotifier
    with MoreLoader<AcademyCategoryItem> {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();
  final AcademyCategory category;

  String get title => category.title;

  AcademyCategoryType get categoryType => category.type;

  AcademyCategoryTileViewModel(this.category) {
    addItems(category.items, category.nextCursor);
  }

  @override
  Future<PaginatedListResponse<AcademyCategoryItem>> loadMoreItems() async {
    switch (category.type) {
      case AcademyCategoryType.chapter:
        return _api.getCategoryChapters(
          category.id,
          nextCursor: nextCursor,
        );
      case AcademyCategoryType.video:
        return _api.getCategoryVideos(
          category.id,
          nextCursor: nextCursor,
        );
      case AcademyCategoryType.article:
        return _api.getCategoryArticles(
          category.id,
          nextCursor: nextCursor,
        );
      default:
        return PaginatedListResponse.initial();
    }
  }

  @override
  void onError(Error e) {
    _navigator.showGenericErrorAlertDialog(onRetry: () {
      loadMore();
    });
  }

  void openOverview() {
    if (categoryType == AcademyCategoryType.article) {
      _navigator.openArticlesOverview(category);
    }
    if (categoryType == AcademyCategoryType.video) {
      _navigator.openVideosOverview(category);
    }
  }

  void openItem(AcademyCategoryItem item, int index) {
    if (item is VideoCategoryItem) {
      _navigator.openVideoPlayerWithVideo(item.video);
    }

    if (item is ChapterCategoryItem) {
      _navigator.openChapterDetailsScreen(item.chapter);
    }

    if (item is ArticleCategoryItem) {
      _navigator.openArticleDetails(item.article);
    }
  }
}
