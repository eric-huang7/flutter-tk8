import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/util/more_loader.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services.dart';

class ChaptersOverviewViewModel extends ChangeNotifier
    with MoreLoader<ChapterCategoryItem> {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();
  final AcademyCategory category;

  String get title => translate('screens.chaptersOverview.title');

  ChaptersOverviewViewModel(this.category) {
    addItems(
        category.items.whereType<ChapterCategoryItem>(), category.nextCursor);
  }

  @override
  Future<PaginatedListResponse<ChapterCategoryItem>> loadMoreItems() {
    return _api.getCategoryChapters(category.id, nextCursor: nextCursor);
  }

  @override
  void onError(Error e) {
    _navigator.showGenericErrorAlertDialog(onRetry: () {
      loadMore();
    });
  }

  void openChapter(ChapterCategoryItem chapter) {
    _navigator.openChapterDetailsScreen(chapter.chapter);
  }
}
