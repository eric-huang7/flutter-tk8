import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/data/models/home_stream.model.dart';
import 'package:tk8/data/models/video.model.dart';

import '../../_fixtures/fixture_reader.dart';

void main() {
  group('home stream model base class', () {
    test('should return correct element from map', () async {
      // arrange
      final imageMap = {
        'type': HomeStreamImage.type,
        'attributes': json.decode(fixture('home_stream/image.json')),
      };
      final videoMap = {
        'type': HomeStreamVideo.type,
        'attributes': json.decode(fixture('videos/video.json')),
      };
      // act
      final video = HomeStream.fromMap(videoMap);
      final image = HomeStream.fromMap(imageMap);
      // assert
      expect(video, isA<HomeStreamVideo>());
      expect(image, isA<HomeStreamImage>());
    });
  });

  group('home stream image model', () {
    test('should create instance from map', () async {
      // arrange
      final map = json.decode(fixture('home_stream/image.json'));
      // act
      final image = HomeStreamImage.fromMap(map);
      // assert
      expect(image, isNotNull);
      expect(image.id, map['id']);
      expect(image.previewImageUrl, map['preview_image_url']);
      expect(image.imageUrl, map['image_url']);
    });

    test('should fail from map if id not valid', () async {
      // arrange
      final map = json.decode(fixture('home_stream/image.json'));
      map['id'] = null;
      // act
      final image = HomeStreamImage.fromMap(map);
      // assert
      expect(image, isNull);
    });

    test('should fail from map if image preview url not valid', () async {
      // arrange
      final map = json.decode(fixture('home_stream/image.json'));
      map['preview_image_url'] = null;
      // act
      final image = HomeStreamImage.fromMap(map);
      // assert
      expect(image, isNull);
    });

    test('should fail from map if image url not valid', () async {
      // arrange
      final map = json.decode(fixture('home_stream/image.json'));
      map['image_url'] = null;
      // act
      final image = HomeStreamImage.fromMap(map);
      // assert
      expect(image, isNull);
    });
  });

  group('home stream video model', () {
    test('should create instance from map', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      // act
      final video = HomeStreamVideo.fromMap(map);
      // assert
      expect(video, isNotNull);
      expect(video.video, Video.fromMap(map));
    });

    test('should fail from map if video not valid', () async {
      // arrange
      final map = json.decode(fixture('videos/video.json'));
      map['id'] = null;
      // act
      final video = HomeStreamVideo.fromMap(map);
      // assert
      expect(video, isNull);
    });
  });
}
