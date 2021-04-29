import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tk8/data/models/user.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/ui/screens/profile/me/view/my_profile.bloc.dart';

import '../../../../../_fixtures/fixture_reader.dart';
import '../../../../../_helpers/mocks.dart';
import '../../../../../_helpers/service_injection.dart';

void main() {
  final userRepositoryMock = UserRepositoryMock();

  setUp(() {
    getIt.reset();
    initializeServiceInjectionForTesting();
    getIt.registerLazySingleton<UserRepository>(() => userRepositoryMock);
  });

  setUpAll(() {
    reset(userRepositoryMock);
  });

  group('view myprofile screen', () {
    group('state', () {
      const String username = 'myUsername';
      const String profileImageUrl = 'http://some.url/image/profile.jpg';
      const String backgroundImageUrl = 'http://some.url/image/background.jpg';
      const int age = 42;

      test('should use constructor parameters', () async {
        // act
        const state = MyProfileState(
          username: username,
          profileImageUrl: profileImageUrl,
          backgroundImageUrl: backgroundImageUrl,
          age: age,
        );
        // assert
        expect(state.username, username);
        expect(state.profileImageUrl, profileImageUrl);
        expect(state.backgroundImageUrl, backgroundImageUrl);
        expect(state.age, age);
      });

      test('should have correct initial data', () async {
        // arrange
        // act
        const state = MyProfileState.initial();
        // assert
        expect(state.username, null);
        expect(state.profileImageUrl, null);
        expect(state.backgroundImageUrl, null);
        expect(state.age, null);
      });

      test('should copy stae with given parameters', () async {
        // arrange
        const state = MyProfileState.initial();
        // act
        final newState = state.copyWith(
          username: username,
          profileImageUrl: profileImageUrl,
          backgroundImageUrl: backgroundImageUrl,
          age: age,
        );
        // assert
        expect(newState.username, username);
        expect(newState.profileImageUrl, profileImageUrl);
        expect(newState.backgroundImageUrl, backgroundImageUrl);
        expect(newState.age, age);
      });
    });

    group('bloc', () {
      blocTest<MyProfileBloc, MyProfileState>(
        'should start with correct initial data',
        build: () {
          final user = User.fromMap(fixtureAsMap('user/user.json'));
          when(userRepositoryMock.myProfileUser).thenReturn(user);
          when(userRepositoryMock.myProfileUserStream)
              .thenAnswer((_) => Stream<User>.value(user));
          return MyProfileBloc();
        },
        verify: (cubit) => cubit.state == const MyProfileState.initial(),
      );

      group('should emit new state when user repository updates', () {
        final user = User.fromMap(fixtureAsMap('user/user.json'));
        final otherUser = User.fromMap(fixtureAsMap('user/other_user.json'));
        final otherUserAge =
            DateTime.now().difference(otherUser.birthdate).inDays ~/ 365;
        final userStreamController = BehaviorSubject<User>.seeded(user);
        blocTest(
          '',
          build: () {
            when(userRepositoryMock.myProfileUser).thenReturn(user);
            when(userRepositoryMock.myProfileUserStream)
                .thenAnswer((_) => userStreamController.stream);
            return MyProfileBloc();
          },
          act: (cubit) {
            userStreamController.add(otherUser);
          },
          expect: [
            MyProfileState(
              age: otherUserAge,
              username: otherUser.username,
              backgroundImageUrl: otherUser.backgroudImage.fullUrl,
              profileImageUrl: otherUser.profileImage.fullUrl,
            )
          ],
        );
      });
    });
  });
}
