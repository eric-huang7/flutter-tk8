import 'package:flutter/foundation.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/util/more_loader.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services.dart';

class VideosOverviewViewModel extends ChangeNotifier
    with MoreLoader<VideoCategoryItem> {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();
  final AcademyCategory category;

  String get title => category.title;

  VideosOverviewViewModel(this.category) {
    addItems(
        category.items.whereType<VideoCategoryItem>(), category.nextCursor);
  }

  @override
  Future<PaginatedListResponse<VideoCategoryItem>> loadMoreItems() {
    return _api.getCategoryVideos(category.id, nextCursor: nextCursor);
  }

  @override
  void onError(Error e) {
    _navigator.showGenericErrorAlertDialog(onRetry: () {
      loadMore();
    });
  }

  void openVideo(VideoCategoryItem video) {
    _navigator.openVideoPlayerWithVideo(video.video);
  }
}
