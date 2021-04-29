import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:tk8/ui/resources/app_images.dart';

import '../chapter_details.viewmodel.dart';
import 'academy_list_tile_element.dart';

class AcademyQuizListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChapterDetailsViewModel>();

    AcademyItemProgressStatus progressStatus;
    if (!model.allVideosCompleted) {
      progressStatus = AcademyItemProgressStatus.locked;
    } else if (model.allQuestionsAnswered) {
      progressStatus = AcademyItemProgressStatus.done;
    } else {
      progressStatus = AcademyItemProgressStatus.available;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => model.onSelectQuizItem(),
      child: AcademyListTileElement(
        title: translate('screens.chapterDetails.academy.quizItem.title'),
        subtitle: translatePlural(
          'screens.chapterDetails.academy.quizItem.questions',
          model.chapter.questionItems.length,
        ),
        orderNumber: model.videoItems.length + 1,
        progressStatus: progressStatus,
        prevProgressStatus: model.allVideosCompleted
            ? AcademyItemProgressStatus.done
            : AcademyItemProgressStatus.locked,
        highlight: model.allVideosCompleted && !model.chapterCompleted,
        thumbnail: SvgPicture.asset(
          TK8Images.chapterDetailsQuizThumbnail,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
