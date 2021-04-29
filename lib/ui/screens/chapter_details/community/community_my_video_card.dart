import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'package:tk8/services/services.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../chapter_details.viewmodel.dart';

class CommunityUserVideoCard extends StatelessWidget {
  final _navigator = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChapterDetailsViewModel>();
    return GestureDetector(
      onTap: () {
        _navigator.openAcademyVideoPlayer(userVideo: model.userVideo);
      },
      child: Container(
        height: 171,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            boxShadow: [
              BoxShadow(
                color: Color(0x260c2246),
                blurRadius: 15,
              )
            ],
            color: Colors.white),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: NetworkImageView(
                imageUrl: model.userVideo.previewImageUrl,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ),
                    const Space.vertical(5),
                    Text(
                      translate(model.userVideo?.feedback?.text == null
                          ? 'screens.chapterDetails.community.myVideo.coachFeedback.noFeedbackYet'
                          : 'screens.chapterDetails.community.myVideo.coachFeedback.hasFeedback'),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 9.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
