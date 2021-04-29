import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'chapter_details.viewmodel.dart';
import 'community/community_video_player.dart';

class CommunityVideoStreamPlayerScreen extends StatelessWidget {
  final ChapterDetailsViewModel viewModel;
  final int startVideoIndex;

  const CommunityVideoStreamPlayerScreen({
    Key key,
    @required this.viewModel,
    @required this.startVideoIndex,
  })  : assert(viewModel != null),
        assert(startVideoIndex != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: CommunityVideoStreamPlayer(startVideoIndex: startVideoIndex),
    );
  }
}

class CommunityVideoStreamPlayer extends StatefulWidget {
  final int startVideoIndex;

  const CommunityVideoStreamPlayer({
    Key key,
    @required this.startVideoIndex,
  })  : assert(startVideoIndex != null),
        super(key: key);

  @override
  _CommunityVideoStreamPlayerState createState() =>
      _CommunityVideoStreamPlayerState();
}

class _CommunityVideoStreamPlayerState
    extends State<CommunityVideoStreamPlayer> {
  final Map<String, VideoPlayerController> _videoControllers = {};
  PageController _pageController;
  int _currentVideoIndex = -1;
  ChapterDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startVideoIndex);
    _viewModel = Provider.of<ChapterDetailsViewModel>(context, listen: false);
    _viewModel.addListener(_modelListener);
    _modelListener();
    _updateVideoControllersForVideoAtIndex(widget.startVideoIndex);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_modelListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChapterDetailsViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: model.communityVideos.length,
            onPageChanged: _updateVideoControllersForVideoAtIndex,
            itemBuilder: (context, index) {
              final video = model.communityVideos[index];
              return CommunityVideoPlayer(
                controller: _videoControllers[video.id],
              );
            },
          ),
          Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  void _modelListener() {
    for (final video in _viewModel.communityVideos) {
      if (!_videoControllers.containsKey(video.id)) {
        _videoControllers[video.id] =
            VideoPlayerController.network(video.videoUrl);
      }
    }
  }

  Future<void> _updateVideoControllersForVideoAtIndex(int index) async {
    if (index == _currentVideoIndex) return;

    String nextVideoId;
    String previousVideoId = _currentVideoIndex >= 0
        ? _viewModel.communityVideos[_currentVideoIndex].id
        : null;
    final currentVideoId = _viewModel.communityVideos[index].id;
    if (_currentVideoIndex == -1) {
      // first run must be handled differently
      if (index > 0) {
        previousVideoId = _viewModel.communityVideos[index - 1].id;
        final previousVideoController = _videoControllers[previousVideoId];
        if (!previousVideoController.value.isInitialized) {
          previousVideoController.setLooping(true);
          previousVideoController.initialize();
        }
      }
      if (index < _viewModel.communityVideos.length - 2) {
        nextVideoId = _viewModel.communityVideos[index + 1].id;
        final nextVideoController = _videoControllers[nextVideoId];
        if (!nextVideoController.value.isInitialized) {
          nextVideoController.setLooping(true);
          nextVideoController.initialize();
        }
      }
    } else {
      if (index < _currentVideoIndex) {
        // scrolling up
        if (index > 0) {
          nextVideoId = _viewModel.communityVideos[index - 1].id;
        }
      } else {
        // scrolling down
        if (index < _viewModel.communityVideos.length - 2) {
          nextVideoId = _viewModel.communityVideos[index + 1].id;
        }
      }

      if (nextVideoId != null) {
        final nextVideoController = _videoControllers[nextVideoId];
        if (!nextVideoController.value.isInitialized) {
          nextVideoController.setLooping(true);
          nextVideoController.initialize();
        }
      }

      if (previousVideoId != null) {
        final previousVideoController = _videoControllers[previousVideoId];
        if (previousVideoController?.value?.isPlaying ?? false) {
          previousVideoController.pause();
        }
      }
    }

    final currentVideoController = _videoControllers[currentVideoId];
    if (!currentVideoController.value.isInitialized) {
      // this should only happen on first run. No harm done if we check it every time
      currentVideoController.setLooping(true);
      await currentVideoController.initialize();
    }
    if (!currentVideoController.value.isPlaying) currentVideoController.play();

    _currentVideoIndex = index;
  }
}
