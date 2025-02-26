
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entraid_http_client.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('AortemEntraIdHttpClient Tests', () {
    late MockHttpClient mockClient;
    late AortemEntraIdHttpClient httpClient;

    setUp(() {
      mockClient = MockHttpClient();
      httpClient = AortemEntraIdHttpClient(
        baseUrl: 'https://example.com',
        client: mockClient,
      );
    });

    test('GET request success', () async {
      when(mockClient.get(
        Uri.parse('https://example.com/test'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('{"key":"value"}', 200),
      );

      final response = await httpClient.get('/test');
      expect(response, {'key': 'value'});
    });

    test('POST request success', () async {
      when(mockClient.post(
        Uri.parse('https://example.com/test'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('{"key":"value"}', 201),
      );

      final response =
          await httpClient.post('/test', body: {'data': 'test'});
      expect(response, {'key': 'value'});
    });

    test('Request failure', () async {
      when(mockClient.get(
        Uri.parse('https://example.com/test'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async =>
            http.Response('{"error":"Something went wrong"}', 400),
      );

      expect(
        () async => await httpClient.get('/test'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
