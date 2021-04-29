import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/user.model.dart';
import 'package:tk8/data/repositories/user.repository.dart';
import 'package:tk8/services/services.dart';

import '../../_helpers/api.dart';
import '../../_helpers/mocks.dart';
import '../../_helpers/service_injection.dart';

void main() {
  setUpAll(() {
    initializeServiceInjectionForTesting();
  });

  group('user repository', () {
    group('validateUsername', () {
      void _setupApiResponseForStatusCode(int statusCode) {
        final mockClient = mockApiClientWithResponse(
          method: 'post',
          statusCode: statusCode,
        );
        getIt.registerLazySingleton<Api>(() => Api(mockClient));
      }

      test('should call api base with correct parameters', () async {
        // arrange
        final apiMock = ApiMock();
        getIt.registerLazySingleton<Api>(() => apiMock);
        const name = 'myUsername';
        final repo = UserRepository();

        // act
        await repo.validateUsername(name);

        // assert
        verify(apiMock.post(
          path: 'users/validations/name',
          body: {
            'user': {'name': name}
          },
          addClientHeaders: true,
        ));
        verifyNoMoreInteractions(apiMock);
      });

      test('should be ok when name is valid', () async {
        // arrange
        _setupApiResponseForStatusCode(200);
        const name = 'myUsername';
        final repo = UserRepository();

        // act
        final result = await repo.validateUsername(name);

        // assert
        expect(result, UsernameValidationResult.ok);
      });

      test('should return invalid username on 422', () async {
        // arrange
        _setupApiResponseForStatusCode(422);
        const name = 'myUsername';
        final repo = UserRepository();

        // act
        final result = await repo.validateUsername(name);

        // assert
        expect(result, UsernameValidationResult.invalidUsername);
      });

      test('should return other error on other status code result', () async {
        // arrange
        _setupApiResponseForStatusCode(401);
        const name = 'myUsername';
        final repo = UserRepository();

        // act
        final result = await repo.validateUsername(name);

        // assert
        expect(result, UsernameValidationResult.otherError);
      });
    });

    group('createUser', () {
      const id = '1234-abcd-5678=zxcf';
      const name = 'myUsername';
      final date = DateTime(2000, 11, 12);
      const token = 'foobar';
      ApiMock apiMock;

      void _mockApi() {
        apiMock = ApiMock();
        when(apiMock.post(
          path: anyNamed('path'),
          body: anyNamed('body'),
          addClientHeaders: true,
        )).thenAnswer(
          (realInvocation) async => {
            'data': {
              'id': id,
              'name': name,
              'birthdate': date.toIso8601String(),
              'token': token,
            }
          },
        );
        getIt.registerLazySingleton<Api>(() => apiMock);
      }

      test('should call api with correct parameters', () async {
        // arrange
        _mockApi();
        final repo = UserRepository();

        // act
        await repo.createUser(name, date);

        // assert
        verify(apiMock.post(
          path: 'users',
          body: {
            'name': name,
            'birthdate': {
              'year': date.year,
              'month': date.month,
              'day': date.day
            }
          },
          addClientHeaders: true,
        ));
        verifyNoMoreInteractions(apiMock);
      });

      test('should parse and return correct user data', () async {
        // arrange
        _mockApi();
        final repo = UserRepository();

        // act
        final result = await repo.createUser(name, date);

        // assert
        expect(result.user.username, name);
        expect(result.user.birthdate, date);
        expect(result.token, token);
      });

      test('should emit new user data in my profile stream', () async {
        // arrange
        _mockApi();
        final repo = UserRepository();

        // act
        await repo.createUser(name, date);

        // assert
        expect(
            repo.myProfileUserStream,
            emits(User.fromMap({
              'id': id,
              'name': name,
              'birthdate': date.toIso8601String(),
            })));
      });
    });

    group('loadMyProfile', () {
      const id = '1234-abcd-5678=zxcf';
      const name = 'myUsername';
      final date = DateTime(2000, 11, 12);
      ApiMock apiMock;

      void _mockApi() {
        apiMock = ApiMock();
        when(apiMock.get(path: anyNamed('path'))).thenAnswer(
          (realInvocation) async => {
            'data': {
              'id': id,
              'name': name,
              'birthdate': date.toIso8601String(),
            }
          },
        );
        getIt.registerLazySingleton<Api>(() => apiMock);
      }

      test('should call api with correct parameters', () async {
        // arrange
        _mockApi();
        final repo = UserRepository();

        // act
        await repo.loadMyProfile();

        // assert
        verify(apiMock.get(path: 'me'));
        verifyNoMoreInteractions(apiMock);
      });

      test('should parse and return correct user data', () async {
        // arrange
        _mockApi();
        final repo = UserRepository();

        // act
        final result = await repo.loadMyProfile();

        // assert
        expect(result.id, id);
        expect(result.username, name);
        expect(result.birthdate, date);
      });

      test('should emit new user data in my profile stream', () async {
        // arrange
        _mockApi();
        final repo = UserRepository();

        // act
        await repo.loadMyProfile();

        // assert
        expect(
            repo.myProfileUserStream,
            emits(User.fromMap({
              'id': id,
              'name': name,
              'birthdate': date.toIso8601String(),
            })));
      });
    });

    group('reset', () {
      test('should emit null in my profile stream', () async {
        // arrange
        final repo = UserRepository();
        // act
        repo.reset();
        // assert
        expect(repo.myProfileUserStream, emits(null));
      });
    });
  });
}
