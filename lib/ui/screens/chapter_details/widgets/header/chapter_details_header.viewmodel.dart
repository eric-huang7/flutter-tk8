import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/video.model.dart';

import '../../chapter_details.viewmodel.dart';

class ChapterDetailsHeaderViewModel extends ChangeNotifier {
  final ChapterDetailsViewModel parentModel;
  Chapter _chapter;

  String get title => _chapter.title;
  String get description => _chapter.description ?? '';
  String get previewImageUrl => _chapter.trailerVideo.previewImageUrl;
  Video get trailerVideo => _chapter.trailerVideo;
  int get videoCount => _chapter.videoItems.length;
  Duration get totalVideosDuration => Duration(
      seconds: _chapter.videos.fold(
          0,
          (previousValue, element) =>
              previousValue + element.duration.inSeconds));
  bool get showChapterCompletedTag =>
      parentModel.allVideosCompleted && parentModel.allQuestionsAnswered;
  bool get showChapterActionButton => !showChapterCompletedTag;
  String get chapterActionText {
    return parentModel.currentChapterItemIndex == 0 &&
            !parentModel.allVideosCompleted
        ? translate(
            'screens.chapterDetails.listHeader.actions.startChapter.title')
        : translate(
            'screens.chapterDetails.listHeader.actions.continueChapter.title');
  }

  ChapterDetailsHeaderViewModel({
    @required this.parentModel,
  }) : assert(parentModel != null) {
    _chapter = parentModel.chapter;
    parentModel.addListener(_parentModelListener);
  }

  @override
  void dispose() {
    parentModel.removeListener(_parentModelListener);
    super.dispose();
  }

  void onPressChapterActionButton() {
    if (parentModel.allVideosCompleted) {
      parentModel.onSelectQuizItem();
    } else {
      final video = parentModel.videos[parentModel.currentChapterItemIndex];
      parentModel.playVideo(video);
    }
  }

  void _parentModelListener() {
    _chapter = parentModel.chapter;
    notifyListeners();
  }
}
