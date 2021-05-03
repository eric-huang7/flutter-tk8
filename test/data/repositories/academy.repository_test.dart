import 'package:flutter_test/flutter_test.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/services/services.dart';

import '../../_fixtures/fixture_reader.dart';
import '../../_helpers/api.dart';
import '../../_helpers/service_injection.dart';

void main() {
  initializeServiceInjectionForTesting();

  group('AcademyRepository', () {
    group('getChapterDetails', () {
      test('should fetch chapter details', () async {
        // arrange
        const chapterId = '123';
        const fixtureFile = 'video_categories/chapter_details.json';
        final uri = Uri.parse(
            'https://tk8-api.herokuapp.com/api/v1/chapters/$chapterId');
        final chapterJson = fixture(fixtureFile);
        final chapterMap = fixtureAsMap(fixtureFile);
        final mockClient = mockApiClientWithResponse(body: chapterJson);
        getIt.registerLazySingleton<Api>(() => Api(mockClient));
        final repository = AcademyRepository();
        // act
        final result = await repository.getChapterDetails(chapterId);
        // assert
        verifyApiGetCallWithUrl(mockClient, uri);
        expect(result, Chapter.fromMap(chapterMap['data']));
        expect(result.videos.length, 6);
        expect(result.items.length, 8);
        expect(result.userVideos.length, 1);
        expect(result.userVideos[0],
            UserVideo.fromMap(fixtureAsMap('videos/user_video.json')));
      });
    });
  });
}
