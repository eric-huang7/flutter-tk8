import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/home_stream.model.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';

import '../../_fixtures/fixture_reader.dart';
import '../../_helpers/api.dart';
import '../../_helpers/mocks.dart';
import '../../_helpers/service_injection.dart';

VideosRepositoryMock videosRepositoryMock;

void main() {
  initializeServiceInjectionForTesting();

  setUpAll(() {
    videosRepositoryMock = VideosRepositoryMock();
    getIt.registerLazySingleton<VideosRepository>(() => videosRepositoryMock);
  });

  setUp(() {
    reset(videosRepositoryMock);
  });

  group('home stream api', () {
    test('should fetch home stream list', () async {
      // arrange
      final uri = Uri.parse('https://heroku.t3k11.de/api/v1/home_stream');
      final streamJson = fixture('home_stream/list.json');
      final videoJson = fixture('videos/video.json');
      final imageJson = fixture('home_stream/image.json');
      final mockClient = mockApiClientWithResponse(body: streamJson);
      final api = Api(mockClient);
      // act
      final result = await api.getHomeStream();
      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
      expect(
        result,
        PaginatedListResponse<HomeStream>(
          list: [
            HomeStreamImage.fromMap(json.decode(imageJson)),
            HomeStreamVideo.fromMap(json.decode(videoJson)),
          ],
          cursor: '2012-04-23T18:25:43.511Z',
          nextCursor: '2012-05-12T17:33:12.837Z',
        ),
      );
      verify(videosRepositoryMock.updateStreamWithVideos([
        Video.fromMap(fixtureAsMap('videos/video.json')),
      ]));
    });

    test('should filter null elements from the stream list', () async {
      // arrange
      final streamJson =
          fixture('home_stream/list_with_invalid_image_element.json');
      final videoJson = fixture('videos/video.json');
      final mockClient = mockApiClientWithResponse(body: streamJson);
      final api = Api(mockClient);
      // act
      final result = await api.getHomeStream();
      // assert
      expect(
        result.list,
        [HomeStreamVideo.fromMap(json.decode(videoJson))],
      );
    });

    test('should load next stream page when next cursor is given', () async {
      // arrange
      final uri = Uri.parse(
          'https://heroku.t3k11.de/api/v1/home_stream?before=2012-04-23T18%3A25%3A43.511Z');
      final streamJson = fixture('home_stream/list.json');
      final mockClient = mockApiClientWithResponse(body: streamJson);
      final api = Api(mockClient);
      // act
      await api.getHomeStream(nextCursor: '2012-04-23T18:25:43.511Z');
      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
    });
  });
}
