import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/data/api/api.dart';

import 'mocks.dart';

HttpClientMock mockApiClientWithResponse({
  int statusCode = 200,
  String body = '',
  String method = 'get',
}) {
  final mockClient = HttpClientMock();
  // ignore: prefer_function_declarations_over_variables
  final answer = (realInvocation) async => Response(body, statusCode);
  switch (method) {
    case 'post':
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(answer);
      break;
    case 'put':
      when(mockClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(answer);
      break;
    case 'get':
    default:
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer(answer);
  }
  return mockClient;
}

void verifyApiGetCallWithUrl(HttpClientMock mockClient, dynamic uri) {
  verify(mockClient.get(
    uri,
    headers: {
      'Authorization': Api.getApiAuth(),
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));
}
