import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chapter_details.viewmodel.dart';
import 'academy_quiz_list_tile.dart';
import 'academy_video_list_tile.dart';

class ChapterDetailsAcademy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChapterDetailsViewModel>(builder: (context, model, child) {
      int index = 0;
      return SliverSafeArea(
        top: false,
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            ...model.videoItems.map(
              (videoItem) {
                return AcademyVideoListTile(
                  index: index++,
                  videoItem: videoItem,
                );
              },
            ).toList(),
            if (model.hasQuestions) AcademyQuizListTile(),
          ]),
        ),
      );
    });
  }
}
