import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tk8/util/log.util.dart';

class AuthToken extends Equatable {
  final String accessToken;
  final String tokenType;

  const AuthToken._(this.accessToken, this.tokenType)
      : assert(accessToken != null),
        assert(tokenType != null);

  factory AuthToken.fromMap(Map<String, dynamic> map) {
    try {
      return AuthToken._(
        map['access_token'],
        map['token_type'],
      );
    } catch (e) {
      debugLogError('failed to parse token data', e);
      return null;
    }
  }

  factory AuthToken.fromJson(String jsonData) {
    try {
      return AuthToken.fromMap(json.decode(jsonData));
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  @override
  List<Object> get props => [accessToken, tokenType];

  @override
  bool get stringify => true;
}
