import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/image.model.dart';

import '../image_model_factory.dart';

ChapterVideoExercise mockChapterVideoExerciseModel({
  String id,
  String title,
  String description,
  Image image,
  Duration duration,
  bool isUploadAvailable,
  int totalFinished,
  Duration totalDuration,
}) {
  return ChapterVideoExercise(
    id: id ?? mockUUID(),
    title: title ?? mockString(),
    description: description ?? mockString(),
    image: image ?? mockImageModel(),
    duration: duration ?? Duration(seconds: mockInteger(45, 200)),
    totalFinished: totalFinished ?? mockInteger(1, 5),
    totalDuration: totalDuration ?? Duration(seconds: mockInteger(45, 200)),
    isUploadAvailable: isUploadAvailable ?? false,
  );
}
