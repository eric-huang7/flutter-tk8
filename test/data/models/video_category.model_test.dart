import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/academy_category.model.dart';

import '../../_fixtures/fixture_reader.dart';

void main() {
  group('video category model', () {
    test('should create instance from map', () async {
      // arrange
      final map = json.decode(fixture('video_categories/video_category.json'));
      // act
      final category = AcademyCategory.fromMap(map);
      // assert
      expect(category, isNotNull);
      expect(category.id, map['id']);
      expect(category.title, map['title']);
      expect(category.type, AcademyCategoryType.chapter);
    });

    test('should assign the correct type', () async {
      // arrange
      final map = json.decode(fixture('video_categories/video_category.json'));
      // act
      map['type'] = 'chapter_category';
      final category = AcademyCategory.fromMap(map);
      map['type'] = 'video_category';
      final category2 = AcademyCategory.fromMap(map);
      // assert
      expect(category.type, AcademyCategoryType.chapter);
      expect(category2.type, AcademyCategoryType.video);
    });

    test('should should fail from map if id is not valid', () async {
      // arrange
      final map = json.decode(fixture('video_categories/video_category.json'));
      map['id'] = null;
      // act
      final category = AcademyCategory.fromMap(map);
      // assert
      expect(category, isNull);
    });

    test('should should fail from map if title is not valid', () async {
      // arrange
      final map = json.decode(fixture('video_categories/video_category.json'));
      map['title'] = null;
      // act
      final category = AcademyCategory.fromMap(map);
      // assert
      expect(category, isNull);
    });
  });

  group('video category chapter model', () {
    test('should create instance from map', () async {
      // arrange
      final map = json.decode(fixture('base_elements/chapter.json'));
      // act
      final chapter = ChapterCategoryItem.fromMap(map);
      // assert
      expect(chapter, isNotNull);
      expect(chapter.chapter, Chapter.fromMap(map));
    });

    test('should fail from map if id is invalid', () async {
      // arrange
      final map = json.decode(fixture('base_elements/chapter.json'));
      map['id'] = null;
      // act
      final chapter = ChapterCategoryItem.fromMap(map);
      // assert
      expect(chapter, isNull);
    });
  });

  group('video category video model', () {
    test('should create instance from map', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      // act
      final video = VideoCategoryItem.fromMap(map);
      // assert
      expect(video, isNotNull);
      expect(video.id, map['id']);
      expect(video.title, map['title']);
      expect(video.previewImageUrl, map['preview_image_url']);
    });

    test('should fail from map if id is invalid', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      map['id'] = null;
      // act
      final video = VideoCategoryItem.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if title is invalid', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      map['title'] = null;
      // act
      final video = VideoCategoryItem.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if preview image url is invalid', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      map['preview_image_url'] = null;
      // act
      final video = VideoCategoryItem.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if video url is invalid', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      map['video_url'] = null;
      // act
      final video = VideoCategoryItem.fromMap(map);
      // assert
      expect(video, isNull);
    });
  });
}
