import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/models/user.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/util/image.util.dart';
import 'package:tk8/util/log.util.dart';

enum UserRepositoryError {
  invalidUserData,
  other,
}

enum UsernameValidationResult {
  ok,
  invalidUsername,
  otherError,
}

enum ImageUploadResult {
  ok,
  invalidImage,
  otherError,
}

class UserRepositoryException implements Exception {
  final UserRepositoryError error;

  UserRepositoryException({
    this.error = UserRepositoryError.other,
  });
}

class CreateUserResponse {
  final String userId;
  final String optToken;

  CreateUserResponse(this.userId, this.optToken);
}

class UserRepository {
  final _api = getIt<Api>();

  final _myProfileUserController = BehaviorSubject<User>();

  User get myProfileUser => _myProfileUserController.value;
  Stream<User> get myProfileUserStream => _myProfileUserController.stream;

  void dispose() {
    _myProfileUserController.close();
  }

  Future<UsernameValidationResult> validateUsername(String username) async {
    final body = {
      'user': {'name': username}
    };

    try {
      await _api.post(
        path: 'users/validations/name',
        body: body,
        addClientHeaders: true,
      );
      return UsernameValidationResult.ok;
    } on ApiException catch (e) {
      return e.statusCode == 422
          ? UsernameValidationResult.invalidUsername
          : UsernameValidationResult.otherError;
    } catch (e) {
      debugLogError('failed to validate username', e);
      return UsernameValidationResult.otherError;
    }
  }

  Future<CreateUserResponse> createUser(
    String username,
    DateTime birthdate, [
    String email,
    String invitationCode,
  ]) async {
    final isValidActiveAccount = email != null && invitationCode != null;
    final body = {
      'user': {
        'name': username,
        'birthdate': {
          'year': birthdate.year,
          'month': birthdate.month,
          'day': birthdate.day
        },
        if (isValidActiveAccount) ...{
          'email': email,
          'claimed_invitation': {
            'code': invitationCode,
          }
        }
      }
    };
    final response = await _api.post(
      path: 'users',
      body: body,
      addClientHeaders: true,
    );

    final userId = response['data']['id'];
    final token = response['data']['token'];

    return CreateUserResponse(userId, token);
  }

  Future<void> activateAccount({String email, String invitationCode}) async {
    final body = {
      'user': {
        'email': email,
        'claimed_invitation': {
          'code': invitationCode,
        }
      }
    };
    await _api.put(
      path: 'me/activate',
      body: body,
    );
  }

  Future<User> loadMyProfile() async {
    final response = await _api.get(path: 'me');
    final user = User.fromMap(response['data']);
    _myProfileUserController.add(user);

    return user;
  }

  Future<User> updateUser({String usernmame}) async {
    try {
      final body = {
        'user': {'name': usernmame}
      };
      await _api.put(path: 'me', body: body);
      return await loadMyProfile();
    } on ApiException catch (e) {
      if (e.statusCode == 422) {
        throw UserRepositoryException(
          error: UserRepositoryError.invalidUserData,
        );
      }
      throw UserRepositoryException();
    } catch (e) {
      throw UserRepositoryException();
    }
  }

  Future<ImageUploadResult> uploadUserProfileBackgroundImage(File file) async {
    try {
      final base64data = await base64FromImageFile(file);
      final body = {
        "profile_background_image": {
          "data": base64data,
        }
      };
      await _api.put(
        path: 'me/profile_background_image',
        body: body,
      );
      await loadMyProfile();
      return ImageUploadResult.ok;
    } on ApiException catch (e) {
      return e.statusCode == 422
          ? ImageUploadResult.invalidImage
          : ImageUploadResult.otherError;
    } catch (e) {
      return ImageUploadResult.otherError;
    }
  }

  Future<ImageUploadResult> uploadUserProfileImage(File file) async {
    try {
      final base64data = await base64FromImageFile(file);
      final body = {
        "profile_image": {
          "data": base64data,
        }
      };
      await _api.put(
        path: 'me/profile_image',
        body: body,
      );
      await loadMyProfile();
      return ImageUploadResult.ok;
    } on ApiException catch (e) {
      return e.statusCode == 422
          ? ImageUploadResult.invalidImage
          : ImageUploadResult.otherError;
    } catch (e) {
      return ImageUploadResult.otherError;
    }
  }

  void reset() {
    _myProfileUserController.add(null);
  }
}
