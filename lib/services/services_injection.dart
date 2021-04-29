import 'package:get_it/get_it.dart';
import 'package:tk8/config/app_config.dart';
import 'package:tk8/data/api/base.api.dart';
import 'package:tk8/data/repositories/academy.repository.dart';
import 'package:tk8/data/repositories/articles.repository.dart';
import 'package:tk8/data/repositories/exercise.repository.dart';

import '../data/repositories/auth.repository.dart';
import '../data/repositories/home_stream.repository.dart';
import '../data/repositories/user.repository.dart';
import '../data/repositories/videos.repository.dart';
import 'auth.service.dart';
import 'chapters_tests.service.dart';
import 'device.service.dart';
import 'media_library.service.dart';
import 'navigation.service.dart';
import 'secure_store.service.dart';
import 'videos.service.dart';

final getIt = GetIt.instance;

void setupServicesInjection() {
  getIt.registerLazySingleton(() => AppConfig());
  getIt.registerLazySingleton(() => DeviceService());
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => AuthService()..autoSignIn());
  getIt.registerLazySingleton(() => SecureStoreService());
  getIt.registerLazySingleton(() => VideosService());
  getIt.registerLazySingleton(() => ChaptersTestsService());
  getIt.registerLazySingleton(() => MediaLibraryService());
  // data services
  getIt.registerLazySingleton(() => Api());
  getIt.registerLazySingleton(() => UserRepository());
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => HomeStreamRepository());
  getIt.registerLazySingleton(() => VideosRepository());
  getIt.registerLazySingleton(() => ArticlesRepository());
  getIt.registerLazySingleton(() => AcademyRepository());
  getIt.registerLazySingleton(() => ExerciseRepository());
}
