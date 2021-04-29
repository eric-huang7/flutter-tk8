import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/video.model.dart';

import 'video_player.view.dart';
import 'video_player.viewmodel.dart';

class VideoPlayerScreen extends StatelessWidget {
  final VideoPlayerType _type;
  final Chapter _chapter;
  final Video _video;

  const VideoPlayerScreen.video(
    Video video, {
    Key key,
  })  : assert(video != null),
        _type = VideoPlayerType.singleVideo,
        _chapter = null,
        _video = video,
        super(key: key);

  const VideoPlayerScreen.chapter(
    Chapter chapter, {
    Key key,
    Video video,
  })  : assert(chapter != null),
        _type = VideoPlayerType.chapterVideos,
        _chapter = chapter,
        _video = video,
        super(key: key);

  const VideoPlayerScreen.chapterQuiz(
    Chapter chapter, {
    Key key,
  })  : assert(chapter != null),
        _type = VideoPlayerType.chapterQuiz,
        _chapter = chapter,
        _video = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        switch (_type) {
          case VideoPlayerType.chapterVideos:
            return VideoPlayerScreenViewModel.chapterVideos(
              chapter: _chapter,
              startVideoId: _video.id,
            );

          case VideoPlayerType.chapterQuiz:
            return VideoPlayerScreenViewModel.chapterQuiz(
              chapter: _chapter,
            );

          case VideoPlayerType.singleVideo:
          default:
            return VideoPlayerScreenViewModel.singleVideo(
              video: _video,
            );
        }
      },
      child: VideoPlayerScreenView(),
    );
  }
}
