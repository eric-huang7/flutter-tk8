import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class CommunityVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final Function(String) onErrorCallback;

  const CommunityVideoPlayer({
    Key key,
    @required this.controller,
    this.onErrorCallback,
  })  : assert(controller != null),
        super(key: key);

  @override
  _CommunityVideoPlayerState createState() => _CommunityVideoPlayerState();
}

class _CommunityVideoPlayerState extends State<CommunityVideoPlayer> {
  VideoPlayerController _controller;
  double _playerAspectRatio = 1;
  bool _hasError = false;
  bool _isPlaying = false;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_videoControllerListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoControllerListener);
    if (_controller?.value?.isPlaying ?? false) {
      _controller?.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) Container();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _playerAspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (_controller.value.isBuffering)
            Positioned.fill(
              child: Container(
                color: const Color(0x55000000),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (!_controller.value.isPlaying)
            Positioned.fill(
              child: _buildPauseOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return IgnorePointer(
      child: Container(
        color: const Color(0x88000000),
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/iconPlay.svg',
            width: 40,
            height: 40,
            color: const Color(0x88FFFFFF),
          ),
        ),
      ),
    );
  }

  Future<void> _videoControllerListener() async {
    if (_controller.value.hasError && !_hasError) {
      _hasError = true;
      widget.onErrorCallback?.call(_controller.value.errorDescription);
      if (_controller.value.isPlaying) _controller.pause();
    }

    if (_controller.value.isBuffering != _isBuffering) {
      setState(() => _isBuffering = _controller.value.isBuffering);
    }

    if (_controller.value.isPlaying != _isPlaying) {
      setState(() => _isPlaying = _controller.value.isPlaying);
    }

    final aspectRatio = _controller.value.aspectRatio ?? 1;
    if (aspectRatio != _playerAspectRatio) {
      setState(() => _playerAspectRatio = aspectRatio);
    }
  }
}
