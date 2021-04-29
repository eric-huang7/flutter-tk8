import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart';
import 'package:tk8/util/log.util.dart';

class ChapterDetailsViewModel extends ChangeNotifier {
  final _navigator = getIt<NavigationService>();
  final _api = getIt<Api>();
  final _academyRepository = getIt<AcademyRepository>();
  final _chapterTestsService = getIt<ChaptersTestsService>();
  final _videosRepository = getIt<VideosRepository>();
  Chapter _chapter;
  bool _isUploadingVideo = false;
  int _currentChapterItemIndex = 0;
  bool _allVideosCompleted = false;
  bool _allQuestionsAnswered = false;
  StreamSubscription<Map<String, Video>> _videosSubscription;
  StreamSubscription<Set<String>> _completedChapterIdsSubscription;

  final List<UserVideo> _communityVideos = [];
  bool _hasMoreCommunityVideos = true;
  bool _isLoadingCommnityVideos = false;
  PaginatedListResponse<UserVideo> _lastCommunityVideosResponse =
      PaginatedListResponse<UserVideo>.initial();

  ChapterDetailsViewModel(this._chapter) {
    getIt<ChaptersTestsService>(); // pump chapter tests saved info
    _loadChapterDetails();

    _videosSubscription =
        _videosRepository.videosStream.listen(_videosStreamListener);
    _completedChapterIdsSubscription = _chapterTestsService
        .questionsAnsweredIdsStream
        .listen((_) => _completedChapterIdsListener());
  }

  @override
  void dispose() {
    _videosSubscription.cancel();
    _completedChapterIdsSubscription.cancel();
    super.dispose();
  }

  Chapter get chapter => _chapter;

  String get title => _chapter.title;

  String get description => _chapter.description;

  List<ChapterVideo> get videoItems => _chapter.videoItems;

  List<Video> get videos => _chapter.videos;

  bool get allVideosCompleted => _allVideosCompleted;

  // TODO: this is temporary until the interface supports multiple uploaded user videos
  UserVideo get userVideo =>
      (_chapter.userVideos ?? []).isNotEmpty ? _chapter.userVideos[0] : null;

  bool get isUploadingVideo => _isUploadingVideo;

  List<UserVideo> get communityVideos => _communityVideos;

  bool get isLoadingCommunityVideos => _isLoadingCommnityVideos;

  int get currentChapterItemIndex => _currentChapterItemIndex;

  bool get hasQuestions => _chapter.questionItems.isNotEmpty;

  bool get allQuestionsAnswered => _allQuestionsAnswered;

  bool get chapterCompleted => allVideosCompleted && allQuestionsAnswered;

  Video get trailerVideo => _chapter?.trailerVideo;

  bool get hasTrailerVideo => trailerVideo != null;

  void playVideo(Video video) {
    _navigator.openVideoPlayerWithChapter(_chapter, video);
  }

  void onSelectVideoItem(ChapterVideo chapterVideo) {
    if (!_allVideosCompleted) {
      final itemIndex = _chapter.items.indexOf(chapterVideo);
      if (itemIndex > _currentChapterItemIndex) return;
    }

    playVideo(chapterVideo.video);
  }

  void onSelectQuizItem() {
    if (!_allVideosCompleted) return;
    _navigator.openVideoPlayerWithChapterQuiz(_chapter);
  }

  void onSelectExercise(String exerciseId) {
    _navigator.openExerciseOverviewScreen(exerciseId, chapter.id);
  }

