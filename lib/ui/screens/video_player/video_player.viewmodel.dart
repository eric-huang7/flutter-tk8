import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/questions.model.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';
import 'package:tk8/util/log.util.dart';

enum VideoPlayerType { singleVideo, chapterVideos, chapterQuiz }

enum VideoPlayerPhase { playlist, repeatTests, finish }

class VideoPlayerScreenViewModel extends ChangeNotifier {
  final VideoPlayerType _type;
  Chapter _chapter;
  List<VideoPlayerItem> _playerItems;

  final _device = getIt<DeviceService>();
  final _videosService = getIt<VideosService>();
  final _videosRepository = getIt<VideosRepository>();
  final _navigator = getIt<NavigationService>();
  final _chapterTests = getIt<ChaptersTestsService>();

  VideoPlayerPhase _currentPlayerPhase = VideoPlayerPhase.playlist;
  int _currentPlayerItemIndex = 0;
  bool _showPlayerControls = false;
  bool _showCurrentItem = false;
  bool _busyVideoRating = false;
  bool _hasAnsweredQuestion = false;
  bool _hasFailedQuestion = false;
  MultiChoiceQuestionAnswer _lastAnswer;
  bool _repeatingTests = false;

  bool get showPlayerControls => _showPlayerControls;
  bool get hasMorePlayerItems =>
      _currentPlayerItemIndex < _playerItems.length - 1;

  bool get busyVideoRating => _busyVideoRating;

  VideoPlayerItem get currentItem =>
      _currentPlayerItemIndex < _playerItems.length
          ? _playerItems[_currentPlayerItemIndex]
          : null;
  VideoPlayerItem get lastPlayedVideoItem {
    final index = _previousVideoIndex();
    if (index == null) return null;
    final item = _playerItems[index];
    if (item.type != VideoPlayerItemType.video) return null;
    return item;
  }

  bool get showCurrentItem => _showCurrentItem;

  MultiChoiceQuestionAnswer get lastAnswer => _lastAnswer;

  VideoPlayerScreenViewModel.singleVideo({@required Video video})
      : assert(video != null),
        _type = VideoPlayerType.singleVideo {
    _preparePlayerItemsSequenceForSingleVideo(video: video);
    _setupScreenAndPlayer();
  }

  VideoPlayerScreenViewModel.chapterVideos({
    @required Chapter chapter,
    String startVideoId,
  })  : assert(chapter != null),
        _type = VideoPlayerType.chapterVideos {
    _chapter = chapter;
    _preparePlayerItemsSequenceForChapter(chapter: chapter);
    if (startVideoId != null) {
      _currentPlayerItemIndex = _playerItems.indexWhere((item) =>
          item.type == VideoPlayerItemType.video &&
          item.video.id == startVideoId);
    }
    _setupScreenAndPlayer();
  }

  VideoPlayerScreenViewModel.chapterQuiz({
    @required Chapter chapter,
  })  : assert(chapter != null),
        _type = VideoPlayerType.chapterQuiz {
    _chapter = chapter;
    _preparePlayerItemsSequenceForChapter(chapter: chapter);
    _setupScreenAndPlayer();
  }

  // Actions

  void playLastVideo() {
    final index = _previousVideoIndex();
    if (index == null) return;
    _currentPlayerItemIndex = index;
    notifyListeners();
  }

  Future<void> closeVideoPlayer() async {
    _showPlayerControls = false;
    _showCurrentItem = false;
    notifyListeners();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await Future.delayed(const Duration(milliseconds: 350));
    getIt<NavigationService>().pop();
  }

  void doNextSequenceStep() {
    _lastAnswer = null;

    if (!hasMorePlayerItems) {
      if (_type == VideoPlayerType.singleVideo) {
        closeVideoPlayer();
      } else {
        _appendFinalItemsIfNeeded();
      }
      return;
    }

    _currentPlayerItemIndex++;
    _device.setKeepScreenAwake(currentItem.type == VideoPlayerItemType.video);
    notifyListeners();

    _logItems();
  }

