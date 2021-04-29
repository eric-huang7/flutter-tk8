import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/services/navigation.service.dart';
import 'package:tk8/services/services_injection.dart';
import 'package:tk8/ui/resources/app_images.dart';
import 'package:tk8/ui/screens/exercise/overview/exercise_overview.viewmodel.dart';
import 'package:tk8/ui/widgets/label_tag.dart';
import 'package:tk8/ui/widgets/space.dart';
import 'package:tk8/ui/widgets/widgets.dart';

const _exerciseSchemeHeight = 0.35;

class ExerciseOverviewScreen extends StatelessWidget {
  final String exerciseId;
  final String chapterId;

  const ExerciseOverviewScreen({
    Key key,
    @required this.chapterId,
    @required this.exerciseId,
  })  : assert(chapterId != null),
        assert(exerciseId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseOverviewViewModel(chapterId, exerciseId),
      child: _ExerciseOverviewView(),
    );
  }
}

class _ExerciseOverviewView extends StatelessWidget {
  final navigator = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseOverviewViewModel>(
        builder: (context, model, child) {
      return Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(context, model.onBackClicked),
            body: SingleChildScrollView(
                child: model.isLoading
                    ? const Center(child: AdaptiveProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        _exerciseSchemeHeight,
                                    child: NetworkImageView(
                                      imageUrl: model.exercise.image.fullUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const Space.vertical(24),
                                  _buildExerciseStats(
                                      context,
                                      model.exercise.totalDuration,
                                      model.exercise.totalFinished),
                                ],
                              ),
                              if (model.isFinished)
                                Positioned(
                                    left: 24,
                                    top: MediaQuery.of(context).size.height *
                                            _exerciseSchemeHeight -
                                        8,
                                    child: LabelTag(
                                      translate(
                                          'screens.exerciseOverview.exerciseCompleted'),
                                      backgroundColor:
                                          TK8Colors.lightGreenishBlue,
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "RevxNeue",
                                        fontSize: 12.0,
                                        height: 1,
                                      ),
                                    ))
                            ],
                          ),
                          const Space.vertical(24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              model.exercise.title,
                              style: const TextStyle(
                                  color: TK8Colors.superDarkBlue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "RevxNeue",
                                  fontSize: 20),
                            ),
                          ),
                          const Space.vertical(8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              model.exercise.description,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Gotham",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                            ),
                          ),
                          const Space.vertical(24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => model.onWatchTutorialClicked(),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: TK8Colors.ocean),
                                    width: 36,
                                    height: 36,
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 20,
                                      color: TK8Colors.white,
                                    ),
                                  ),
                                  const Space.horizontal(12),
                                  Expanded(
                                    child: Text(
                                        translate(
                                            'screens.exerciseOverview.actions.watchTutorial.title'),
                                        style: const TextStyle(
                                            color: TK8Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "RevxNeue",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Space.vertical(24),
                          if (model.isVideoUploadAvailable)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: _buildFeedbackRow(),
                            ),
                          const Space.vertical(100)
                        ],
                      )),
          ),
          Positioned(
              bottom: 0,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Positioned(
                    child: SvgPicture.asset(
                      TK8Images.footerExercise,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: SizedBox(
                      width: 262,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => model.onStartExerciseClicked(),
                        style: ElevatedButton.styleFrom(
                          primary: TK8Colors.ocean,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: Text(
                          translate(
                              'screens.exerciseOverview.actions.start.title'),
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            color: TK8Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Gotham",
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      );
    });
  }

  Widget _buildAppBar(BuildContext context, Function onBackClicked) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipOval(
          child: Material(
            color: TK8Colors.coolBlue,
            child: InkWell(
              onTap: () => onBackClicked(),
              child: const SizedBox(
                  child: Icon(
                Icons.arrow_back_ios_rounded,
                color: TK8Colors.ocean,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseStats(
      BuildContext context, Duration minTrained, int finishedTimes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(minTrained.inMinutes.toString(),
                  style: const TextStyle(
                      color: TK8Colors.superDarkBlue,
                      fontWeight: FontWeight.bold,
                      fontFamily: "RevxNeue",
                      fontSize: 32)),
              Text(translate('screens.exerciseOverview.minTrained'),
                  style: const TextStyle(
                      color: TK8Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Gotham",
                      fontSize: 14.0))
            ],
          ),
          const Space.horizontal(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$finishedTimes",
                style: const TextStyle(
                    color: TK8Colors.superDarkBlue,
                    fontWeight: FontWeight.bold,
                    fontFamily: "RevxNeue",
                    fontSize: 32),
              ),
              Text(
                translate('screens.exerciseOverview.timesFinished'),
                style: const TextStyle(
                    color: TK8Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFeedbackRow() {
    return Consumer<ExerciseOverviewViewModel>(
        builder: (context, model, child) {
      if (model.exercise.totalFinished == 0) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TK8Colors.grey.withOpacity(0.5)),
              ),
              width: 36,
              height: 36,
              child: const Icon(
                Icons.lock,
                size: 20,
                color: TK8Colors.grey,
              ),
            ),
            const Space.horizontal(12),
            Expanded(
              child: Text(
                  translate('screens.exerciseOverview.videoUploadRequirement',
                      args: {'value': '${model.exercise.duration.inMinutes}'}),
                  style: TextStyle(
                      color: TK8Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.normal,
                      fontFamily: "Gotham",
                      fontStyle: FontStyle.normal,
                      fontSize: 14)),
            )
          ],
        );
      } else if (!model.hasUserUploadedVideoBefore) {
        return InkWell(
          onTap: () {
            model.onUploadClicked();
          },
          child: Container(
            height: 171,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(TK8Images.backgroundVideoUpload,
                      fit: BoxFit.cover),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 54,
                      color: Colors.white,
                    ),
                    const Space.vertical(16),
                    Text(
                      translate(
                          'screens.chapterDetails.community.myVideo.uploadButton.title'),
                      style: const TextStyle(
                          color: TK8Colors.superLightGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "RevxNeue",
                          fontStyle: FontStyle.normal,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        return null;
      }
    });
  }
}
