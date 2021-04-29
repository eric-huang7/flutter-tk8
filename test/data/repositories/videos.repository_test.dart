import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';

import '../../_fixtures/fixture_reader.dart';
import '../../_helpers/api.dart';
import '../../_helpers/mocks.dart';
import '../../_helpers/service_injection.dart';

void main() {
  setUpAll(() {
    initializeServiceInjectionForTesting();
  });

  group('videos repository', () {
    final video = Video.fromMap(fixtureAsMap('videos/video.json'));

    group('rateVideo', () {
      const rating = 3;

      void _setupApiResponseForStatusCode(int statusCode) {
        final mockClient = mockApiClientWithResponse(
          method: 'put',
          statusCode: statusCode,
        );
        getIt.registerLazySingleton<Api>(() => Api(mockClient));
      }

      test('should call api base with correct parameters', () async {
        // arrange
        final apiMock = ApiMock();
        getIt.registerLazySingleton<Api>(() => apiMock);
        final repo = VideosRepository();

        // act
        await repo.rateVideo(video: video, rating: rating);

        // assert
        verify(apiMock.put(
          path: 'videos/${video.id}/rating',
          body: {
            'video_rating': {
              'rating': rating,
            }
          },
        ));
        verifyNoMoreInteractions(apiMock);
      });

      test('should be ok when call succeeds', () async {
        // arrange
        _setupApiResponseForStatusCode(200);
        final repo = VideosRepository();

        // assert
        expect(
          () async => repo.rateVideo(video: video, rating: rating),
          returnsNormally,
        );
      });

      test('should throw exception when call fails', () async {
        // arrange
        _setupApiResponseForStatusCode(401);
        final repo = VideosRepository();

        // assert
        expect(
          repo.rateVideo(video: video, rating: rating),
          throwsException,
        );
      });
    });

    group('favoriteVideo', () {
      final videoMapResponse = fixtureAsMap('videos/video.json');
      ApiMock apiMock;

      void _mockApi() {
        apiMock = ApiMock();
        when(apiMock.put(
          path: anyNamed('path'),
          body: anyNamed('body'),
        )).thenAnswer(
          (realInvocation) async => {'data': videoMapResponse},
        );

        getIt.registerLazySingleton<Api>(() => apiMock);
      }

      test('should call api base with correct parameters', () async {
        // arrange
        _mockApi();
        final repo = VideosRepository();

        // act
        await repo.favoriteVideo(video: video);

        // assert
        verify(apiMock.put(path: 'videos/${video.id}/favorite'));
        verifyNoMoreInteractions(apiMock);
      });

      test('should parse and return correct video data', () async {
        // arrange
        _mockApi();
        final repo = VideosRepository();

        // act
        final result = await repo.favoriteVideo(video: video);

        // assert
        expect(result, Video.fromMap(videoMapResponse));
      });
    });

    group('unfavoriteVideo', () {
      final videoMapResponse = fixtureAsMap('videos/video.json');
      ApiMock apiMock;

      void _mockApi() {
        apiMock = ApiMock();
        when(apiMock.delete(
          path: anyNamed('path'),
        )).thenAnswer(
          (realInvocation) async => {'data': videoMapResponse},
        );

        getIt.registerLazySingleton<Api>(() => apiMock);
      }

      test('should call api base with correct parameters', () async {
        // arrange
        _mockApi();
        final repo = VideosRepository();

        // act
        await repo.unfavoriteVideo(video: video);

        // assert
        verify(apiMock.delete(path: 'videos/${video.id}/favorite'));
        verifyNoMoreInteractions(apiMock);
      });

      test('should parse and return correct video data', () async {
        // arrange
        _mockApi();
        final repo = VideosRepository();

        // act
        final result = await repo.unfavoriteVideo(video: video);

        // assert
        expect(result, Video.fromMap(videoMapResponse));
      });
    });

    group('setViewDuration', () {
      const duration = Duration(seconds: 123);

      void _setupApiResponseForStatusCode(int statusCode) {
        final mockClient = mockApiClientWithResponse(
          method: 'put',
          statusCode: statusCode,
        );
        getIt.registerLazySingleton<Api>(() => Api(mockClient));
      }

      test('should call api base with correct parameters', () async {
        // arrange
        final apiMock = ApiMock();
        getIt.registerLazySingleton<Api>(() => apiMock);
        final repo = VideosRepository();

        // act
        await repo.setViewDuration(video: video, duration: duration);

        // assert
        verify(apiMock.put(
          path: 'videos/${video.id}/view_duration',
          body: {
            'view_duration': {
              'seconds': duration.inSeconds,
            }
          },
        ));
        verifyNoMoreInteractions(apiMock);
      });

      test('should be ok when call succeeds', () async {
        // arrange
        _setupApiResponseForStatusCode(200);
        final repo = VideosRepository();

        // assert
        expect(
          () async => repo.setViewDuration(video: video, duration: duration),
          returnsNormally,
        );
      });

      test('should throw exception when call fails', () async {
        // arrange
        _setupApiResponseForStatusCode(401);
        final repo = VideosRepository();

        // assert
        expect(
          repo.setViewDuration(video: video, duration: duration),
          throwsException,
        );
      });
    });
  });
}