  Future<void> rateVideo(int rating) async {
    if (rating <= 0) {
      doNextSequenceStep();
      return;
    }

    _busyVideoRating = true;
    notifyListeners();

    try {
      await _videosRepository.rateVideo(
        video: currentItem.video,
        rating: rating,
      );
    } on Exception catch (e) {
      debugLogError('failed to rate the video', e);
      await _navigator.showGenericErrorAlertDialog();
    }

    _busyVideoRating = false;
    notifyListeners();

    doNextSequenceStep();
  }

  // Callbacks

  void onVideoFinished() {
    doNextSequenceStep();
  }

  Future<void> onAnswerQuestion(MultiChoiceQuestionAnswer answer) async {
    assert(currentItem.type == VideoPlayerItemType.question);
    _lastAnswer = answer;
    notifyListeners();
    if (answer.isCorrect) {
      _hasAnsweredQuestion = true;
      _chapterTests.setQuestionAnsered(currentItem.question);
      final alert = AlertInfo(
        title: translate('chapterTests.correct.alert.title'),
        text: translate('chapterTests.correct.alert.text'),
        actions: [
          AlertAction(
            title: translate('alerts.actions.continue.title'),
            isDefault: true,
          ),
        ],
      );
      await _navigator.showAlertDialog(alert);
      doNextSequenceStep();
    } else {
      _hasFailedQuestion = true;
      final alert = AlertInfo(
        title: translate('chapterTests.failed.alert.title'),
        text: translate('chapterTests.failed.alert.text'),
        actions: [
          if (_currentPlayerPhase == VideoPlayerPhase.playlist)
            AlertAction(
              title: translate(
                  'chapterTests.failed.alert.actions.watchVideos.title'),
              isDefault: true,
              onPressed: _onRewatchVideosAfterFailedTest,
            ),
          AlertAction(
            title: translate('alerts.actions.continue.title'),
            onPressed: () => doNextSequenceStep(),
          ),
        ],
      );
      await _navigator.showAlertDialog(alert);
    }
  }

  // helper methods

  int indexForQuestion(Question question) {
    int index = -1;
    for (final item in _playerItems) {
      if (item.type == VideoPlayerItemType.question) {
        index++;
        if (item.question.id == question.id) break;
      }
    }
    return index;
  }

  // Private api

  void _onRewatchVideosAfterFailedTest() {
    final previousQuestionIndex = _previousQuestionIndex();
    _currentPlayerItemIndex = min(
      previousQuestionIndex == null ? 0 : previousQuestionIndex + 1,
      _playerItems.length - 1,
    );

    notifyListeners();
    _logItems();
  }

  int _previousQuestionIndex({int startFromIndex}) {
    int index = startFromIndex ?? _currentPlayerItemIndex;
    while (index >= 1) {
      index--;
      if (_playerItems[index].type == VideoPlayerItemType.question) {
        return index;
      }
    }
    return null;
  }

  int _previousVideoIndex({int startFromIndex}) {
    int index = startFromIndex ?? _currentPlayerItemIndex;
    while (index >= 1) {
      index--;
      if (_playerItems[index].type == VideoPlayerItemType.video) {
        return index;
      }
    }
    return null;
  }

  void _appendFinalItemsIfNeeded() {
    if (_currentPlayerPhase != VideoPlayerPhase.finish && !_repeatingTests) {
      _checkForChapterCompleted();
      _playerItems = [
        if (_hasAnsweredQuestion && !_hasFailedQuestion)
          VideoPlayerItem(VideoPlayerItemType.congratulationsVideo),
        VideoPlayerItem(VideoPlayerItemType.backToChapterOverview),
      ];
    } else {
      _playerItems = [
        VideoPlayerItem(VideoPlayerItemType.backToChapterOverview),
      ];
    }
    _currentPlayerItemIndex = 0;
    _currentPlayerPhase = VideoPlayerPhase.finish;
    _logItems();
    notifyListeners();
  }