  Future<void> selectAndUploadVideo() async {
    if (!_chapterTestsService.isChapterCompleted(_chapter)) {
      final alertInfo = AlertInfo(
        title: translate(
          'screens.chapterDetails.errors.chapterNotCompleted.title',
        ),
        text: translate(
          'screens.chapterDetails.errors.chapterNotCompleted.text',
        ),
        actions: [
          AlertAction(
              title: translate(
            'screens.chapterDetails.errors.chapterNotCompleted.actions.continueTraining.title',
          ))
        ],
      );
      _navigator.showAlertDialog(alertInfo);
      return;
    }

    _isUploadingVideo = true;
    notifyListeners();

    try {
      final file = await getIt<MediaLibraryService>().selectVideoFromGallery();
      await _api.uploadVideo(file, chapterId: _chapter.id);
      _navigator.showAlertDialog(
        AlertInfo(
          title: translate('screens.chapterDetails.uploadSuccessAlert.title'),
          text: translate('screens.chapterDetails.uploadSuccessAlert.text'),
          actions: [AlertAction(title: translate('alerts.actions.ok.title'))],
        ),
      );
    } on MediaLibraryServiceException catch (e) {
      switch (e.error) {
        case MediaLibraryServiceError.userCanceled:
          break;
        case MediaLibraryServiceError.accessDenied:
          _showMediaLibraryPermissionsRequired();
          break;
        default:
          _navigator.showGenericErrorAlertDialog();
      }
    } catch (_) {
      _navigator.showGenericErrorAlertDialog();
    }

    _loadChapterDetails();
    _isUploadingVideo = false;
    notifyListeners();
  }

  void checkNeedsLoadMoreCommunityVideosForIndex(int index) {
    if (!_hasMoreCommunityVideos) return;
    if (index >= _communityVideos.length - 3) {
      _loadCommunityVideos();
    }
  }

  // private api

  void _videosStreamListener(Map<String, Video> videosMap) {
    if (_allVideosCompleted || videosMap.keys.isEmpty || videos.isEmpty) return;

    final video = videos.firstWhere(
      (v) => !videosMap[v.id].viewCompleted,
      orElse: () => null,
    );

    if (video == null) {
      // couldn't find an incomplete video => all videos are completed
      _allVideosCompleted = true;
      notifyListeners();
      return;
    }

    for (var i = 0; i < chapter.items.length; i++) {
      final item = chapter.items[i];
      if (item is ChapterVideo) {
        if (item.video.id == video.id) {
          _currentChapterItemIndex = i;
          notifyListeners();
        }
      }
    }
  }

  void _completedChapterIdsListener() {
    if (_allQuestionsAnswered || _chapter.questionItems.isEmpty) return;
    for (final questionItem in _chapter.questionItems) {
      if (!_chapterTestsService.isQuestionAnswered(questionItem.question)) {
        return;
      }
    }
    _allQuestionsAnswered = true;
    notifyListeners();
  }

  void _showMediaLibraryPermissionsRequired() {
    _navigator.showAlertDialog(
      AlertInfo(
        title: translate(
            'screens.chapterDetails.mediaLibraryPermissionsRequiredAlert.title'),
        text: translate(
            'screens.chapterDetails.mediaLibraryPermissionsRequiredAlert.text'),
        actions: [AlertAction(title: translate('alerts.actions.ok.title'))],
      ),
    );
  }

  Future<void> _loadChapterDetails() async {
    _chapter = await _academyRepository.getChapterDetails(_chapter.id);
    notifyListeners();
    _completedChapterIdsListener();
    _loadCommunityVideos();
  }

  void _loadCommunityVideos() {
    if (_isLoadingCommnityVideos) return;
    _isLoadingCommnityVideos = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notifyListeners();
      try {
        _lastCommunityVideosResponse =
            await _academyRepository.getChapterCommunityVideos(
          _chapter.id,
          nextCursor: _lastCommunityVideosResponse.nextCursor,
        );
        _hasMoreCommunityVideos = _lastCommunityVideosResponse.list.isNotEmpty;
        _communityVideos.addAll(_lastCommunityVideosResponse.list);
      } catch (e) {
        debugLogError('failed to load more community videos', e);
      }
      _isLoadingCommnityVideos = false;
      notifyListeners();
    });
  }
}
