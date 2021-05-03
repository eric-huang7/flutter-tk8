import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tk8/data/models/auth.model.dart';
import 'package:tk8/data/models/user.model.dart';
import 'package:tk8/services/services.dart';

class AuthService {
  final _userRepository = getIt<UserRepository>();
  final _authRepository = getIt<AuthRepository>();

  Stream<AuthStatus> get statusStream => Rx.combineLatest2(
          _authRepository.tokenStream, _userRepository.myProfileUserStream,
          (AuthToken token, User user) {
        if (token != null && user != null) {
          return user.activated
              ? AuthStatus.signedInActive
              : AuthStatus.signedInInactive;
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
    String email,
    String invitationCode,
  }) async {
    assert(username != null && username.isNotEmpty);
    assert(birthdate != null);

    try {
      final newUserInfo = await _userRepository.createUser(
        username,
        birthdate,
        email,
        invitationCode,
      );

      await _authRepository.signInWithUserId(
        newUserInfo.userId,
        newUserInfo.optToken,
      );
      await _userRepository.loadMyProfile();
    } on Exception {
      await signOut();
      rethrow;
    }
  }

  Future<void> activateAccount({
    @required String email,
    @required String invitationCode,
  }) async {
    assert(email != null && email.isNotEmpty);
    assert(invitationCode != null);

    await _userRepository.activateAccount(
      email: email,
      invitationCode: invitationCode,
    );
    await _userRepository.loadMyProfile();
  }

  Future<void> signOut() async {
    _authRepository.reset();
    _userRepository.reset();
  }
}
