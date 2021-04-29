import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tk8/data/models/video_feedback.dart';
import 'package:tk8/util/log.util.dart';

class UserVideo extends Equatable {
  final String id;
  final String videoUrl;
  final Duration duration;
  final VideoFeedback feedback;
  final String previewImageUrl;
  final String exerciseId;

  @visibleForTesting
  const UserVideo(
      {@required this.id,
      @required this.videoUrl,
      this.duration,
      this.feedback,
      this.previewImageUrl,
      this.exerciseId})
      : assert(id != null),
        assert(videoUrl != null);

  factory UserVideo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      return UserVideo(
        id: map['id'],
        videoUrl: map['video_url'],
        duration: Duration(seconds: map['runtime_seconds'] ?? -1),
        feedback: VideoFeedback.fromMap(map['feedback']),
        previewImageUrl: map['preview_image_url'],
        exerciseId: (map['exercise'] ?? const {})['id'],
      );
    } catch (e) {
      debugLogError('error parsing user video element', e);
      return null;
    }
  }

  @override
  List<Object> get props => [id, videoUrl, duration, feedback];

  @override
  bool get stringify => true;
}
