import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/widgets/adaptive_progress_indicator.dart';
import 'package:tk8/ui/widgets/space.dart';

import 'exercise_done.viewmodel.dart';

class ExerciseDoneScreen extends StatelessWidget {
  final String chapterId;
  final String exerciseId;

  const ExerciseDoneScreen({Key key, this.chapterId, this.exerciseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseDoneViewModel(chapterId, exerciseId),
      child: _ExerciseDoneView(),
    );
  }
}

class _ExerciseDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseDoneViewModel>(builder: (context, model, child) {
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
                translate('screens.exerciseDone.exerciseFinished'),
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
                translate('screens.exerciseDone.finishedDescription'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TK8Colors.superDarkBlue,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Gotham",
                  fontSize: 14,
                ),
              ),
            ),
            const Spacer(),
            if (model.isLoading)
              const Center(child: AdaptiveProgressIndicator())
            else
              Column(
                children: [
                  Text('+ ${model.minutesTrainedThisSession}',
                      style: const TextStyle(
                        color: TK8Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: "RevxNeue",
                        fontSize: 20,
                      )),
                  const Space.vertical(12),
                  Text(
                    "${model.exercise.totalDuration.inMinutes}",
                    style: const TextStyle(
                      color: TK8Colors.superDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontFamily: "RevxNeue",
                      fontSize: 32,
                    ),
                  ),
                  const Space.vertical(4),
                  Text(
                    translate('screens.exerciseDone.minutesTrained'),
                    style: const TextStyle(
                      color: TK8Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Gotham",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            const Spacer(),
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
                onPressed: () => model.onContinueClicked(),
                child: Text(
                  translate(
                    'screens.exerciseDone.actions.continue.title',
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
                onPressed: () => model.onRepeatExerciseClicked(),
                child: Text(
                  translate(
                    'screens.exerciseDone.actions.trainAgain.title',
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
