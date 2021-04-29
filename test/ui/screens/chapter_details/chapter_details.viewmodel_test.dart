import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/chapter_details/chapter_details.viewmodel.dart';

import '../../../_factories/chapters/chapter_item_model_factory.dart';
import '../../../_factories/chapters/chapter_model_factory.dart';
import '../../../_factories/questions_model_factory.dart';
import '../../../_factories/user_video_model_factory.dart';
import '../../../_factories/video_model_factory.dart';
import '../../../_helpers/mocks.dart';
import '../../../_helpers/service_injection.dart';

class VideosStreamMock extends Mock implements Stream<Map<String, Video>> {}

class CompletedTestsStreamMock extends Mock implements Stream<Set<String>> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final navigationMock = NavigationServiceMock();
  final apiMock = ApiMock();
  final academyRepositoryMock = AcademyRepositoryMock();
  final videosRepositoryMock = VideosRepositoryMock();
  final chaptersTestsServiceMock = ChaptersTestsServiceMock();

  setUpAll(() async {
    await getIt.reset();
    initializeServiceInjectionForTesting();
    getIt.registerLazySingleton<NavigationService>(() => navigationMock);
    getIt.registerLazySingleton<Api>(() => apiMock);
    getIt.registerLazySingleton<AcademyRepository>(() => academyRepositoryMock);
    getIt.registerLazySingleton<VideosRepository>(() => videosRepositoryMock);
    getIt.registerLazySingleton<ChaptersTestsService>(
        () => chaptersTestsServiceMock);
  });

  setUp(() {
    reset(navigationMock);
    reset(apiMock);
    reset(academyRepositoryMock);
    reset(videosRepositoryMock);
    reset(chaptersTestsServiceMock);
  });

  group('ChapterDetailsViewModel', () {
    final videosStreamMock = VideosStreamMock();
    final completedTestsStreamMock = CompletedTestsStreamMock();

    void _prepareDependencies([Chapter chapter]) {
      when(academyRepositoryMock.getChapterDetails(any))
          .thenAnswer((realInvocation) async => chapter ?? mockChapterModel());
      when(videosRepositoryMock.videosStream)
          .thenAnswer((_) => videosStreamMock);
      when(chaptersTestsServiceMock.isQuestionAnswered(any)).thenReturn(false);
      when(chaptersTestsServiceMock.questionsAnsweredIdsStream)
          .thenAnswer((_) => completedTestsStreamMock);
    }

    group('initialization', () {
      test('should fetch chapter details from backend', () async {
        // arrange
        final chapter = mockChapterModel();
        _prepareDependencies(chapter);
        // act
        ChapterDetailsViewModel(chapter);
        // assert
        verify(academyRepositoryMock.getChapterDetails(chapter.id));
      });

      test('should subscribe to videos stream', () async {
        // arrange
        final chapter = mockChapterModel();
        _prepareDependencies(chapter);
        // act
        ChapterDetailsViewModel(chapter);
        // assert
        verify(videosStreamMock.listen(any));
      });

      test('should subscribe to chapters tests stream', () async {
        // arrange
        final chapter = mockChapterModel();
        _prepareDependencies(chapter);
        // act
        ChapterDetailsViewModel(chapter);
        // assert
        verify(completedTestsStreamMock.listen(any));
      });
    });

    group('chapter getters', () {
      test('should be equal to the chapter passed in the constructor',
          () async {
        // arrange
        final chapter = mockChapterModel(userVideos: [mockUserVideoModel()]);
        _prepareDependencies(chapter);
        // act
        final model = ChapterDetailsViewModel(chapter);
        // assert
        expect(model.chapter, chapter);
        expect(model.title, chapter.title);
        expect(model.description, chapter.description);
        expect(model.videoItems, chapter.videoItems);
        expect(model.videos, chapter.videos);
        expect(model.trailerVideo, chapter.trailerVideo);
        expect(model.userVideo, chapter.userVideos.first);
      });

      group('hasTrailerVideo', () {
        test('should return true when chapter has trailer video', () async {
          // arrange
          final chapter = mockChapterModel();
          _prepareDependencies(chapter);
          // act
          final model = ChapterDetailsViewModel(chapter);
          // assert
          expect(model.hasTrailerVideo, true);
        });

        test('should return false when chapter has trailer video', () async {
          // arrange
          final chapter = mockChapterModel(trailerVideoMock: false);
          _prepareDependencies(chapter);
          // act
          final model = ChapterDetailsViewModel(chapter);
          // assert
          expect(model.hasTrailerVideo, false);
        });
      });

      group('allVideosCompleted', () {
        test(
            'should return false when there is at least on video not completed',
            () {
          FakeAsync().run((async) {
            // arrange
            final v1 =
                mockVideoModel(viewDuration: const Duration(seconds: 32));
            final v2 =
                mockVideoModel(viewDuration: const Duration(seconds: 16));
            final chapter = mockChapterModel(items: [
              mockChapterVideoModel(video: v1),
              mockChapterVideoModel(video: v2),
            ]);
            final streamController = StreamController<Map<String, Video>>();
            _prepareDependencies(chapter);
            when(videosRepositoryMock.videosStream)
                .thenAnswer((_) => streamController.stream);
            // act
            streamController.add({
              v1.id: v1,
              v2.id: v2,
            });
            final model = ChapterDetailsViewModel(chapter);

            // assert
            async.flushMicrotasks();
            expect(model.allVideosCompleted, false);
          });
        });
        test('should return true when all videos are completed', () async {
          FakeAsync().run((async) {
            // arrange
            final v1 =
                mockVideoModel(viewDuration: const Duration(seconds: 32));
            final v2 =
                mockVideoModel(viewDuration: const Duration(seconds: 36));
            final chapter = mockChapterModel(items: [
              mockChapterVideoModel(video: v1),
              mockChapterVideoModel(video: v2),
            ]);
            final streamController = StreamController<Map<String, Video>>();
            _prepareDependencies(chapter);
            when(videosRepositoryMock.videosStream)
                .thenAnswer((_) => streamController.stream);
            // act
            streamController.add({
              v1.id: v1,
              v2.id: v2,
            });
            final model = ChapterDetailsViewModel(chapter);

            // assert
            async.flushMicrotasks();
            expect(model.allVideosCompleted, true);
          });
        });
      });

      group('currentChapterItemIndex', () {
        test('should be set to the first not completed video index', () async {
          FakeAsync().run((async) {
            // arrange
            final v1 =
                mockVideoModel(viewDuration: const Duration(seconds: 32));
            final v2 =
                mockVideoModel(viewDuration: const Duration(seconds: 28));
            final v3 =
                mockVideoModel(viewDuration: const Duration(seconds: 16));
            final v4 =
                mockVideoModel(viewDuration: const Duration(seconds: 15));
            final v5 =
                mockVideoModel(viewDuration: const Duration(seconds: 15));
            final chapter = mockChapterModel(items: [
              mockChapterVideoModel(video: v1),
              mockChapterVideoModel(video: v2),
              mockChapterVideoModel(video: v3),
              mockChapterVideoModel(video: v4),
              mockChapterVideoModel(video: v5),
            ]);
            final streamController = StreamController<Map<String, Video>>();
            _prepareDependencies(chapter);
            when(videosRepositoryMock.videosStream)
                .thenAnswer((_) => streamController.stream);
            // act
            streamController.add({
              v1.id: v1,
              v2.id: v2,
              v3.id: v3,
              v4.id: v4,
              v5.id: v5,
            });
            final model = ChapterDetailsViewModel(chapter);

            // assert
            async.flushMicrotasks();
            expect(model.currentChapterItemIndex, 2);
          });
        });
      });

      group('hasQuestions', () {
        test('should return true when chapter has question items', () async {
          // arrange
          final chapter = mockChapterModel(items: [
            mockChapterVideoModel(),
            mockChapterQuestionModel(),
          ]);
          _prepareDependencies(chapter);
          // act
          final model = ChapterDetailsViewModel(chapter);
          // assert
          expect(model.hasQuestions, true);
        });
        test('should return false when chapter has no question items',
            () async {
          // arrange
          final chapter = mockChapterModel(items: [mockChapterVideoModel()]);
          _prepareDependencies(chapter);
          // act
          final model = ChapterDetailsViewModel(chapter);
          // assert
          expect(model.hasQuestions, false);
        });
      });

      group('allQuestionsAnswered', () {
        test(
            'should return false when there is at least one question not answered',
            () {
          FakeAsync().run((async) {
            // arrange
            final q1 = mockMultiChoiceQuestionModel();
            final q2 = mockMultiChoiceQuestionModel();
            final chapter = mockChapterModel(items: [
              mockChapterQuestionModel(question: q1),
              mockChapterQuestionModel(question: q2),
            ]);
            final streamController = StreamController<Set<String>>();
            _prepareDependencies(chapter);
            when(chaptersTestsServiceMock.questionsAnsweredIdsStream)
                .thenAnswer((_) => streamController.stream);
            // act
            streamController.add({q1.id});
            final model = ChapterDetailsViewModel(chapter);

            // assert
            async.flushMicrotasks();
            expect(model.allQuestionsAnswered, false);
          });
        });
        test('should return true when all questions are answered', () {
          FakeAsync().run((async) {
            // arrange
            final q1 = mockMultiChoiceQuestionModel();
            final q2 = mockMultiChoiceQuestionModel();
            final chapter = mockChapterModel(items: [
              mockChapterQuestionModel(question: q1),
              mockChapterQuestionModel(question: q2),
            ]);
            final streamController = StreamController<Set<String>>();
            _prepareDependencies(chapter);
            when(chaptersTestsServiceMock.questionsAnsweredIdsStream)
                .thenAnswer((_) => streamController.stream);
            when(chaptersTestsServiceMock.isQuestionAnswered(any))
                .thenReturn(true);
            // act
            streamController.add({q1.id, q2.id});
            final model = ChapterDetailsViewModel(chapter);

            // assert
            async.flushMicrotasks();
            expect(model.allQuestionsAnswered, true);
          });
        });
      });

      group('chapterCompleted', () {
        test(
            'should return false when both allVideosCompleted && allQuestionsAnswered are false',
            () async {
          FakeAsync().run((async) {
            // arrange
            final q1 = mockMultiChoiceQuestionModel();
            final q2 = mockMultiChoiceQuestionModel();
            final v1 =
                mockVideoModel(viewDuration: const Duration(seconds: 32));
            final v2 =
                mockVideoModel(viewDuration: const Duration(seconds: 16));
            final chapter = mockChapterModel(items: [
              mockChapterVideoModel(video: v1),
              mockChapterVideoModel(video: v2),
              mockChapterQuestionModel(question: q1),
              mockChapterQuestionModel(question: q2),
            ]);
            final streamController = StreamController<Map<String, Video>>();
            _prepareDependencies(chapter);
            when(videosRepositoryMock.videosStream)
                .thenAnswer((_) => streamController.stream);
            when(chaptersTestsServiceMock.isQuestionAnswered(any))
                .thenReturn(false);
            // act
            streamController.add({
              v1.id: v1,
              v2.id: v2,
            });
            final model = ChapterDetailsViewModel(chapter);
            // assert
            async.flushMicrotasks();
            expect(model.chapterCompleted, false);
          });
        });
        test(
            'should return false when allVideosCompleted is false and allQuestionsAnswered is true',
            () async {
          final q1 = mockMultiChoiceQuestionModel();
          final q2 = mockMultiChoiceQuestionModel();
          final v1 = mockVideoModel(viewDuration: const Duration(seconds: 32));
          final v2 = mockVideoModel(viewDuration: const Duration(seconds: 16));
          final chapter = mockChapterModel(items: [
            mockChapterVideoModel(video: v1),
            mockChapterVideoModel(video: v2),
            mockChapterQuestionModel(question: q1),
            mockChapterQuestionModel(question: q2),
          ]);
          FakeAsync().run((async) {
            // arrange
            final streamController = StreamController<Map<String, Video>>();
            _prepareDependencies(chapter);
            when(videosRepositoryMock.videosStream)
                .thenAnswer((_) => streamController.stream);
            when(chaptersTestsServiceMock.isQuestionAnswered(any))
                .thenReturn(true);
            // act
            streamController.add({
              v1.id: v1,
              v2.id: v2,
            });
            final model = ChapterDetailsViewModel(chapter);
            // assert
            async.flushMicrotasks();
            expect(model.chapterCompleted, false);
          });
        });
        test(
            'should return false when allVideosCompleted is true and allQuestionsAnswered is false',
            () async {
          final q1 = mockMultiChoiceQuestionModel();
          final q2 = mockMultiChoiceQuestionModel();
          final v1 = mockVideoModel(viewDuration: const Duration(seconds: 32));
          final v2 = mockVideoModel(viewDuration: const Duration(seconds: 36));
          final chapter = mockChapterModel(items: [
            mockChapterVideoModel(video: v1),
            mockChapterVideoModel(video: v2),
            mockChapterQuestionModel(question: q1),
            mockChapterQuestionModel(question: q2),
          ]);
          FakeAsync().run((async) {
            // arrange
            final streamController = StreamController<Map<String, Video>>();
            _prepareDependencies(chapter);
            when(videosRepositoryMock.videosStream)
                .thenAnswer((_) => streamController.stream);
            when(chaptersTestsServiceMock.isQuestionAnswered(any))
                .thenReturn(false);
            // act
            streamController.add({
              v1.id: v1,
              v2.id: v2,
            });
            final model = ChapterDetailsViewModel(chapter);
            // assert
            async.flushMicrotasks();
            expect(model.chapterCompleted, false);
          });
        });
      });
      test(
          'should return false when both allVideosCompleted && allQuestionsAnswered are true',
          () async {
        FakeAsync().run((async) {
          // arrange
          final q1 = mockMultiChoiceQuestionModel();
          final q2 = mockMultiChoiceQuestionModel();
          final v1 = mockVideoModel(viewDuration: const Duration(seconds: 32));
          final v2 = mockVideoModel(viewDuration: const Duration(seconds: 36));
          final chapter = mockChapterModel(items: [
            mockChapterVideoModel(video: v1),
            mockChapterVideoModel(video: v2),
            mockChapterQuestionModel(question: q1),
            mockChapterQuestionModel(question: q2),
          ]);
          final streamController = StreamController<Map<String, Video>>();
          _prepareDependencies(chapter);
          when(videosRepositoryMock.videosStream)
              .thenAnswer((_) => streamController.stream);
          when(chaptersTestsServiceMock.isQuestionAnswered(any))
              .thenReturn(true);
          // act
          streamController.add({
            v1.id: v1,
            v2.id: v2,
          });
          final model = ChapterDetailsViewModel(chapter);
          // assert
          async.flushMicrotasks();
          expect(model.chapterCompleted, true);
        });
      });
    });

    group('playVideo', () {
      test('should call navigation service to open chapter video list player',
          () async {
        // arrange
        final video = mockVideoModel();
        final chapter = mockChapterModel();
        _prepareDependencies(chapter);

        final model = ChapterDetailsViewModel(chapter);
        // act
        model.playVideo(video);
        // assert
        verify(navigationMock.openVideoPlayerWithChapter(chapter, video));
      });
    });

    group('onSelectVideoItem', () {
      final v1 = mockVideoModel(viewDuration: const Duration(seconds: 32));
      final v2 = mockVideoModel(viewDuration: const Duration(seconds: 16));
      final v3 = mockVideoModel(viewDuration: const Duration(seconds: 6));
      final chapterVideo1 = mockChapterVideoModel(video: v1);
      final chapterVideo2 = mockChapterVideoModel(video: v2);
      final chapterVideo3 = mockChapterVideoModel(video: v3);
      final chapter = mockChapterModel(items: [
        chapterVideo1,
        chapterVideo2,
        chapterVideo3,
      ]);
      test('should ignore if item is after current', () async {
        FakeAsync().run((async) {
          // arrange
          final streamController = StreamController<Map<String, Video>>();
          _prepareDependencies(chapter);
          when(videosRepositoryMock.videosStream)
              .thenAnswer((_) => streamController.stream);
          // act
          final model = ChapterDetailsViewModel(chapter);
          async.flushMicrotasks();
          model.onSelectVideoItem(chapterVideo3);

          // assert
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v1));
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v2));
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v3));
        });
      });
      test('should open player if item is current', () async {
        FakeAsync().run((async) {
          // arrange
          final streamController = StreamController<Map<String, Video>>();
          _prepareDependencies(chapter);
          when(videosRepositoryMock.videosStream)
              .thenAnswer((_) => streamController.stream);
          // act
          streamController.add({
            v1.id: v1,
            v2.id: v2,
          });
          final model = ChapterDetailsViewModel(chapter);
          async.flushMicrotasks();
          model.onSelectVideoItem(chapterVideo2);

          // assert
          verify(navigationMock.openVideoPlayerWithChapter(chapter, v2));
        });
      });
      test('should open player if item is before current', () async {
        FakeAsync().run((async) {
          // arrange
          final streamController = StreamController<Map<String, Video>>();
          _prepareDependencies(chapter);
          when(videosRepositoryMock.videosStream)
              .thenAnswer((_) => streamController.stream);
          // act
          final model = ChapterDetailsViewModel(chapter);
          async.flushMicrotasks();
          model.onSelectVideoItem(chapterVideo1);

          // assert
          verify(navigationMock.openVideoPlayerWithChapter(chapter, v1));
        });
      });
    });

    group('onSelectQuizItem', () {
      test('should ignore when not all videos are completed', () async {
        FakeAsync().run((async) {
          // arrange
          final v1 = mockVideoModel(viewDuration: const Duration(seconds: 32));
          final v2 = mockVideoModel(viewDuration: const Duration(seconds: 16));
          final chapter = mockChapterModel(items: [
            mockChapterVideoModel(video: v1),
            mockChapterVideoModel(video: v2),
          ]);
          final streamController = StreamController<Map<String, Video>>();
          _prepareDependencies(chapter);
          when(videosRepositoryMock.videosStream)
              .thenAnswer((_) => streamController.stream);
          when(chaptersTestsServiceMock.isQuestionAnswered(any))
              .thenReturn(true);
          // act
          streamController.add({
            v1.id: v1,
            v2.id: v2,
          });
          final model = ChapterDetailsViewModel(chapter);
          async.flushMicrotasks();
          model.onSelectQuizItem();
          // assert
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v1));
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v2));
        });
      });
      test('should play show quiz when all videos are completed', () async {
        // TODO: this is temporary until we change the way the player works
        FakeAsync().run((async) {
          // arrange
          final v1 = mockVideoModel(viewDuration: const Duration(seconds: 32));
          final v2 = mockVideoModel(viewDuration: const Duration(seconds: 36));
          final chapter = mockChapterModel(items: [
            mockChapterVideoModel(video: v1),
            mockChapterVideoModel(video: v2),
          ]);
          final streamController = StreamController<Map<String, Video>>();
          _prepareDependencies(chapter);
          when(videosRepositoryMock.videosStream)
              .thenAnswer((_) => streamController.stream);
          when(chaptersTestsServiceMock.isQuestionAnswered(any))
              .thenReturn(true);
          // act
          streamController.add({
            v1.id: v1,
            v2.id: v2,
          });
          final model = ChapterDetailsViewModel(chapter);
          async.flushMicrotasks();
          model.onSelectQuizItem();
          // assert
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v1));
          verifyNever(navigationMock.openVideoPlayerWithChapter(chapter, v2));
          verify(navigationMock.openVideoPlayerWithChapterQuiz(chapter));
        });
      });
    });
  });
}
