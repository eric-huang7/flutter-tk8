import 'package:flutter/material.dart';
import 'package:tk8/data/models/home_stream.model.dart';
import 'package:video_player/video_player.dart';

import '../card_base.viewmodel.dart';

///
class HomeStreamVideoCardViewModel extends ChangeNotifier
    implements HomeStreamCardViewModelBase {
  final HomeStreamVideo homeStreamVideo;
  VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitiaised = false;

  VideoPlayerController get controller => _controller;
  bool get isPlaying => _isPlaying;
  @override
  HomeStreamCardType get type => HomeStreamCardType.video;

  HomeStreamVideoCardViewModel(this.homeStreamVideo);

  @override
  void dispose() {
    _controller.removeListener(_videoControllerListener);
    super.dispose();
  }

  @override
  void onActivate() {
    _controller?.play();
  }

  @override
  void onDeactivate() {
    _controller?.pause();
  }

  @override
  Future<void> onWarmup() async {
    if (!_isInitiaised) {
      _controller =
          VideoPlayerController.network(homeStreamVideo.video.videoUrl);
      _controller.addListener(_videoControllerListener);
      await _controller.initialize();
      _controller.setLooping(true);
      _isInitiaised = true;
    }
  }

  void togglePlay() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _videoControllerListener() {
    if (_isPlaying != _controller.value.isPlaying) {
      _isPlaying = _controller.value.isPlaying;
      notifyListeners();
    }
  }
}
