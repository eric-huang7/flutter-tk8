import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

import '../video/video_card.viewmodel.dart';

class HomeStreamVideoCard extends StatelessWidget {
  final HomeStreamVideoCardViewModel viewModel;

  const HomeStreamVideoCard({Key key, this.viewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: HomeStreamVideoCardView(),
    );
  }
}

class HomeStreamVideoCardView extends StatefulWidget {
  @override
  _HomeStreamVideoCardViewState createState() =>
      _HomeStreamVideoCardViewState();
}

class _HomeStreamVideoCardViewState extends State<HomeStreamVideoCardView> {
  VideoPlayerController _controller;
  double _playerAspectRatio = 1;

  @override
  void dispose() {
    _controller?.removeListener(_playerControllerListener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<HomeStreamVideoCardViewModel>().controller;
    if (_controller != controller) {
      _controller?.removeListener(_playerControllerListener);
      _controller = context.read<HomeStreamVideoCardViewModel>().controller;
      _controller?.addListener(_playerControllerListener);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomeStreamVideoCardViewModel>();
    return Stack(
      children: [
        Positioned.fill(
          child: _buildContent(context),
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 20,
          child: Text(
            model.homeStreamVideo.video.title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        if (!model.isPlaying) _buildPauseOverlay(),
      ],
    );
  }

  IgnorePointer _buildPauseOverlay() {
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

  Widget _buildContent(BuildContext context) {
    final model = context.watch<HomeStreamVideoCardViewModel>();
    if (model.controller == null) {
      return NetworkImageView(
        imageUrl: model.homeStreamVideo.video.previewImageUrl,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => model.togglePlay(),
      child: Center(
        child: AspectRatio(
            aspectRatio: _playerAspectRatio,
            child: VideoPlayer(model.controller)),
      ),
    );
  }

  void _playerControllerListener() {
    final value = _controller?.value?.aspectRatio ?? 1;
    if (value != _playerAspectRatio) {
      setState(() => _playerAspectRatio = value);
    }
  }
}
