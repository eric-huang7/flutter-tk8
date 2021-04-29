import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/repositories/articles.repository.dart';
import 'package:tk8/services/services.dart';

import 'base.api.dart';

extension CategoryApi on Api {
  Future<List<AcademyCategory>> getAcademyCategories() async {
    final response = await get(path: 'categories');
    final data = response['data'] as List;
    final categories = data
        .map((categoryJson) => AcademyCategory.fromMap(categoryJson))
        .where((category) => category != null)
        .toList();

    final List<Video> videos = [];
    for (final category in categories) {
      for (final item in category.items) {
        if (item is ChapterCategoryItem) {
          videos.addAll(item.chapter.videos);
        } else if (item is VideoCategoryItem) {
          videos.add(item.video);
        }
      }
    }
    if (videos.isNotEmpty) {
      getIt<VideosRepository>().updateStreamWithVideos(videos);
    }

    return categories;
  }

  Future<PaginatedListResponse<ChapterCategoryItem>> getCategoryChapters(
    String id, {
    String nextCursor,
  }) async {
    final result = await getPaginatedList(
      path: 'categories/$id/chapters',
      afterCursor: nextCursor,
      itemParser: (item) => ChapterCategoryItem.fromMap(item),
    );
    for (final categoryChapter in result.list) {
      getIt<VideosRepository>()
          .updateStreamWithVideos(categoryChapter.chapter.videos);
    }
    return result;
  }

  Future<PaginatedListResponse<VideoCategoryItem>> getCategoryVideos(
    String id, {
    String nextCursor,
  }) async {
    final result = await getPaginatedList(
      path: 'categories/$id/videos',
      afterCursor: nextCursor,
      itemParser: (item) => VideoCategoryItem.fromMap(item),
    );
    getIt<VideosRepository>().updateStreamWithVideos(
      result.list.map((element) => element.video).toList(),
    );
    return result;
  }

  Future<PaginatedListResponse<ArticleCategoryItem>> getCategoryArticles(
      String id, {
        String nextCursor,
      }) async {
    final result = await getPaginatedList(
      path: 'categories/$id/articles',
      afterCursor: nextCursor,
      itemParser: (item) => ArticleCategoryItem.fromMap(item),
    );
    getIt<ArticlesRepository>().updateStreamWithArticles(
      result.list.map((element) => element.article).toList(),
    );
    return result;
  }
}
