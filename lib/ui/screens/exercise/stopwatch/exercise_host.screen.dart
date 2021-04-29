import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/screens/exercise/stopwatch/exercise.viewmodel.dart';
import 'package:tk8/ui/screens/exercise/stopwatch/exercise_countdown.screen.dart';
import 'package:tk8/ui/screens/exercise/stopwatch/exercise_timer.screen.dart';

class ExerciseScreen extends StatelessWidget {
  final ChapterVideoExercise exercise;
  final String chapterId;

  const ExerciseScreen(
      {Key key, @required this.exercise, @required this.chapterId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ExerciseViewModel(exercise, chapterId),
        child: Stack(children: [
          Positioned.fill(child: Container(color: TK8Colors.coolBlue)),
          Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.1,
              child: Opacity(
                  opacity: 0.6,
                  child: SvgPicture.asset(
                    TK8Images.backgroundTextLetsGo,
                    fit: BoxFit.fill,
                  ))),
          Positioned(
              child: Scaffold(
            backgroundColor: Colors.transparent,
            body: buildBody(),
          ))
        ]));
  }

  Widget buildBody() {
    return Consumer<ExerciseViewModel>(builder: (context, model, child) {
      switch (model.state) {
        case ExerciseScreenState.countdown:
          return ExerciseCountdownScreen(
              onCountdownFinished: model.onCountdownFinished);
        case ExerciseScreenState.training:
        default:
          return ExerciseTimerScreen();
      }
    });
  }
}
