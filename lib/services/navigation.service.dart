import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/models/article.model.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/data/models/video.model.dart';
import 'package:tk8/navigation/community_video_player_stream.arguments.dart';
import 'package:tk8/navigation/exercise_arguments.dart';
import 'package:tk8/navigation/exercise_done.arguments.dart';
import 'package:tk8/navigation/exercise_feedback.arguments.dart';
import 'package:tk8/navigation/exercise_overview.arguments.dart';
import 'package:tk8/navigation/webview.arguments.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/alerts/alert_dialog.dart' as alert;
import 'package:tk8/ui/screens/auth/sign_up/sign_up.screen.dart';
import 'package:tk8/ui/screens/chapter_details/chapter_details.viewmodel.dart';
import 'package:tk8/ui/screens/main/main.screen.dart';
import 'package:tk8/ui/screens/video_player/video_player.screen.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../navigation/app_routes.dart';

enum AppTab { home, categories, profile, debug }

class NavigationService {
  final GlobalKey<NavigatorState> _rootNavigatorKey;
  final _appTabController = BehaviorSubject<AppTab>.seeded(AppTab.home);

  NavigationService([GlobalKey<NavigatorState> rootNavigatorKey])
      : _rootNavigatorKey = rootNavigatorKey ?? GlobalKey<NavigatorState>();

  static Map<String, WidgetBuilder> setupRoutes(BuildContext context) {
    return {
      AppRoutes.root: (_) => _InitialRoute(),
    };
  }

  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  Stream<AppTab> get appTabStream => _appTabController.stream;

  AppTab get appTab => _appTabController.value;

  // main tabbar

  void setActiveTab(AppTab tab) {
    _appTabController.add(tab);
  }

  // screens navigation

  void pop<T extends Object>([T result]) {
    _rootNavigatorKey.currentState.pop(result);
  }

  void popBackUntil(String routeNameToReturnTo) {
    _rootNavigatorKey.currentState
        .popUntil(ModalRoute.withName(routeNameToReturnTo));
  }

  void openVideoPlayerWithVideo(Video video) {
    _pushVideoPlayer((_, __, ___) {
      return VideoPlayerScreen.video(video);
    });
  }

  void openVideoPlayerWithChapter(Chapter chapter, Video video) {
    _pushVideoPlayer((_, __, ___) {
      return VideoPlayerScreen.chapter(chapter, video: video);
    });
  }

  void openVideoPlayerWithChapterQuiz(Chapter chapter) {
    _pushVideoPlayer((_, __, ___) {
      return VideoPlayerScreen.chapterQuiz(chapter);
    });
  }

  void openChapterOverview(AcademyCategory category) {
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.chapterOverview, arguments: category);
  }

  void openChapterDetailsScreen(Chapter chapter) {
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.chapterDetails, arguments: chapter);
  }

  void openExerciseOverviewScreen(String exerciseId, String chapterId) {
    final args =
        ExerciseOverviewArguments(chapterId: chapterId, exerciseId: exerciseId);
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.exerciseOverview, arguments: args);
  }

  void openExerciseScreen(ChapterVideoExercise exercise, String chapterId) {
    final args = ExerciseArguments(exercise: exercise, chapterId: chapterId);
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.exercise, arguments: args);
  }

  void openExerciseFeedbackScreen(String chapterId, String exerciseId) {
    final args =
        ExerciseFeedbackArguments(chapterId: chapterId, exerciseId: exerciseId);
    _rootNavigatorKey.currentState
        .pushReplacementNamed(AppRoutes.exerciseFeedback, arguments: args);
  }

  void openExerciseDoneScreen(String chapterId, String exerciseId) {
    final args =
        ExerciseDoneArguments(chapterId: chapterId, exerciseId: exerciseId);
    _rootNavigatorKey.currentState
        .pushReplacementNamed(AppRoutes.exerciseDone, arguments: args);
  }

  // Hacky way to make overview refetch updated stats
  void repeatExercise(String chapterId, String exerciseId) {
    final args =
        ExerciseOverviewArguments(chapterId: chapterId, exerciseId: exerciseId);
    _rootNavigatorKey.currentState.pushNamedAndRemoveUntil(
        AppRoutes.exerciseOverview,
        ModalRoute.withName(AppRoutes.chapterDetails),
        arguments: args);
  }

  void openArticlesOverview(AcademyCategory category) {
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.articlesOverview, arguments: category);
  }

  void openArticleDetails(Article article) {
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.articleDetails, arguments: article);
  }

  void openEditUserProfile() {
    _rootNavigatorKey.currentState.pushNamed(AppRoutes.editUserProfile);
  }

  void openVideosOverview(AcademyCategory category) {
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.videosOverview, arguments: category);
  }

  void openWebViewScreen(String url, String title) {
    final args = WebViewArguments(url: url, title: title);
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.webView, arguments: args);
  }

  void openAcademyVideoPlayer({UserVideo userVideo}) {
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.communityVideoPlayer, arguments: userVideo);
  }

  void openChapterCommunityVideoStreamScreen(
    ChapterDetailsViewModel viewModel,
    int startVideoIndex,
  ) {
    final args = CommunityVideoPlayerStreamArguments(
        viewModel: viewModel, startIndex: startVideoIndex);
    _rootNavigatorKey.currentState
        .pushNamed(AppRoutes.communityVideoPlayerStream, arguments: args);
  }

  void openLogin() {
    _rootNavigatorKey.currentState.pushNamed(AppRoutes.login);
  }

  // private api

  void _pushVideoPlayer(RoutePageBuilder pageBuilder) {
    _rootNavigatorKey.currentState.push(
      PageRouteBuilder(
        pageBuilder: pageBuilder,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<T> showAlertDialog<T>(alert.AlertInfo alertInfo) {
    return alert.showAlertDialog(_rootNavigatorKey.currentContext, alertInfo);
  }

  Future<void> showGenericErrorAlertDialog({
    VoidCallback onRetry,
    bool showDefaultAction = true,
    String overrideTitle,
    String overrideText,
  }) {
    assert(showDefaultAction || onRetry != null);
    return showAlertDialog(
      alert.AlertInfo(
        title: overrideTitle ?? translate('alerts.genericError.title'),
        text: overrideText ?? translate('alerts.genericError.text'),
        actions: [
          if (showDefaultAction)
            alert.AlertAction(
              title: translate('alerts.actions.ok.title'),
            ),
          if (onRetry != null)
            alert.AlertAction(
              title: translate('alerts.actions.retry.title'),
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}

class _InitialRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InitialRouteModel(),
      child: Consumer<InitialRouteModel>(
        builder: (context, model, child) {
          switch (model.status) {
            case AuthStatus.signedIn:
              return MainScreen();
            case AuthStatus.signedOut:
              return SignUpScreen();
            case AuthStatus.unknown:
            default:
              return const Material(
                child: Center(
                  child: AdaptiveProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }
}

class InitialRouteModel extends ChangeNotifier {
  final _authService = getIt<AuthService>();
  AuthStatus status;
  StreamSubscription<AuthStatus> _authStatusSubscription;

  InitialRouteModel() {
    _authStatusSubscription = _authService.statusStream.listen((newStatus) {
      status = newStatus;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStatusSubscription.cancel();
    super.dispose();
  }
}
