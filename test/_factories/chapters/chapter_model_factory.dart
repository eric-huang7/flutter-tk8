import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/data/models/video.model.dart';

import '../user_video_model_factory.dart';
import '../video_model_factory.dart';
import 'chapter_item_model_factory.dart';

Chapter mockChapterModel({
  String id,
  String title,
  String description,
  String previewImageUrl,
  List<UserVideo> userVideos,
  List<ChapterItem> items,
  Video trailerVideo,
  bool userVideosMock = true,
  bool itemsMock = true,
  bool trailerVideoMock = true,
}) {
  return Chapter(
    id: id ?? mockUUID(),
    title: title ?? mockString(),
    description: description ?? mockString(),
    previewImageUrl: previewImageUrl ?? mockUrl(),
    userVideos: !userVideosMock
        ? null
        : userVideos ??
            List<UserVideo>.generate(
                mockInteger(0, 1), (_) => mockUserVideoModel()),
    items: !itemsMock
        ? null
        : items ??
            List<ChapterItem>.generate(
                mockInteger(), (_) => mockChapterItemModel()),
    trailerVideo: !trailerVideoMock ? null : trailerVideo ?? mockVideoModel(),
  );
}
