import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tk8/util/log.util.dart';

class Video extends Equatable {
  final String id;
  final String title;
  final String previewImageUrl;
  final String videoUrl;
  final Duration duration;
  final int userRating;
  final bool isFavorite;
  final Duration viewDuration;

  // TODO: temporary hack to simulate view completed
  // bool get viewCompleted => viewDuration.inSeconds / duration.inSeconds > 0.9;
  bool get viewCompleted => viewDuration.inSeconds > 20;

  @visibleForTesting
  const Video({
    @required this.id,
    @required this.title,
    @required this.previewImageUrl,
    @required this.videoUrl,
    @required this.duration,
    this.userRating,
    this.isFavorite = false,
    this.viewDuration = Duration.zero,
  })  : assert(id != null && id != ''),
        assert(title != null && title != ''),
        assert(previewImageUrl != null && previewImageUrl != ''),
        assert(videoUrl != null && videoUrl != ''),
        assert(duration != null);

  factory Video.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final currentUser = map['current_user'] ?? {};
      final view = currentUser['view'] ?? {};
      return Video(
        id: map['id'],
        title: map['title'],
        previewImageUrl: map['preview_image_url'],
        videoUrl: map['video_url'],
        duration: Duration(seconds: map['runtime_seconds']),
        userRating: currentUser != null ? currentUser['rating'] : null,
        isFavorite: currentUser['favorite'] ?? false,
        viewDuration: Duration(seconds: view['watched_seconds'] ?? 0),
      );
    } catch (e) {
      debugLogError('error parsing video element', e);
      return null;
    }
  }

  Video copyWith({
    int userRating,
    Duration viewDuration,
  }) =>
      Video(
        id: id,
        title: title,
        previewImageUrl: previewImageUrl,
        videoUrl: videoUrl,
        duration: duration,
        userRating: userRating ?? this.userRating,
        isFavorite: isFavorite,
        viewDuration: viewDuration ?? this.viewDuration,
      );

  @override
  List<Object> get props => [
        id,
        title,
        previewImageUrl,
        videoUrl,
        duration,
        userRating,
        isFavorite,
      ];

  @override
  bool get stringify => true;
}
