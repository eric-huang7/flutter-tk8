import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../video_player.viewmodel.dart';

class VideoPlayerChapterControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        final video = model.lastPlayedVideoItem?.video;
        return Material(
          color: Colors.black,
          child: Stack(
            children: [
              if (video != null) ...[
                Positioned.fill(
                  child: NetworkImageView(
                    imageUrl: video.previewImageUrl,
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Text(
                    video.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gotham',
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ],
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
                child: model.hasMorePlayerItems
                    ? _buildPlayNextVideo()
                    : _buildBackToChapterDetails(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayNextVideo() {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        return Stack(
          children: [
            Center(child: _buildWatchAgain()),
            Positioned(
              bottom: 16,
              right: 52,
              child: _PlayNextVideoTimer(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWatchAgain() {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIconButton(
              iconFileName: 'iconBackwards',
              iconSize: const Size(64, 64),
              buttonSize: const Size(64, 64),
              iconColor: Colors.white,
              onPressed: model.playLastVideo,
            ),
            const Space.vertical(20),
            Text(
              translate('screens.videoPlayer.chapter.rewatchVideo'),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Gotham",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackToChapterDetails() {
    return Consumer<VideoPlayerScreenViewModel>(
        builder: (context, model, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translate('screens.videoPlayer.chapter.noMoreVideos'),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.white),
          ),
          ElevatedButton(
            onPressed: model.closeVideoPlayer,
            child: Text(translate(
              'screens.videoPlayer.chapter.actions.backToChapterOverview.title',
            )),
          ),
        ],
      );
    });
  }
}

class _PlayNextVideoTimer extends StatefulWidget {
  @override
  __PlayNextVideoTimerState createState() => __PlayNextVideoTimerState();
}

const _backgroundDecorationEdgeOffset = 8;
const _secondsToWait = 15;
const _waitButtonWidth = 210.0;
const _waitProgressWidth =
    _waitButtonWidth - _backgroundDecorationEdgeOffset * 2;

class __PlayNextVideoTimerState extends State<_PlayNextVideoTimer> {
  Timer _timeLeftTimer;
  int _timeLeft = _secondsToWait;

  @override
  void initState() {
    super.initState();
    _timeLeftTimer = Timer.periodic(
      const Duration(seconds: 1),
      _timerCallback,
    );
  }

  @override
  void dispose() {
    _timeLeftTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerScreenViewModel>(
        builder: (context, model, child) {
      return GestureDetector(
        onTap: model.doNextSequenceStep,
        child: SizedBox(
          width: _waitButtonWidth,
          height: 40,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.75,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: TK8Colors.ocean,
                  ),
                ),
              ),
              if (_timeLeft > 0)
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width: _waitProgressWidth -
                      ((_timeLeft - 1) / _secondsToWait * _waitProgressWidth),
                  height: 40,
                  decoration: const _DiagonalBackgroundDecoration(
                      color: TK8Colors.ocean),
                )
              else
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: TK8Colors.ocean,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/iconPlayCircle.svg',
                      color: Colors.white,
                    ),
                    const Space.horizontal(8),
                    Text(
                      translate(
                        'screens.videoPlayer.chapter.actions.playNextVideo.title',
                        args: {'seconds': _timeLeft},
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _timerCallback(_) {
    if (!mounted) return;
    _timeLeft--;
    if (_timeLeft >= 0) {
      setState(() {});
    } else {
      final model = Provider.of<VideoPlayerScreenViewModel>(
        context,
        listen: false,
      );
      model.doNextSequenceStep();
    }
  }
}

class _DiagonalBackgroundDecoration extends Decoration {
  final Color color;
  final EdgeInsets insets;

  const _DiagonalBackgroundDecoration({
    @required this.color,
    this.insets = EdgeInsets.zero,
  }) : assert(color != null);

  @override
  BoxPainter createBoxPainter([_]) {
    return _DiagonalBackgroundDecorationPainter(color: color, insets: insets);
  }
}

class _DiagonalBackgroundDecorationPainter extends BoxPainter {
  final Color color;
  final EdgeInsets insets;
  _DiagonalBackgroundDecorationPainter({this.color, this.insets});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final path = Path();
    final offsetWithInsets = offset.translate(insets.left, insets.top);
    final size = Size(
      configuration.size.width - insets.left - insets.right,
      configuration.size.height - insets.top - insets.bottom,
    );

    path.addPolygon([
      Offset(
        offsetWithInsets.dx,
        offsetWithInsets.dy,
      ),
      Offset(
        offsetWithInsets.dx + size.width + _backgroundDecorationEdgeOffset,
        offsetWithInsets.dy,
      ),
      Offset(
        offsetWithInsets.dx + size.width,
        offsetWithInsets.dy + size.height,
      ),
      Offset(
        offsetWithInsets.dx,
        offsetWithInsets.dy + size.height,
      ),
    ], true);

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2,
    );
  }
}
