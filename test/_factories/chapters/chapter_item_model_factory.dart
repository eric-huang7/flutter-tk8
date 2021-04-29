import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/questions.model.dart';
import 'package:tk8/data/models/video.model.dart';

import '../questions_model_factory.dart';
import '../video_model_factory.dart';

ChapterItem mockChapterItemModel({ChapterItemType type}) {
  final mockType = type ?? mockInteger(0, 1) == 1
      ? ChapterItemType.video
      : ChapterItemType.question;
  return mockType == ChapterItemType.video
      ? mockChapterVideoModel()
      : mockChapterQuestionModel();
}

ChapterVideo mockChapterVideoModel({
  Video video,
  ChapterVideoExercise exercise,
}) {
  return ChapterVideo(
    video ?? mockVideoModel(),
    exercise: exercise,
  );
}

ChapterQuestion mockChapterQuestionModel({Question question}) {
  return ChapterQuestion(question ?? mockMultiChoiceQuestionModel());
}
