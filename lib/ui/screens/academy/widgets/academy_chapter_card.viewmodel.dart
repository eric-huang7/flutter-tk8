import 'package:flutter/foundation.dart';
import 'package:tk8/data/models/academy_category.model.dart';

class AcademyChapterCardViewModel extends ChangeNotifier {
  final ChapterCategoryItem chapterItem;
  AcademyChapterCardViewModel(this.chapterItem);

  int get numberOfVideos => chapterItem.chapter.videosCount;
  int get numberOfMinutes =>
      (chapterItem.chapter.totalRuntimeSeconds / 60).ceil();
}
