import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/data/models/video_feedback.dart';

UserVideo mockUserVideoModel({
  String id,
  String videoUrl,
  Duration duration,
  VideoFeedback feedback,
  String previewImageUrl,
}) {
  return UserVideo(
    id: id ?? mockUUID(),
    videoUrl: videoUrl ?? mockUrl(),
    duration: duration ?? Duration(seconds: mockInteger(45, 200)),
    feedback: feedback ?? mockUserVideoFeedbackModel(),
    previewImageUrl: previewImageUrl ?? mockUrl(),
  );
}

VideoFeedback mockUserVideoFeedbackModel({String text}) {
  return VideoFeedback(
    text: text ?? mockString(),
  );
}
