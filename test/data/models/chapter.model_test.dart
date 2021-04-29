import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/video.model.dart';

import '../../_fixtures/fixture_reader.dart';

void main() {
  group('video category chapter model', () {
    test('should create instance from map', () async {
      // arrange
      final map = json.decode(fixture('base_elements/chapter.json'));
      // act
      final chapter = Chapter.fromMap(map);
      // assert
      expect(chapter, isNotNull);
      expect(chapter.id, map['id']);
      expect(chapter.title, map['title']);
      expect(chapter.description, map['description']);
      expect(chapter.previewImageUrl, map['preview_image_url']);
    });

    test('should fail from map if id is invalid', () async {
      // arrange
      final map = json.decode(fixture('base_elements/chapter.json'));
      map['id'] = null;
      // act
      final chapter = Chapter.fromMap(map);
      // assert
      expect(chapter, isNull);
    });

    test('should fail from map if title is invalid', () async {
      // arrange
      final map = json.decode(fixture('base_elements/chapter.json'));
      map['title'] = null;
      // act
      final chapter = Chapter.fromMap(map);
      // assert
      expect(chapter, isNull);
    });

    test('should fail from map if preview image url is invalid', () async {
      // arrange
      final map = json.decode(fixture('base_elements/chapter.json'));
      map['preview_image_url'] = null;
      // act
      final chapter = Chapter.fromMap(map);
      // assert
      expect(chapter, isNull);
    });
  });

  group('ChapterVideo', () {
    group('fromMap', () {
      test('should should parse video from attributes (old format)', () async {
        // arrange
        final map = fixtureAsMap('chapters/video_chapter_item_old.json');
        final video = Video.fromMap(fixtureAsMap('videos/video.json'));
        // act
        final chapterItem = ChapterItem.fromMap(map);
        // assert
        expect(chapterItem, isA<ChapterVideo>());
        expect((chapterItem as ChapterVideo).video, video);
      });

      test(
          'should should parse video from video object in attributes (new format)',
          () async {
        // arrange
        final map = fixtureAsMap('chapters/video_chapter_item.json');
        final video = Video.fromMap(fixtureAsMap('videos/video.json'));
        // act
        final chapterItem = ChapterItem.fromMap(map);
        // assert
        expect(chapterItem, isA<ChapterVideo>());
        expect((chapterItem as ChapterVideo).video, video);
      });

      test('should fail if video is not set', () async {
        // arrange
        final map = fixtureAsMap('chapters/video_chapter_item.json');
        map['attributes']['video'] = null;
        // act
        final chapterItem = ChapterItem.fromMap(map);
        // assert
        expect(chapterItem, isNull);
      });
    });
  });
}
