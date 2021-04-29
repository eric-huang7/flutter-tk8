import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/util/log.util.dart';

import 'article.model.dart';
import 'chapter.model.dart';

enum AcademyCategoryType {
  chapter,
  video,
  article,
}

const _academyCategoryType = {
  'chapter_category': AcademyCategoryType.chapter,
  'video_category': AcademyCategoryType.video,
  'article_category': AcademyCategoryType.article,
};

class AcademyCategory extends Equatable {
  final String id;
  final String title;
  final List<AcademyCategoryItem> items;
  final AcademyCategoryType type;
  final String cursor;
  final String nextCursor;

  const AcademyCategory({
    @required this.id,
    @required this.title,
    @required this.items,
    @required this.type,
    this.cursor,
    this.nextCursor,
  })  : assert(id != null && id != ''),
        assert(title != null && title != ''),
        assert(items != null);

  @override
  List<Object> get props => [id, title];

  factory AcademyCategory.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    try {
      final items = (map['items'] as List)
          .map((item) => AcademyCategoryItem.fromMap(item))
          .where((item) => item != null)
          .toList();
      if (items.isEmpty) {
        throw Exception('Category must have at lease one item');
      }

      return AcademyCategory(
          id: map['id'],
          title: map['title'],
          items: items,
          type: _academyCategoryType[map['type']],
          cursor: map['pagination']['cursor'],
          nextCursor: map['pagination']['next_cursor']);
    } catch (e) {
      debugLogError('failed to parse video category', e);
      return null;
    }
  }
}

abstract class AcademyCategoryItem {
  String get id;

  String get title;

  String get previewImageUrl;

  static AcademyCategoryItem fromMap(Map<String, dynamic> map) {
    try {
      final type = map['type'];
      final itemAttributes = map['attributes'];
      switch (type) {
        case ChapterCategoryItem.type:
          return ChapterCategoryItem.fromMap(itemAttributes);
        case VideoCategoryItem.type:
          return VideoCategoryItem.fromMap(itemAttributes);
        case ArticleCategoryItem.type:
          return ArticleCategoryItem.fromMap(itemAttributes);
        default:
          throw Exception('Invalid video category type: $type');
      }
    } catch (e) {
      debugLogError('failed to parse video category type', e);
      return null;
    }
  }
}

class ArticleCategoryItem extends Equatable implements AcademyCategoryItem {
  static const type = 'article';

  final Article article;

  @override
  String get id => article.id;

  @override
  String get title => article.headline;

  @override
  String get previewImageUrl => article.previewImageUrl;

  const ArticleCategoryItem._({@required this.article})
      : assert(article != null);

  factory ArticleCategoryItem.fromMap(Map<String, dynamic> map) {
    try {
      return ArticleCategoryItem._(article: Article.fromMap(map));
    } catch (e) {
      debugLogError('failed to parse article category item', e);
      return null;
    }
  }

  @override
  List<Object> get props => [article];
}

class ChapterCategoryItem extends Equatable implements AcademyCategoryItem {
  static const type = 'chapter';

  final Chapter chapter;

  @override
  String get id => chapter.id;

  @override
  String get title => chapter.title;

  @override
  String get previewImageUrl => chapter.previewImageUrl;

  const ChapterCategoryItem._({@required this.chapter})
      : assert(chapter != null);

  factory ChapterCategoryItem.fromMap(Map<String, dynamic> map) {
    try {
      return ChapterCategoryItem._(chapter: Chapter.fromMap(map));
    } catch (e) {
      debugLogError('failed to parse video category chapter', e);
      return null;
    }
  }

  @override
  List<Object> get props => [chapter];
}

class VideoCategoryItem extends Equatable implements AcademyCategoryItem {
  static const type = 'video';

  final Video video;

  @override
  String get id => video.id;

  @override
  String get title => video.title;

  @override
  String get previewImageUrl => video.previewImageUrl;

  const VideoCategoryItem._({
    @required this.video,
  }) : assert(video != null);

  factory VideoCategoryItem.fromMap(Map<String, dynamic> map) {
    try {
      return VideoCategoryItem._(
        video: Video.fromMap(map),
      );
    } catch (e) {
      debugLogError('failed to parse video category video', e);
      return null;
    }
  }

  @override
  List<Object> get props => [video];

  @override
  bool get stringify => true;
}
