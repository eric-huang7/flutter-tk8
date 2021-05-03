import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:tk8/data/api/api.dart';

import '../../_helpers/api.dart';
import '../../_helpers/mocks.dart';
import '../../_helpers/service_injection.dart';

void main() {
  initializeServiceInjectionForTesting();

  group('api base', () {
    test('should call http client get with correct url', () async {
      // arrange
      final mockClient = mockApiClientWithResponse(body: '{"data":{}}');
      final api = Api(mockClient);
      final uri = Uri.parse('https://tk8-api.herokuapp.com/api/v1/test');

      // act
      await api.get(path: 'test');

      // assert
      verifyApiGetCallWithUrl(mockClient, uri);
    });

    test('should throw exception when response is not 200', () async {
      // arrange
      final mockClient = HttpClientMock();
      final api = Api(mockClient);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async {
        return Response('', 400);
      });

      // assert
      expect(
        () async => api.get(path: 'test'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
