import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tk8/config/app_config.dart';
import 'package:tk8/services/services.dart';
import 'package:tk8/util/log.util.dart';

import 'api_auth.dart';

typedef PaginatedListResponseItemParser<T> = T Function(
  Map<String, dynamic> json,
);

class PaginatedListResponse<T> extends Equatable {
  final List<T> list;
  final String cursor;
  final String nextCursor;

  const PaginatedListResponse({
    this.list,
    this.cursor,
    this.nextCursor,
  });

  PaginatedListResponse.initial()
      : list = [],
        cursor = null,
        nextCursor = null;

  @override
  List<Object> get props => [list, cursor, nextCursor];

  @override
  bool get stringify => true;
}

class ApiException implements Exception {
  final int statusCode;

  ApiException({this.statusCode});

  @override
  String toString() {
    return 'ApiException{statusCode: $statusCode}';
  }
}

class Api {
  final http.Client _client;
  final _appConfig = getIt<AppConfig>();
  final _basePath = '/api';

  Api([http.Client client]) : _client = client ?? http.Client();

  Future<dynamic> get({
    String path,
    Map<String, dynamic> queryParameters,
  }) async {
    final response = await _client.get(
      _uriForPath(
        path,
        queryParameters: queryParameters,
      ),
      headers: _requestHeaders(),
    );

    return _processResponse(response);
  }

  Future<dynamic> post({
    String path,
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> body,
    bool addClientHeaders = false,
  }) async {
    final response = await _client.post(
      _uriForPath(
        path,
        queryParameters: queryParameters,
      ),
      headers: {
        ..._requestHeaders(),
        ...addClientHeaders ? _clientCredentialsHeaders() : {},
      },
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  Future<dynamic> put({
    String path,
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> body,
  }) async {
    final response = await _client.put(
      _uriForPath(
        path,
        queryParameters: queryParameters,
      ),
      headers: _requestHeaders(),
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  Future<dynamic> delete({
    String path,
    Map<String, dynamic> queryParameters,
  }) async {
    final response = await _client.delete(
      _uriForPath(
        path,
        queryParameters: queryParameters,
      ),
      headers: _requestHeaders(),
    );

    return _processResponse(response);
  }

  Future<PaginatedListResponse<T>> getPaginatedList<T>({
    @required String path,
    String afterCursor,
    String beforeCursor,
    @required PaginatedListResponseItemParser<T> itemParser,
  }) async {
    Map<String, String> queryParameters;
    final hasAfterCursor = afterCursor != null && afterCursor.isNotEmpty;
    final hasBeforeCursor = beforeCursor != null && beforeCursor.isNotEmpty;
    if (hasAfterCursor || hasBeforeCursor) {
      queryParameters = {};
      if (hasAfterCursor) {
        queryParameters['after'] = afterCursor;
      }
      if (hasBeforeCursor) {
        queryParameters['before'] = beforeCursor;
      }
    }
    final response = await get(
      path: path,
      queryParameters: queryParameters,
    );
    final data = response['data'];
    final pagination = response['pagination'];
    if (data is! List || pagination == null) {
      throw Exception('Invalid response for paginated list');
    }
    final itemsList = (data as List)
        .map((item) => itemParser(item))
        .where((item) => item != null)
        .toList();
    return PaginatedListResponse<T>(
      list: itemsList,
      cursor: pagination['cursor'],
      nextCursor: pagination['next_cursor'],
    );
  }

  // private helper methods

  Uri _uriForPath(
    String path, {
    String version = 'v1',
    Map<String, dynamic> queryParameters,
  }) {
    final uri = Uri.parse(_appConfig.apiHost);
    return uri.replace(
      path: '$_basePath/$version/$path',
      queryParameters: queryParameters,
    );
  }

  Map<String, String> _requestHeaders() {
    return {
      'Authorization': getApiAuth(),
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Map<String, String> _clientCredentialsHeaders() {
    final credentials = apiCredentials[getIt<AppConfig>().buildType];
    return {
      'Client-Id': credentials.id,
      'Client-Secret': credentials.secret,
    };
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 300) {
      debugLogError('${response.request} FAILED ${response.statusCode}');
      throw ApiException(statusCode: response.statusCode);
    }

    debugLog('${response.request} SUCCESS');
    return (response.body ?? '').isNotEmpty ? json.decode(response.body) : {};
  }

  @visibleForTesting
  static String getApiAuth() {
    final token = getIt<AuthRepository>().token;
    if (token == null) return null;
    return '${token.tokenType} ${token.accessToken}';
  }
}
