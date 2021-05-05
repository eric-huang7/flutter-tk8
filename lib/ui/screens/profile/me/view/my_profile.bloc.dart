import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tk8/data/models/user.model.dart';
import 'package:tk8/services/services.dart';

class MyProfileState extends Equatable {
  final String username;
  final String profileImageUrl;
  final String backgroundImageUrl;
  final int age;
  final String footballClub;

  const MyProfileState({
    this.username,
    this.profileImageUrl,
    this.backgroundImageUrl,
    this.age,
    this.footballClub,
  });

  const MyProfileState.initial()
      : username = null,
        profileImageUrl = null,
        backgroundImageUrl = null,
        age = null,
        footballClub = null;

  MyProfileState copyWith({
    String username,
    String profileImageUrl,
    String backgroundImageUrl,
    int age,
    String footballClub,
  }) {
    return MyProfileState(
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      age: age ?? this.age,
      footballClub: footballClub ?? this.footballClub,
    );
  }

  @override
  List<Object> get props => [
        username,
        profileImageUrl,
        backgroundImageUrl,
        age,
        footballClub,
      ];
}

class MyProfileBloc extends Cubit<MyProfileState> {
  final _userRepository = getIt<UserRepository>();
  final _navigator = getIt<NavigationService>();
  StreamSubscription<User> _userSubscription;

  MyProfileBloc() : super(const MyProfileState.initial()) {
    _updateStateWithUser(_userRepository.myProfileUser);
    _userSubscription =
        _userRepository.myProfileUserStream.listen(_updateStateWithUser);
  }

  void dispose() {
    _userSubscription.cancel();
  }

  void editProfile() {
    _navigator.openEditUserProfile();
  }

  void openProfileSettings() {
    _navigator.openProfileSettings();
  }

  void _updateStateWithUser(User user) {
    if (user == null) {
      emit(const MyProfileState.initial());
      return;
    }
    final age = DateTime.now().difference(user.birthdate).inDays ~/ 365;
    final newState = state.copyWith(
      username: user.username,
      age: age,
      profileImageUrl: user.profileImage?.fullUrl,
      backgroundImageUrl: user.backgroudImage?.fullUrl,
    );
    emit(newState);
  }
}
