import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/data/models/video.model.dart';

import '../../_fixtures/fixture_reader.dart';

void main() {
  group('video model', () {
    test('should create instance from map', () async {
      // arrange
      final map = fixtureAsMap('videos/video.json');
      // act
      final video = Video.fromMap(map);
      // assert
      expect(video, isNotNull);
      expect(video.id, map['id']);
      expect(video.title, map['title']);
      expect(video.previewImageUrl, map['preview_image_url']);
      expect(video.videoUrl, map['video_url']);
      expect(video.duration, Duration(seconds: map['runtime_seconds']));
      expect(video.isFavorite, map['current_user']['favorite']);
    });

    test('should fail from map if id not valid', () async {
      // arrange
      final map = fixtureAsMap('videos/video.json');
      map['id'] = null;
      // act
      final video = Video.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if title not valid', () async {
      // arrange
      final map = fixtureAsMap('videos/video.json');
      map['title'] = null;
      // act
      final video = Video.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if preview image url not valid', () async {
      // arrange
      final map = fixtureAsMap('videos/video.json');
      map['preview_image_url'] = null;
      // act
      final video = Video.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if video url not valid', () async {
      // arrange
      final map = fixtureAsMap('videos/video.json');
      map['video_url'] = null;
      // act
      final video = Video.fromMap(map);
      // assert
      expect(video, isNull);
    });

    test('should fail from map if video duration not valid', () async {
      // arrange
      final map = fixtureAsMap('videos/video.json');
      map['runtime_seconds'] = null;
      // act
      final video = Video.fromMap(map);
      // assert
      expect(video, isNull);
    });
  });
}
