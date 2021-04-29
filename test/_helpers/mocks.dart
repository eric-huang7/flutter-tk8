import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/repositories/user.repository.dart';
import 'package:tk8/services/services.dart';

class HttpClientMock extends Mock implements http.Client {}

class ApiMock extends Mock implements Api {}

class SecureStoreServiceMock extends Mock implements SecureStoreService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class UserRepositoryMock extends Mock implements UserRepository {}

class MediaLibraryServiceMock extends Mock implements MediaLibraryService {}

class VideosRepositoryMock extends Mock implements VideosRepository {}

class AcademyRepositoryMock extends Mock implements AcademyRepository {}

class ChaptersTestsServiceMock extends Mock implements ChaptersTestsService {}
