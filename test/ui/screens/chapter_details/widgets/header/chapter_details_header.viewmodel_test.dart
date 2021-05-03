import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/ui/screens/chapter_details/chapter_details.viewmodel.dart';
import 'package:tk8/ui/screens/chapter_details/widgets/header/chapter_details_header.viewmodel.dart';

import '../../../../../_factories/chapters/chapter_model_factory.dart';
import '../../../../../_factories/video_model_factory.dart';

class ChapterDetailsViewModelMock extends Mock
    implements ChapterDetailsViewModel {}

void main() {
  group('ChapterDetailsHeaderViewModel', () {
    group('initialization', () {
      test('should call add listerner to parent model', () async {
        // arrange
        final parentModelMock = ChapterDetailsViewModelMock();
        // act
        ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        // assert
        verify(parentModelMock.addListener(any));
      });
    });

    group('get', () {
      final parentModelMock = ChapterDetailsViewModelMock();
      final chapter = mockChapterModel();
      when(parentModelMock.chapter).thenReturn(chapter);

      test('title should return parent model chapter title', () async {
        // arrange
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        // assert
        expect(model.title, chapter.title);
      });

      test('description should return parent model chapter description',
          () async {
        // arrange
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        // assert
        expect(model.description, chapter.description);
      });

      test('trailerVideo should return parent model chapter trailerVideo',
          () async {
        // arrange
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        // assert
        expect(model.trailerVideo, chapter.trailerVideo);
      });

      test('videoCount should return parent model chapter videos array length',
          () async {
        // arrange
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        // assert
        expect(model.videoCount, chapter.videoItems.length);
      });

      test('totalVideosDuration should return the sum of all videos duration',
          () async {
        // arrange
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        // assert
        expect(
            model.totalVideosDuration,
            Duration(
                seconds: chapter.videos.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.duration.inSeconds)));
      });

      group('showChapterActionButton', () {
        test(
            'should be false when parent model all videos are complete and all questions are answered',
            () async {
          // arrange
          when(parentModelMock.allQuestionsAnswered).thenReturn(true);
          when(parentModelMock.allVideosCompleted).thenReturn(true);
          // act
          final model =
              ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
          // assert
          expect(model.showChapterActionButton, isFalse);
        });

        test('should be true when parent model not all videos are complete',
            () async {
          // arrange
          when(parentModelMock.allVideosCompleted).thenReturn(false);
          when(parentModelMock.allQuestionsAnswered).thenReturn(true);
          // act
          final model =
              ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
          // assert
          expect(model.showChapterActionButton, isTrue);
        });

        test('should be true when parent model not all questions are answered',
            () async {
          // arrange
          when(parentModelMock.allQuestionsAnswered).thenReturn(false);
          when(parentModelMock.allVideosCompleted).thenReturn(true);
          // act
          final model =
              ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
          // assert
          expect(model.showChapterActionButton, isTrue);
        });
      });

      group('showChapterCompletedTag', () {
        test(
            'should be true when parent model all videos are complete and all questions are answered',
            () async {
          // arrange
          when(parentModelMock.allQuestionsAnswered).thenReturn(true);
          when(parentModelMock.allVideosCompleted).thenReturn(true);
          // act
          final model =
              ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
          // assert
          expect(model.showChapterCompletedTag, isTrue);
        });

        test('should be false when parent model not all videos are complete',
            () async {
          // arrange
          when(parentModelMock.allVideosCompleted).thenReturn(false);
          when(parentModelMock.allQuestionsAnswered).thenReturn(true);
          // act
          final model =
              ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
          // assert
          expect(model.showChapterCompletedTag, isFalse);
        });

        test('should be false when parent model not all questions are answered',
            () async {
          // arrange
          when(parentModelMock.allQuestionsAnswered).thenReturn(false);
          when(parentModelMock.allVideosCompleted).thenReturn(true);
          // act
          final model =
              ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
          // assert
          expect(model.showChapterCompletedTag, isFalse);
        });
      });
    });

    group('onPressChapterActionButton', () {
      test(
          'should call parent model play video when not all videos are watched',
          () async {
        // arrange
        final parentModelMock = ChapterDetailsViewModelMock();
        final video = mockVideoModel();
        when(parentModelMock.videos).thenReturn([video]);
        when(parentModelMock.currentChapterItemIndex).thenReturn(0);
        when(parentModelMock.allVideosCompleted).thenReturn(false);
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        model.onPressChapterActionButton();
        // assert
        verify(parentModelMock.playVideo(video));
      });

      test('should call parent model show quiz when all videos are watched',
          () async {
        // arrange
        final parentModelMock = ChapterDetailsViewModelMock();
        when(parentModelMock.allVideosCompleted).thenReturn(true);
        // act
        final model =
            ChapterDetailsHeaderViewModel(parentModel: parentModelMock);
        model.onPressChapterActionButton();
        // assert
        verify(parentModelMock.onSelectQuizItem());
      });
    });
  });
}