  void _checkForChapterCompleted() {
    if (_type == VideoPlayerType.singleVideo) return;
    if (_chapterTests.isChapterCompleted(_chapter)) return;
    final chapterHasUnanseredQuestions = _chapter.items
        .whereType<ChapterQuestion>()
        .where((i) => _chapterTests.isQuestionAnswered(i.question))
        .isEmpty;
    if (!chapterHasUnanseredQuestions) {
      _chapterTests.setChapterCompleted(_chapter);
    }
  }

  Future<void> _setupScreenAndPlayer() async {
    await Future.delayed(const Duration(milliseconds: 350));
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await Future.delayed(const Duration(milliseconds: 350));
    _showCurrentItem = true;
    _showPlayerControls = true;
    notifyListeners();
  }

  void _preparePlayerItemsSequenceForSingleVideo({Video video}) {
    _playerItems = [];
    _playerItems.add(VideoPlayerItem.video(video));
    if (_videosService.shouldShowRatingForVideo(video)) {
      _playerItems.add(VideoPlayerItem(
        VideoPlayerItemType.videoRating,
        video: video,
      ));
    }
    _logItems();
  }

  void _preparePlayerItemsSequenceForChapter({Chapter chapter}) {
    if (_type == VideoPlayerType.singleVideo) return;
    _playerItems = [];
    if (_type == VideoPlayerType.chapterVideos) {
      final videoItems = chapter.items.whereType<ChapterVideo>().toList();
      for (var i = 0; i < videoItems.length; i++) {
        final item = videoItems[i];
        _playerItems.add(VideoPlayerItem.video(item.video));
        if (_videosService.shouldShowRatingForVideo(item.video)) {
          _playerItems.add(VideoPlayerItem(
            VideoPlayerItemType.videoRating,
            video: item.video,
          ));
        }
        _playerItems.add(VideoPlayerItem(VideoPlayerItemType.playNextVideo));
      }
    }

    final questionItems = chapter.items.whereType<ChapterQuestion>().toList();
    _repeatingTests = _type == VideoPlayerType.chapterQuiz &&
        questionItems
            .where((item) => !_chapterTests.isQuestionAnswered(item.question))
            .isEmpty;
    for (final item in questionItems) {
      if (_repeatingTests || !_chapterTests.isQuestionAnswered(item.question)) {
        _playerItems.add(VideoPlayerItem.question(item.question));
      }
    }

    _logItems();
  }

  void _logItems() {
    debugLog('player items current state: ----------------------------------');
    for (var i = 0; i < _playerItems.length; i++) {
      debugLog(
        '${_playerItems[i].type}${i == _currentPlayerItemIndex ? ' <-- current' : ''}',
      );
    }
    debugLog('player items current state: ----------------------------------');
  }
}

enum VideoPlayerItemType {
  video,
  videoRating,
  question,
  playNextVideo,
  congratulationsVideo,
  backToChapterOverview,
}

class VideoPlayerItem extends Equatable {
  final VideoPlayerItemType type;
  final Video video;
  final Question question;

  const VideoPlayerItem(
    this.type, {
    this.video,
  })  : question = null,
        assert(
          type != VideoPlayerItemType.video,
          'Use _VideoPlayerItemType.video constructor to create video items',
        ),
        assert(
          type != VideoPlayerItemType.question,
          'Use _VideoPlayerItemType.question constructor to create question items',
        );

  const VideoPlayerItem.video(this.video)
      : type = VideoPlayerItemType.video,
        question = null,
        assert(video != null);

  const VideoPlayerItem.question(this.question)
      : type = VideoPlayerItemType.question,
        video = null,
        assert(question != null);

  factory VideoPlayerItem.fromChapterItem(ChapterItem chapterItem) {
    if (chapterItem is ChapterVideo) {
      return VideoPlayerItem.video(chapterItem.video);
    }
    if (chapterItem is ChapterQuestion) {
      return VideoPlayerItem.question(chapterItem.question);
    }
    return null;
  }

  @override
  List<Object> get props => [type, question, video];

  @override
  bool get stringify => true;
}
