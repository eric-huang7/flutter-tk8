import 'package:flutter/material.dart';
import 'package:tk8/data/models/academy_category.model.dart';
import 'package:tk8/data/models/article.model.dart';
import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/navigation/app_routes.dart';
import 'package:tk8/navigation/community_video_player_stream.arguments.dart';
import 'package:tk8/navigation/exercise_done.arguments.dart';
import 'package:tk8/navigation/exercise_feedback.arguments.dart';
import 'package:tk8/navigation/exercise_overview.arguments.dart';
import 'package:tk8/navigation/webview.arguments.dart';
import 'package:tk8/ui/screens/article_details/article_details.screen.dart';
import 'package:tk8/ui/screens/articles_overview/articles_overview.screen.dart';
import 'package:tk8/ui/screens/auth/login/login.screen.dart';
import 'package:tk8/ui/screens/chapter_details/chapter_details.screen.dart';
import 'package:tk8/ui/screens/chapter_details/community_video_player.screen.dart';
import 'package:tk8/ui/screens/chapter_details/community_video_stream_player.screen.dart';
import 'package:tk8/ui/screens/chapters_overview/chapters_overview.screen.dart';
import 'package:tk8/ui/screens/exercise/done/exercise_done.screen.dart';
import 'package:tk8/ui/screens/exercise/feedback/exercise_feedback.screen.dart';
import 'package:tk8/ui/screens/exercise/overview/exercise_overview.screen.dart';
import 'package:tk8/ui/screens/exercise/stopwatch/exercise_host.screen.dart';
import 'package:tk8/ui/screens/profile/me/edit/edit_profile.screen.dart';
import 'package:tk8/ui/screens/profile/me/settings/profile_settings.screen.dart';
import 'package:tk8/ui/screens/videos_overview/videos_overview.screen.dart';
import 'package:tk8/ui/screens/webview/webview.screen.dart';

import 'exercise_arguments.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments;

    switch (routeSettings.name) {
      // Auth
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => LoginScreen(),
        );
      
      // WebView
      case AppRoutes.webView:
        final WebViewArguments webViewArguments = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => WebViewScreen(url: webViewArguments.url, title: webViewArguments.title),);

      // Chapter
      case AppRoutes.chapterOverview:
        final AcademyCategory category = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ChaptersOverviewScreen(category: category));
      case AppRoutes.chapterDetails:
        final Chapter chapter = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ChapterDetailsScreen(chapter: chapter));

      case AppRoutes.videosOverview:
        final AcademyCategory category = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => VideosOverviewScreen(category: category));

      case AppRoutes.communityVideoPlayer:
        final UserVideo video = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CommunityVideoPlayerScreen(userVideo: video),
            fullscreenDialog: true);
      case AppRoutes.communityVideoPlayerStream:
        final CommunityVideoPlayerStreamArguments args = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => CommunityVideoStreamPlayerScreen(
                viewModel: args.viewModel, startVideoIndex: args.startIndex),
            fullscreenDialog: true);

      // Profile
      case AppRoutes.editUserProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case AppRoutes.profileSettings:
        return MaterialPageRoute(builder: (_) => ProfileSettingsScreen());

      // Articles
      case AppRoutes.articlesOverview:
        final AcademyCategory category = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ArticlesOverviewScreen(category: category));
      case AppRoutes.articleDetails:
        final Article article = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ArticleDetailsScreen(article: article));

      // Exercise
      case AppRoutes.exerciseOverview:
        final ExerciseOverviewArguments args = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ExerciseOverviewScreen(
                chapterId: args.chapterId, exerciseId: args.exerciseId));
      case AppRoutes.exercise:
        final ExerciseArguments args = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ExerciseScreen(
                chapterId: args.chapterId, exercise: args.exercise));
      case AppRoutes.exerciseFeedback:
        final ExerciseFeedbackArguments args = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ExerciseFeedbackScreen(
                chapterId: args.chapterId, exerciseId: args.exerciseId));
      case AppRoutes.exerciseDone:
        final ExerciseDoneArguments args = arguments;
        return MaterialPageRoute(
            settings: routeSettings,
            builder: (_) => ExerciseDoneScreen(
                chapterId: args.chapterId, exerciseId: args.exerciseId));

      default:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Center(
            child: Text("No route defined for this destination",
                textAlign: TextAlign.center),
          ),
        );
    }
  }
}
