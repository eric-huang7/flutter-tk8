import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/data/models/academy_category.model.dart';
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

  group('video categories api', () {
    test('should fetch video categories list', () async {
      // arrange
      final uri = Uri.parse('https://heroku.t3k11.de/api/v1/categories');
      final categoriesJson = fixture('video_categories/list.json');
      final category = AcademyCategory.fromMap(
          json.decode(fixture('video_categories/video_category.json')));
      final mockClient = mockApiClientWithResponse(body: categoriesJson);
      final api = Api(mockClient);

      // act
      final result = await api.getAcademyCategories();
      final List<Video> expectedVideos = [
        ...(result[0].items[0] as ChapterCategoryItem).chapter.videos,
        ...result[1]
            .items
            .whereType<VideoCategoryItem>()
            .map((element) => element.video),
        ...result[2]
            .items
            .whereType<VideoCategoryItem>()
            .map((element) => element.video),
        ...result[3]
            .items
            .whereType<VideoCategoryItem>()
            .map((element) => element.video),
      ];

      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
      verify(videosRepositoryMock.updateStreamWithVideos(expectedVideos));
      expect(result.length, 4);
      expect(result[0], category);
    });

    test('should filter null elements from fetch categories list', () async {
      // arrange
      final categoriesJson =
          fixture('video_categories/list_with_invalid_image_element.json');
      final api = Api(mockApiClientWithResponse(body: categoriesJson));
      // act
      final result = await api.getAcademyCategories();
      // assert
      expect(result.length, 3);
    });
  });

  group('video category videos list', () {
    test("should fetch video category videos list", () async {
      // arrange
      const categoriId = '123';
      final uri = Uri.parse(
          'https://heroku.t3k11.de/api/v1/categories/$categoriId/videos');
      final videosJson = fixture('video_categories/videos_list.json');
      final video =
          VideoCategoryItem.fromMap(json.decode(fixture('videos/video.json')));
      final mockClient = mockApiClientWithResponse(body: videosJson);
      final api = Api(mockClient);
      // act
      final result = await api.getCategoryVideos(categoriId);
      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
      expect(result.list.length, 3);
      expect(result.list[0], video);
      expect(result.cursor, '2012-04-23T18:25:43.511Z');
      expect(result.nextCursor, '2012-05-12T17:33:12.837Z');
    });

    test('should filter null elements from fetch category videos list',
        () async {
      // arrange
      final videosJson =
          fixture('video_categories/videos_list_with_invalid_element.json');
      final api = Api(mockApiClientWithResponse(body: videosJson));
      // act
      final result = await api.getCategoryVideos('123');
      // assert
      expect(result.list.length, 2);
    });
  });

  group('video category chapters list', () {
    test('should fetch video category chapters list', () async {
      // arrange
      const categoryId = '123';
      final uri = Uri.parse(
          'https://heroku.t3k11.de/api/v1/categories/$categoryId/chapters');
      final chaptersJson = fixture('video_categories/chapters_list.json');
      final chapter = ChapterCategoryItem.fromMap(
          json.decode(fixture('base_elements/chapter.json')));
      final mockClient = mockApiClientWithResponse(body: chaptersJson);
      final api = Api(mockClient);
      // act
      final result = await api.getCategoryChapters(categoryId);
      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
      expect(result.list.length, 1);
      expect(result.list[0], chapter);
      expect(result.cursor, '2012-04-23T18:25:43.511Z');
      expect(result.nextCursor, '2012-05-12T17:33:12.837Z');
    });

    test('should filter null elements from fetch category chapters list',
        () async {
      // arrange
      final videosJson =
          fixture('video_categories/chapters_list_with_invalid_element.json');
      final api = Api(mockApiClientWithResponse(body: videosJson));
      // act
      final result = await api.getCategoryChapters('123');
      // assert
      expect(result.list.length, 1);
    });
  });

  group('articles category list', () {
    test('should fetch category articles list', () async {
      // arrange
      const categoryId = '123';
      final uri = Uri.parse(
          'https://heroku.t3k11.de/api/v1/categories/$categoryId/articles');
      final articlesJson = fixture('video_categories/articles_list.json');
      final article = ArticleCategoryItem.fromMap(
          json.decode(fixture('base_elements/article.json')));
      final mockClient = mockApiClientWithResponse(body: articlesJson);
      final api = Api(mockClient);
      // act
      final result = await api.getCategoryArticles(categoryId);
      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
      expect(result.list.length, 1);
      expect(result.list[0], article);
      expect(result.cursor, '1617798414098814');
      expect(result.nextCursor, '1617798414098814');
    });

    test('should filter null elements from fetch category articles list',
        () async {
      // arrange
      final videosJson =
          fixture('video_categories/articles_list_with_invalid_element.json');
      final api = Api(mockApiClientWithResponse(body: videosJson));
      // act
      final result = await api.getCategoryArticles('123');
      // assert
      expect(result.list.length, 1);
    });
  });
}
