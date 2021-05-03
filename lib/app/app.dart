import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/navigation/app_router.dart';
import 'package:tk8/services/services.dart';

Future<void> setupAndRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // make sure DynamicLinksService is started
  getIt<DynamicLinksService>().handleDynamicLinks();

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'de',
    supportedLocales: ['de'],
  );

  // this is required in order for flutter to aquire the system default.
  // one would think this would be done automatically, but it's not! :/
  findSystemLocale();

  runZonedGuarded(
    () => runApp(LocalizedApp(delegate, TK8App())),
    FirebaseCrashlytics.instance.recordError,
  );
}

class TK8App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    return MultiProvider(
      providers: [
        RepositoryProvider.value(value: getIt<AuthRepository>()),
        RepositoryProvider.value(value: getIt<UserRepository>()),
        RepositoryProvider.value(value: getIt<AuthService>()),
      ],
      child: MaterialApp(
        title: 'Toni Kroos Fußballschule',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
            brightness: Brightness.light,
            textTheme: Theme.of(context).textTheme.copyWith(
                headline6: const TextStyle(
                    color: TK8Colors.superDarkBlue,
                    fontWeight: FontWeight.w700,
                    fontFamily: "RevxNeue",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0)),
            iconTheme: const IconThemeData(color: TK8Colors.ocean),
          ),
          primaryColor: TK8Colors.ocean,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        // navigation setup
        onGenerateRoute: AppRouter.generateRoute,
        routes: NavigationService.setupRoutes(context),
        navigatorKey: getIt<NavigationService>().rootNavigatorKey,

        // localization setup
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
      ),
    );
  }
}
