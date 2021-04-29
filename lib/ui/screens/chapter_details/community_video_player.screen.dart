import 'package:flutter/material.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:video_player/video_player.dart';

import 'community/community_video_player.dart';
import 'widgets/feedback_drawer.dart';

class CommunityVideoPlayerScreen extends StatefulWidget {
  final UserVideo userVideo;

  const CommunityVideoPlayerScreen({
    Key key,
    @required this.userVideo,
  })  : assert(userVideo != null),
        super(key: key);

  @override
  _CommunityVideoPlayerState createState() => _CommunityVideoPlayerState();
}

class _CommunityVideoPlayerState extends State<CommunityVideoPlayerScreen> {
  final _navigator = getIt<NavigationService>();
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    _controller = VideoPlayerController.network(widget.userVideo.videoUrl);
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_controller != null)
            CommunityVideoPlayer(
              controller: _controller,
              onErrorCallback: (_) async {
                await _navigator.showGenericErrorAlertDialog();
                _navigator.pop();
              },
            ),
          if (widget.userVideo.feedback != null)
            AcademyFeedbackDrawer(userVideo: widget.userVideo),
          Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              // if we don't add this spacer
              // the AppBar absorbs all taps in the screen
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
