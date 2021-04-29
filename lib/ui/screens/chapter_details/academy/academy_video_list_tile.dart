import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../chapter_details.viewmodel.dart';
import 'academy_list_tile_element.dart';

class AcademyVideoListTile extends StatelessWidget {
  final ChapterVideo videoItem;
  final int index;

  const AcademyVideoListTile({
    Key key,
    @required this.videoItem,
    @required this.index,
  })  : assert(videoItem != null),
        assert(index != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChapterDetailsViewModel>();

    AcademyItemProgressStatus progressStatus;
    AcademyItemProgressStatus prevProgressStatus;
    AcademyItemProgressStatus nextProgressStatus;
    if (index < model.currentChapterItemIndex || model.allVideosCompleted) {
      progressStatus = AcademyItemProgressStatus.done;
      prevProgressStatus = index > 0 ? AcademyItemProgressStatus.done : null;
      nextProgressStatus = AcademyItemProgressStatus.done;
    } else if (index == model.currentChapterItemIndex) {
      progressStatus = AcademyItemProgressStatus.available;
      prevProgressStatus = AcademyItemProgressStatus.done;
      nextProgressStatus = AcademyItemProgressStatus.locked;
    } else {
      progressStatus = AcademyItemProgressStatus.locked;
      prevProgressStatus = AcademyItemProgressStatus.locked;
      nextProgressStatus = AcademyItemProgressStatus.locked;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => model.onSelectVideoItem(videoItem),
          child: AcademyListTileElement(
            orderNumber: index + 1,
            title: videoItem.video.title,
            subtitle: _formatDuration(videoItem.video.duration),
            thumbnail: _imagePreview(videoItem.video.previewImageUrl),
            progressStatus: progressStatus,
            prevProgressStatus: index > 0 ? prevProgressStatus : null,
            nextProgressStatus: nextProgressStatus,
            highlight: index == model.currentChapterItemIndex &&
                !model.chapterCompleted,
          ),
        ),
        if ((index <= (model.currentChapterItemIndex - 1) ||
                model.allVideosCompleted) &&
            videoItem.exercise != null)
          GestureDetector(
            onTap: () => model.onSelectExercise(videoItem.exercise.id),
            child: AcademyListTileElement(
              title: videoItem.exercise.title,
              subtitle: _formatDuration(videoItem.exercise.duration),
              thumbnail: Image.asset(
                TK8Images.chapterDetailExerciseThumbnail,
                width: 80,
                height: 64,
              ),
              progressStatus: AcademyItemProgressStatus.available,
              prevProgressStatus: AcademyItemProgressStatus.available,
              nextProgressStatus: nextProgressStatus,
              progressStatusIndicatorSize:
                  AcademyItemProgressStatusIndicatorSize.small,
            ),
          ),
      ],
    );
  }

  Widget _imagePreview(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      child: Stack(
        children: [
          Positioned.fill(
            child: NetworkImageView(
              imageUrl: imageUrl,
            ),
          ),
          Container(
            width: 80,
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.5, 0),
                end: Alignment(0.5, 1),
                colors: [Color(0x00bee8ff), Color(0x8037acff)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes < 1) {
      return translate(
          'screens.chapterDetails.academy.videoItems.lessThanAMinute');
    }
    return translate(
      'screens.chapterDetails.academy.videoItems.duration',
      args: {'value': minutes},
    );
  }
}
