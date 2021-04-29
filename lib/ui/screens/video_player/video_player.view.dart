import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/app_config.dart';
import 'package:tk8/services/services.dart';

import 'video_player.viewmodel.dart';
import 'widgets/chapter_controls.dart';
import 'widgets/test_question.dart';
import 'widgets/video_player.dart';
import 'widgets/video_rating.dart';

class VideoPlayerScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            model.closeVideoPlayer();
            return false;
          },
          child: OrientationBuilder(
            builder: (context, orientation) {
              return Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    if (model.showCurrentItem) _buildContent(),
                    if (orientation == Orientation.landscape &&
                        model.showPlayerControls) ...[
                      if (getIt<AppConfig>().showDebugScreen)
                        _buildJumpNextButton(context),
                      _buildCloseButton(context)
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        switch (model.currentItem.type) {
          case VideoPlayerItemType.video:
            return TK8VideoPlayer.video(
              video: model.currentItem.video,
              onVideoFinished: model.onVideoFinished,
            );

          case VideoPlayerItemType.videoRating:
            return Positioned.fill(
              child: VideoRating(),
            );

          case VideoPlayerItemType.question:
            return QuestionView(
              questionIndex: model.indexForQuestion(model.currentItem.question),
              question: model.currentItem.question,
            );

          case VideoPlayerItemType.playNextVideo:
            return Positioned.fill(
              child: VideoPlayerChapterControls(),
            );

          case VideoPlayerItemType.congratulationsVideo:
            return TK8VideoPlayer.videoUrlAndTitle(
              title: translate('chapterTests.congratulationsVideo.title'),
              videoUrl: getIt<VideosService>()
                  .chapterCompletedCongratulationsVideoUrl,
              onVideoFinished: model.doNextSequenceStep,
            );

          case VideoPlayerItemType.backToChapterOverview:
            return Positioned.fill(
              child: VideoPlayerChapterControls(),
            );

          default:
            return null;
        }
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    final viewModel =
        Provider.of<VideoPlayerScreenViewModel>(context, listen: false);
    return Positioned(
      top: 20,
      right: 20,
      child: GestureDetector(
        onTap: viewModel.closeVideoPlayer,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildJumpNextButton(BuildContext context) {
    final viewModel =
        Provider.of<VideoPlayerScreenViewModel>(context, listen: false);
    return Positioned(
      top: 20,
      right: 50,
      child: GestureDetector(
        onTap: viewModel.doNextSequenceStep,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.next_plan,
            color: Colors.red[300],
          ),
        ),
      ),
    );
  }
}
