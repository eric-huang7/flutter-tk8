import 'package:rxdart/rxdart.dart';
import 'package:tk8/config/app_config.dart';
import 'package:tk8/data/api/api.dart';
import 'package:tk8/data/api/api_auth.dart';
import 'package:tk8/data/models/auth.model.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/util/log.util.dart';

enum AuthStatus {
  unknown,
  signedOut,
  signedInInactive,
  signedInActive,
}

class AuthRepository {
  final _secureStore = getIt<SecureStoreService>();
  final _api = getIt<Api>();
  final _tokenController = BehaviorSubject<AuthToken>();

  AuthToken get token => _tokenController.value;

  Stream<AuthToken> get tokenStream => _tokenController.stream;

  void dispose() {
    _tokenController.close();
  }

  Future<void> requestOTP(String email) async {
    return _api.post(
        path: 'one_time_passwords',
        body: {
          'user': {'email': email}
        },
        addClientHeaders: true);
  }

  Future<AuthToken> signInWithUserId(String userId, String otp) async {
    final credentials = apiCredentials[getIt<AppConfig>().buildType];
    final tokenBody = {
      'grant_type': 'password',
      'client_id': credentials.id,
      'client_secret': credentials.secret,
      'user_id': userId,
      'token': otp,
    };
    final tokenResponse = await _api.post(
      path: 'oauth/token',
      body: tokenBody,
    );
    final token = AuthToken.fromMap(tokenResponse);
    _saveSessionInfo(token);
    _tokenController.add(token);
    return token;
  }

  Future<AuthToken> signInWithEmail(String email, String otp) async {
    final credentials = apiCredentials[getIt<AppConfig>().buildType];
    final tokenBody = {
      'grant_type': 'password',
      'client_id': credentials.id,
      'client_secret': credentials.secret,
      'email': email,
      'token': otp,
    };
    final tokenResponse = await _api.post(
      path: 'oauth/token',
      body: tokenBody,
    );
    final token = AuthToken.fromMap(tokenResponse);
    _saveSessionInfo(token);
    _tokenController.add(token);
    return token;
  }

  Future<void> reset() async {
    _tokenController.add(null);
    await _deleteSessionInfo();
  }

  static const _secureStoreTokenKey = 'tk8.auth.session.token';

  Future<AuthToken> loadToken() async {
    final token = AuthToken.fromJson(
      await _secureStore.getSecureValueForKey(_secureStoreTokenKey),
    );
    debugLog('loaded saved session token: $token');
    _tokenController.add(token);
    return token;
  }

  Future<void> _saveSessionInfo(AuthToken token) async {
    await _secureStore.setSecureValue(
      _secureStoreTokenKey,
      token.toJson(),
    );
  }

  Future<void> _deleteSessionInfo() async {
    await _secureStore.deleteValueForKey(_secureStoreTokenKey);
  }
}
