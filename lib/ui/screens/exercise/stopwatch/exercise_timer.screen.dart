import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/screens/exercise/stopwatch/exercise_progress.dart';
import 'package:tk8/ui/widgets/label_tag.dart';
import 'package:tk8/ui/widgets/network_image_view.dart';
import 'package:tk8/ui/widgets/space.dart';
import 'package:tk8/util/time.dart';

import 'exercise.viewmodel.dart';

class ExerciseTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseViewModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 2),
              if (model.isRevisited || model.isFinished)
                LabelTag(
                  translate('screens.exerciseOverview.exerciseCompleted'),
                  backgroundColor: TK8Colors.lightGreenishBlue,
                  textStyle: const TextStyle(
                      color: TK8Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: "RevxNeue",
                      fontSize: 12.0),
                ),
              const Space.vertical(8),
              Text(
                model.exercise.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TK8Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: "RevxNeue",
                  fontSize: 32,
                ),
              ),
              const Spacer(),
              Text(
                formatDuration(model.exerciseElapsedTime),
                style: const TextStyle(
                  color: TK8Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  fontFamily: "RevxNeue",
                  fontSize: 96,
                ),
              ),
              const Space.vertical(24),
              if (!model.isRevisited)
                ExerciseProgress(progress: model.circleProgress),
              const Space.vertical(16),
              if (!model.isRevisited)
                Text(
                  _getDescriptionText(model),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TK8Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: "RevxNeue",
                    fontSize: 16,
                  ),
                ),
              const Spacer(flex: 2),
              if (model.isRevisited || model.isFinished)
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
                    onPressed: () => model.onFinishExerciseClicked(),
                    child: Text(
                      translate('screens.exercise.actions.finish.title'),
                      style: const TextStyle(
                        color: TK8Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Gotham",
                        fontStyle: FontStyle.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 250,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: TK8Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    onPressed: () => model.onCancelClicked(),
                    child: Text(
                      translate(
                        'screens.exercise.actions.cancelTraining.title',
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
                  onPressed: () => {
                    model.onShowSchemeClicked(),
                    showSchemeBottomSheet(
                        context,
                        model.exercise.image.fullUrl,
                        model.exercise.title,
                        model.exercise.description,
                        model.onCloseSchemeClicked)
                  },
                  child: Text(
                    translate(
                      'screens.exercise.actions.showScheme.title',
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
        ),
      );
    });
  }

  void showSchemeBottomSheet(BuildContext context, String imageUrl,
      String title, String description, VoidCallback onCloseClicked) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      child: NetworkImageView(
                          fit: BoxFit.fitWidth, imageUrl: imageUrl),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Space.vertical(24),
                              Text(title,
                                  style: const TextStyle(
                                      color: TK8Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "RevxNeue",
                                      fontSize: 20)),
                              const Space.vertical(16),
                              Text(description,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Gotham",
                                      fontSize: 13)),
                              const Space.vertical(24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 12,
                  right: 12,
                  child: FloatingActionButton(
                    backgroundColor: TK8Colors.coolBlue,
                    mini: true,
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.close_outlined,
                        color: TK8Colors.ocean),
                  )),
            ]),
          );
        }).whenComplete(() => onCloseClicked());
  }

  String _getDescriptionText(ExerciseViewModel model) {
    String descriptionText = "";
    if (!model.isFinished && !model.isLimitReached) {
      descriptionText = translate(
          'screens.exercise.trainingRequirementNotCompleted',
          args: {'value': '${model.exercise.duration.inMinutes}'});
    } else if (model.isFinished) {
      descriptionText = translate(
          'screens.exercise.trainingRequirementCompleted',
          args: {'value': '${model.exercise.duration.inMinutes}'});
    } else if (model.isLimitReached) {
      descriptionText = translate('screens.exercise.trainingLimitReached');
    }
    return descriptionText;
  }
}
