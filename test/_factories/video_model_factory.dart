import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/video.model.dart';

import '../_fixtures/fixture_reader.dart';

Video mockVideoModel({
  String id,
  String title,
  String previewImageUrl,
  String videoUrl,
  Duration duration,
  int userRating,
  bool isFavorite,
  Duration viewDuration,
}) {
  final mockDurationSeconds = mockInteger(45, 200);
  return Video(
    id: id ?? mockUUID(),
    title: title ?? mockString(),
    duration: duration ?? Duration(seconds: mockDurationSeconds),
    previewImageUrl: previewImageUrl ?? mockUrl(),
    videoUrl: videoUrl ?? mockUrl(),
    userRating: userRating ?? mockInteger(0, 5),
    isFavorite: isFavorite ?? mockInteger(0, 1) == 1,
    viewDuration:
        viewDuration ?? Duration(seconds: mockInteger(0, mockDurationSeconds)),
  );
}

Video mockVideoModelFromFixture({
  String fixtureFile,
  String id,
  String title,
  String previewImageUrl,
  String videoUrl,
  Duration duration,
  int userRating,
  bool isFavorite,
  Duration viewDuration,
}) {
  final map = fixtureAsMap(fixtureFile ?? 'videos/video.json');
  return Video.fromMap(map).copyMockWith(
    id: id,
    title: title,
    previewImageUrl: previewImageUrl,
    videoUrl: videoUrl,
    duration: duration,
    userRating: userRating,
    isFavorite: isFavorite,
    viewDuration: viewDuration,
  );
}

extension VideoMock on Video {
  Video copyMockWith({
    String id,
    String title,
    String previewImageUrl,
    String videoUrl,
    Duration duration,
    int userRating,
    bool isFavorite,
    Duration viewDuration,
  }) =>
      Video(
        id: id ?? this.id,
        title: title ?? this.title,
        previewImageUrl: previewImageUrl ?? this.previewImageUrl,
        videoUrl: videoUrl ?? this.videoUrl,
        duration: duration ?? this.duration,
        userRating: userRating ?? this.userRating,
        isFavorite: isFavorite ?? this.isFavorite,
        viewDuration: viewDuration ?? this.viewDuration,
      );
}
