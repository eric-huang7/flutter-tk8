import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import 'chapter_details_header.viewmodel.dart';

const chapterDetailsAppBarHeight = 360.0;

const _scrollOffsetTrailerPauseThreshold = 20;

class ChapterDetailsHeaderView extends StatefulWidget {
  @override
  _ChapterDetailsHeaderState createState() => _ChapterDetailsHeaderState();
}

class _ChapterDetailsHeaderState extends State<ChapterDetailsHeaderView> {
  VideoPlayerController _trailerVideoPlayerController;
  ScrollController _scrollController;

  bool _trailerVideoPlayerInitializing = true;

  bool get _trailerIsPlaying =>
      _trailerVideoPlayerController?.value?.isPlaying ?? false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController.addListener(_primaryScrollControllerListerner);
    });
  }

  @override
  void dispose() {
    _trailerVideoPlayerController
        ?.removeListener(_trailerVideoPlayerControllerListerner);
    if (_trailerIsPlaying ?? false) {
      _trailerVideoPlayerController.pause();
    }

    _scrollController?.removeListener(_primaryScrollControllerListerner);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChapterDetailsHeaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_trailerVideoPlayerController == null) {
      _initializeVideoPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChapterDetailsHeaderViewModel>();
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: NetworkImageView(
            imageUrl: model.previewImageUrl,
          ),
        ),
        _buildTrailerVideoPlayer(),
        Opacity(
          opacity: 0.85,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.5, 0),
                end: const Alignment(0.5, 1),
                colors: [
                  TK8Colors.superDarkBlue.withOpacity(0),
                  TK8Colors.superDarkBlue,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          width: size.width * 0.7,
          left: 16,
          bottom: 16,
          child: SizedBox(
            height: chapterDetailsAppBarHeight,
            width: double.infinity,
            child: SizedBox(
              width: size.width * 0.67,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.showChapterCompletedTag) ...[
                    _buildChapterCompletedTag(),
                    const Space.vertical(8),
                  ],
                  Text(
                    model.title,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "RevxNeue",
                        fontSize: 24.0,
                        height: 1.15),
                  ),
                  if (model.description.isNotEmpty) ...[
                    const Space.vertical(8),
                    Text(
                      model.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          height: 1.5,
                          fontSize: 12.0),
                    ),
                  ],
                  const Space.vertical(12),
                  buildChapterContentInfo(),
                  if (model.showChapterActionButton) ...[
                    const Space.vertical(16),
                    _buildChapterActionButton()
                  ] else
                    const Space.vertical(8),
                ],
              ),
            ),
          ),
        ),
        if (_trailerVideoPlayerController != null)
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildTrailerPlayerButton(),
          ),
      ],
    );
  }

  Widget _buildChapterCompletedTag() {
    return LabelTag(
      translate('screens.chapterDetails.listHeader.chapterCompleted'),
      backgroundColor: TK8Colors.lightGreenishBlue,
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFamily: "RevxNeue",
        fontSize: 12.0,
        height: 1,
      ),
    );
  }

  Widget buildChapterContentInfo() {
    const textStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: "Gotham",
        fontStyle: FontStyle.normal,
        fontSize: 11.0,
        height: 1.6);
    final model = context.watch<ChapterDetailsHeaderViewModel>();
    return Row(children: [
      Text(
        translate(
          'screens.chapterDetails.listHeader.videosInfo.count',
          args: {'value': '${model.videoCount}'},
        ),
        style: textStyle,
      ),
      const Space.horizontal(24),
      Text(
        translate(
          'screens.chapterDetails.listHeader.videosInfo.duration',
          args: {'value': '${model.totalVideosDuration.inMinutes}'},
        ),
        style: textStyle,
      ),
    ]);
  }

  Widget _buildChapterActionButton() {
    final model = context.watch<ChapterDetailsHeaderViewModel>();
    return GestureDetector(
      onTap: () {
        context
            .read<ChapterDetailsHeaderViewModel>()
            .onPressChapterActionButton();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
          color: TK8Colors.ocean,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/svg/iconPlayCircle.svg',
              height: 20,
              width: 20,
              color: Colors.white,
            ),
            const Space.horizontal(8),
            Text(
              model.chapterActionText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: "Gotham",
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailerPlayerButton() {
    return InkWell(
      onTap: () {
        if (_trailerIsPlaying) {
          _trailerVideoPlayerController.pause();
        } else {
          _trailerVideoPlayerController.play();
        }
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        decoration: const BoxDecoration(
          color: Color(0x22FFFFFF),
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
        child: Row(
          children: [
            Text(
              translate(
                  'screens.chapterDetails.listHeader.actions.trailerVideo.title'),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Gotham",
                  fontStyle: FontStyle.normal,
                  fontSize: 11.0),
            ),
            const Space.horizontal(9),
            Icon(
              _trailerIsPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTrailerVideoPlayer() {
    if (_trailerVideoPlayerInitializing) {
      return const Center(child: AdaptiveProgressIndicator());
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _trailerVideoPlayerController.value.size?.width ?? 0,
          height: _trailerVideoPlayerController.value.size?.height ?? 0,
          child: VideoPlayer(_trailerVideoPlayerController),
        ),
      ),
    );
  }

  Future<void> _initializeVideoPlayer() async {
    final model = context.read<ChapterDetailsHeaderViewModel>();
    if (model.trailerVideo?.videoUrl == null) return;

    _trailerVideoPlayerController =
        VideoPlayerController.network(model.trailerVideo.videoUrl);
    _trailerVideoPlayerController
        .addListener(_trailerVideoPlayerControllerListerner);

    await _trailerVideoPlayerController.initialize();
    if (mounted) {
      // if we don't do this here the user can exit the screen
      // before the video player controller is initialized
      // and then it will start playint the video sound until we kill the app
      _trailerVideoPlayerController.setVolume(0.0);
      _trailerVideoPlayerController.setLooping(true);
      _trailerVideoPlayerController.play();
      setState(() => _trailerVideoPlayerInitializing = false);
    }
  }

  void _trailerVideoPlayerControllerListerner() {
    setState(() {});
  }

  void _primaryScrollControllerListerner() {
    final offset = _scrollController.offset;
    if (offset > _scrollOffsetTrailerPauseThreshold && _trailerIsPlaying) {
      _trailerVideoPlayerController.pause();
    }
  }
}
