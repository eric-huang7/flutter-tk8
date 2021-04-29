import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/screens/exercise/feedback/exercise_feedback.viewmodel.dart';
import 'package:tk8/ui/widgets/space.dart';

class ExerciseFeedbackScreen extends StatelessWidget {
  final String chapterId;
  final String exerciseId;

  const ExerciseFeedbackScreen({Key key, this.chapterId, this.exerciseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseFeedbackViewModel(chapterId, chapterId),
      child: _ExerciseFeedbackView(),
    );
  }
}

class _ExerciseFeedbackView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseFeedbackViewModel>(
        builder: (context, model, child) {
      return Scaffold(
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      TK8Images.headerSuccess,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: SvgPicture.asset(TK8Images.iconTrophy,
                        color: TK8Colors.white),
                  )
                ],
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                translate('screens.exerciseGetFeedback.getFeedback'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TK8Colors.superDarkBlue,
                  fontWeight: FontWeight.w700,
                  fontFamily: "RevxNeue",
                  fontSize: 32,
                ),
              ),
            ),
            const Space.vertical(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                translate('screens.exerciseGetFeedback.getFeedbackDescription'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TK8Colors.superDarkBlue,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Gotham",
                  fontSize: 14,
                ),
              ),
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: TK8Colors.ocean,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                onPressed:
                    model.isUploadingVideo ? null : model.onUploadClicked,
                child: model.isUploadingVideo
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(TK8Colors.ocean),
                      )
                    : Text(
                        translate(
                          'screens.exerciseGetFeedback.actions.uploadVideo.title',
                        ),
                        style: const TextStyle(
                          color: TK8Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
            const Space.vertical(8),
            SizedBox(
              width: 250,
              height: 45,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  side: const BorderSide(color: TK8Colors.ocean, width: 2),
                  primary: TK8Colors.ocean,
                ),
                onPressed: () => {model.onLaterClicked()},
                child: Text(
                  translate(
                    'screens.exerciseGetFeedback.actions.later.title',
                  ),
                  style: const TextStyle(
                    color: TK8Colors.ocean,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    });
  }
}
