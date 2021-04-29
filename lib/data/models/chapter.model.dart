import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/util/log.util.dart';

import 'image.model.dart';
import 'questions.model.dart';
import 'video.model.dart';

class Chapter extends Equatable {
  final String id;
  final String title;
  final String description;
  final String previewImageUrl;
  final List<UserVideo> userVideos;
  final List<ChapterItem> items;
  final Video trailerVideo;
  final int videosCount;
  final int totalRuntimeSeconds;

  List<ChapterVideo> get videoItems =>
      items?.whereType<ChapterVideo>()?.toList() ?? [];

  List<Video> get videos => videoItems.map((i) => i.video)?.toList() ?? [];

  List<ChapterQuestion> get questionItems =>
      items?.whereType<ChapterQuestion>()?.toList() ?? [];

  @visibleForTesting
  const Chapter({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.previewImageUrl,
    this.items,
    this.trailerVideo,
    this.userVideos,
    this.videosCount = 0,
    this.totalRuntimeSeconds = 0,
  })  : assert(id != null && id != ''),
        assert(title != null && title != ''),
        assert(previewImageUrl != null && previewImageUrl != '');

  factory Chapter.fromMap(Map<String, dynamic> map) {
    try {
      final userVideos = map['user_videos'] as List;
      final itemsMap = map['chapter_items'] as List;
      final chapterItems = itemsMap
              ?.map((itemMap) => ChapterItem.fromMap(itemMap))
              ?.where((item) => item != null)
              ?.toList() ??
          [];
      return Chapter(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        previewImageUrl: map['preview_image_url'],
        userVideos: userVideos
            ?.map((userVideoMap) => UserVideo.fromMap(userVideoMap))
            ?.where((userVideo) => userVideo != null)
            ?.toList(),
        videosCount: map['videos_count'],
        totalRuntimeSeconds: map['total_runtime_seconds'],
        items: [
          ...chapterItems.whereType<ChapterVideo>(),
          ...chapterItems.whereType<ChapterQuestion>(),
        ],
        trailerVideo: Video.fromMap(map['trailer']),
      );
    } catch (e) {
      debugLogError('failed to parse video category chapter', e);
      return null;
    }
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        previewImageUrl,
        userVideos,
        items,
        trailerVideo,
      ];

  @override
  bool get stringify => true;
}

enum ChapterItemType { video, question }

abstract class ChapterItem extends Equatable {
  ChapterItemType get type;

  const ChapterItem();

  factory ChapterItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final type = map['type'];
      switch (type) {
        case 'video':
          return ChapterVideo.fromMap(map);
        case 'question':
          return ChapterQuestion.fromMap(map);
        default:
          debugLogError(
              'failed to parse chapter item due to invalid type $type $map');
          return null;
      }
    } catch (e) {
      debugLogError('failed to parse chapter item $map', e);
      return null;
    }
  }
}

class ChapterVideo extends ChapterItem {
  final Video video;
  final ChapterVideoExercise exercise;

  @override
  ChapterItemType get type => ChapterItemType.video;

  @visibleForTesting
  const ChapterVideo(
    this.video, {
    this.exercise,
  }) : assert(video != null);

  factory ChapterVideo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final Map<String, dynamic> attributes = map['attributes'];
      final video = attributes.containsKey('video')
          ? Video.fromMap(attributes['video'])
          : Video.fromMap(map['attributes']);
      return ChapterVideo(
        video,
        exercise: (attributes['exercises'] as List)
            ?.map((exerciseItem) => ChapterVideoExercise.fromMap(exerciseItem))
            ?.firstWhere((element) => element != null, orElse: () => null),
      );
    } catch (e) {
      debugLogError('failed to parse chapter video $map', e);
      return null;
    }
  }

  @override
  List<Object> get props => [type, video, exercise];

  @override
  bool get stringify => true;
}

class ChapterQuestion extends ChapterItem {
  final Question question;

  @override
  ChapterItemType get type => ChapterItemType.question;

  @visibleForTesting
  const ChapterQuestion(this.question);

  factory ChapterQuestion.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final question = Question.fromMap(map['attributes']);
      return ChapterQuestion(question);
    } catch (e) {
      debugLogError('failed to parse chapter video $map', e);
      return null;
    }
  }

  @override
  List<Object> get props => [type, question];

  @override
  bool get stringify => true;
}

class ChapterVideoExercise extends Equatable {
  final String id;
  final String title;
  final String description;
  final Image image;
  final Duration duration;
  final bool isUploadAvailable;
  final int totalFinished;
  final Duration totalDuration;

  @visibleForTesting
  const ChapterVideoExercise(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.image,
      @required this.duration,
      @required this.isUploadAvailable,
      @required this.totalFinished,
      @required this.totalDuration})
      : assert(id != null),
        assert(title != null),
        assert(image != null),
        assert(duration != null);

  factory ChapterVideoExercise.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    final currentUser = map['current_user'] ?? {};

    // TODO: Update duration naming
    return ChapterVideoExercise(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        image: Image.fromMap(map['image']),
        duration: Duration(seconds: map['duration'] ?? 0),
        isUploadAvailable: map['allow_user_video_upload'] ?? false,
        totalFinished: currentUser['total_finished'] ?? 0,
        totalDuration: Duration(seconds: currentUser['total_duration'] ?? 0));
  }

  @override
  List<Object> get props => [id, title, image];

  @override
  bool get stringify => true;
}
