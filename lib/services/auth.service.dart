import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tk8/services/services.dart';

class AuthService {
  final _userRepository = getIt<UserRepository>();
  final _authRepository = getIt<AuthRepository>();

  Stream<AuthStatus> get statusStream => Rx.combineLatest2(
          _authRepository.tokenStream, _userRepository.myProfileUserStream,
          (token, user) {
        if (token != null && user != null) {
          return AuthStatus.signedIn;
        } else {
          return AuthStatus.signedOut;
        }
      });

  Future<void> autoSignIn() async {
    try {
      final token = await _authRepository.loadToken();
      final user = await _userRepository.loadMyProfile();
      if (token == null || user == null) {
        await signOut();
        return;
      }
    } on Exception {
      await signOut();
    }
  }

  Future<bool> requestOTP({
    @required String email,
  }) async {
    assert(email != null && email.isNotEmpty);

    try {
      await _authRepository.requestOTP(email);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> signIn({
    @required String email,
    @required String otp,
  }) async {
    assert(email != null && email.isNotEmpty);
    assert(otp != null && otp.isNotEmpty);

    try {
      await _authRepository.signInWithEmail(email, otp);
      await _userRepository.loadMyProfile();
      return true;
    } on Exception {
      await signOut();
      return false;
    }
  }

  Future<void> signUp({
    @required String username,
    @required DateTime birthdate,
  }) async {
    assert(username != null && username.isNotEmpty);
    assert(birthdate != null);

    try {
      final createdUser = await _userRepository.createUser(username, birthdate);
      await _authRepository.signInWithUserId(
          createdUser.user.id, createdUser.token);
    } on Exception {
      await signOut();
    }
  }

  Future<void> signOut() async {
    _authRepository.reset();
    _userRepository.reset();
  }
}
