import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/widgets/widgets.dart';
import 'package:tk8/util/log.util.dart';
import 'package:tk8/util/time.dart';
import 'package:video_player/video_player.dart';

class TK8VideoPlayer extends StatefulWidget {
  final String title;
  final String videoUrl;
  final VoidCallback onVideoFinished;
  final Video video;

  TK8VideoPlayer.video({
    Key key,
    @required this.video,
    @required this.onVideoFinished,
  })  : assert(video != null),
        assert(onVideoFinished != null),
        title = video.title,
        videoUrl = video.videoUrl,
        super(key: key);

  const TK8VideoPlayer.videoUrlAndTitle({
    Key key,
    @required this.title,
    @required this.videoUrl,
    @required this.onVideoFinished,
  })  : video = null,
        assert(title != null),
        assert(videoUrl != null),
        assert(onVideoFinished != null),
        super(key: key);

  @override
  _TK8VideoPlayerState createState() => _TK8VideoPlayerState();
}

class _TK8VideoPlayerState extends State<TK8VideoPlayer>
    with WidgetsBindingObserver {
  final _videosRepository = getIt<VideosRepository>();
  VideoPlayerController _videoPlayerController;
  bool _isBuffering = false;
  bool _controllsVisible = true;
  bool _isPlaying = false;
  double _playSpeed = 1;
  Timer _autoHideControlsTimer;
  Duration _videoDuration = Duration.zero;
  Duration _currentVideoPlayPosition = Duration.zero;

  static const _seekJumpDuration = 10;
  static const _autoHideControlsDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _startPlaying();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isPlaying = false;
    _destroyController();
    _autoHideControlsTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _updateVideoViewDuration();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
          Positioned.fill(child: _buildPlayerControls()),
          if (!_controllsVisible)
            Positioned.fill(
              child: GestureDetector(onTap: _showControls),
            ),
          if (_isBuffering)
            const Center(child: AdaptiveProgressIndicator(size: 40)),
        ],
      ),
    );
  }

  Widget _buildPlayerControls() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _controllsVisible ? 1 : 0,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.5, 0.0023218968531468526),
                end: Alignment(0.5, 1),
                colors: [Color(0x40000000), Color(0xd9000000)],
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(onTap: _hideControls),
          ),
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gotham',
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
            ),
          ),
          if (widget.video != null)
            Positioned(
              top: 25,
              left: 25,
              child: StreamBuilder(
                stream: _videosRepository.getVideoStream(widget.video.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  final video = snapshot.data;
                  return SvgIconButton(
                    iconFileName: video.isFavorite
                        ? 'iconBookmarkFilled'
                        : 'iconBookmark',
                    iconColor: Colors.white,
                    onPressed: () {
                      if (video.isFavorite) {
                        _videosRepository.unfavoriteVideo(video: widget.video);
                      } else {
                        _videosRepository.favoriteVideo(video: widget.video);
                      }
                    },
                  );
                },
              ),
            ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildJumpBackButton(),
                const Space.horizontal(48),
                _buildPlayPauseButton(),
                const Space.horizontal(48),
                _buildJumpForwardButton(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _VideoPlayerSpeedButton(
                    videoPlayerController: _videoPlayerController,
                  ),
                  const Space.horizontal(15),
                  _buildVideoTimingText(_currentVideoPlayPosition),
                  const Space.horizontal(5),
                  Expanded(
                    child: VideoProgressIndicator(
                      _videoPlayerController,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                          playedColor: TK8Colors.ocean),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const Space.horizontal(5),
                  _buildVideoTimingText(_videoDuration),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTimingText(Duration duration) {
    return SizedBox(
      width: 45,
      child: Text(
        formatDuration(duration),
        textAlign: TextAlign.center,
        maxLines: 1,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gotham',
            fontStyle: FontStyle.normal,
            fontSize: 12.0),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return SvgIconButton(
      iconFileName: _isPlaying ? 'iconPause' : 'iconPlay',
      iconColor: Colors.white,
      buttonSize: const Size(64, 64),
      iconSize: const Size(64, 64),
      onPressed: () {
        _togglePlayPause();
        _resetControlsAutoHide();
      },
    );
  }

  Widget _buildJumpBackButton() {
    return SvgIconButton(
      iconFileName: 'videoPlayerBack10',
      onPressed: _replayPeriod,
      buttonSize: const Size(48, 48),
      iconSize: const Size(48, 48),
      iconColor: Colors.white,
    );
  }

  Widget _buildJumpForwardButton() {
    return SvgIconButton(
      iconFileName: 'videoPlayerForward10',
      onPressed: _forwardPeriod,
      buttonSize: const Size(48, 48),
      iconSize: const Size(48, 48),
      iconColor: Colors.white,
    );
  }

  void _hideControls() {
    setState(() => _controllsVisible = false);
  }

  void _showControls() {
    setState(() => _controllsVisible = true);
  }

  void _resetControlsAutoHide() {
    if (_autoHideControlsTimer != null) {
      _autoHideControlsTimer.cancel();
      _autoHideControlsTimer = null;
    }
    _autoHideControlsTimer = Timer(_autoHideControlsDuration, () {
      if (!mounted) return;
      if (_isPlaying) {
        setState(() {
          _controllsVisible = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  Future<void> _replayPeriod() async {
    await _seekRelative(const Duration(seconds: -_seekJumpDuration));
  }

  Future<void> _forwardPeriod() async {
    await _seekRelative(const Duration(seconds: _seekJumpDuration));
  }

  Future<void> _seekRelative(Duration durationChange) async {
    var position = await _videoPlayerController.position;
    position += durationChange;
    _videoPlayerController.seekTo(position);
  }

  void _videoControllerListener() {
    if (_videoPlayerController.value.isPlaying != _isPlaying) {
      _isPlaying = _videoPlayerController.value.isPlaying;
      if (_isPlaying) _controllsVisible = true;
    }

    if (_videoPlayerController.value.playbackSpeed != _playSpeed) {
      _playSpeed = _videoPlayerController.value.playbackSpeed;
    }

    if (_videoPlayerController.value.isBuffering != _isBuffering) {
      _isBuffering = _videoPlayerController.value.isBuffering;
    }
    if (_videoPlayerController.value.hasError) {
      debugLogError(_videoPlayerController.value.errorDescription);
      getIt<NavigationService>().showGenericErrorAlertDialog();
    }

    if (!_videoPlayerController.value.isPlaying &&
        _videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
      widget.onVideoFinished();
    }

    setState(() {
      _videoDuration = _videoPlayerController.value.duration;
      _currentVideoPlayPosition = _videoPlayerController.value.position;
    });
  }

  Future<void> _startPlaying() async {
    final videoUrl = widget.videoUrl;
    debugLog('will start playing video: $videoUrl');

    _videoPlayerController = VideoPlayerController.network(videoUrl);

    _videoPlayerController.initialize();
    _videoPlayerController.addListener(_videoControllerListener);
    await _videoPlayerController.play();

    _resetControlsAutoHide();

    setState(() {});
  }

  Future<void> _destroyController() async {
    if (_videoPlayerController == null) return;

    _updateVideoViewDuration();

    _videoPlayerController.removeListener(_videoControllerListener);
    _videoPlayerController.dispose();
    _videoPlayerController = null;
  }

  Future<void> _updateVideoViewDuration() async {
    if (widget.video != null &&
        (_currentVideoPlayPosition?.inSeconds ?? 0) > 0) {
      await _videosRepository.setViewDuration(
        video: widget.video,
        duration: _currentVideoPlayPosition,
      );
    }
  }
}

class _VideoPlayerSpeedButton extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const _VideoPlayerSpeedButton({
    Key key,
    @required this.videoPlayerController,
  })  : assert(videoPlayerController != null),
        super(key: key);

  @override
  __VideoPlayerSpeedButtonState createState() =>
      __VideoPlayerSpeedButtonState();
}

class __VideoPlayerSpeedButtonState extends State<_VideoPlayerSpeedButton> {
  static const _speedRange = [0.2, 0.5, 1.0, 1.5, 2.0];
  static const _speedRangeText = ['0.2x', '0.5x', '1x', '1.5x', '2x'];
  static const _normalPlaySpeedIndex = 2;
  int _currentSpeedRangeIndex = _normalPlaySpeedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _currentSpeedRangeIndex++;
        if (_currentSpeedRangeIndex >= _speedRange.length) {
          _currentSpeedRangeIndex = 0;
        }
        _updateUI();
      },
      onLongPress: () => setState(
        () {
          if (_currentSpeedRangeIndex == _normalPlaySpeedIndex) return;

          _currentSpeedRangeIndex = _normalPlaySpeedIndex;
          _updateUI();
        },
      ),
      child: Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            _speedRangeText[_currentSpeedRangeIndex],
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xfff1f1f1),
                fontWeight: FontWeight.w500,
                fontFamily: "Gotham",
                fontStyle: FontStyle.normal,
                fontSize: 12.0),
          ),
        ),
      ),
    );
  }

  void _updateUI() {
    widget.videoPlayerController
        .setPlaybackSpeed(_speedRange[_currentSpeedRangeIndex]);
    setState(() {});
  }
}
