import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:entra_id_dart_auth_sdk/src/core/entra_id_http_client.dart';
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_exceptions.dart'
    as exception;
import 'package:entra_id_dart_auth_sdk/src/utils/entra_id_exceptions.dart';

/// Mock HTTP Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AortemEntraIdHttpClient client;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    client = AortemEntraIdHttpClient(
      baseUrl: 'https://api.example.com/',
      client: mockHttpClient,
    );
  });

  group('AortemEntraIdHttpClient Tests', () {
    test('GET request should return a successful response', () async {
      final expectedResponse = {'message': 'Success'};
      final responseJson = jsonEncode(expectedResponse);

      when(
        () => mockHttpClient.get(
          Uri.parse('https://api.example.com/test'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await client.get('/test');
      expect(result, expectedResponse);
    });

    test('POST request should return a successful response', () async {
      final expectedResponse = {'message': 'Created'};
      final responseJson = jsonEncode(expectedResponse);

      when(
        () => mockHttpClient.post(
          Uri.parse('https://api.example.com/test'),
          headers: any(named: 'headers'),
          body: jsonEncode({'key': 'value'}),
        ),
      ).thenAnswer((_) async => http.Response(responseJson, 201));

      final result = await client.post('/test', body: {'key': 'value'});
      expect(result, expectedResponse);
    });

    test('PUT request should return a successful response', () async {
      final expectedResponse = {'message': 'Updated'};
      final responseJson = jsonEncode(expectedResponse);

      when(
        () => mockHttpClient.put(
          Uri.parse('https://api.example.com/test'),
          headers: any(named: 'headers'),
          body: jsonEncode({'key': 'value'}),
        ),
      ).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await client.put('/test', body: {'key': 'value'});
      expect(result, expectedResponse);
    });

    test('DELETE request should return a successful response', () async {
      final expectedResponse = {'message': 'Deleted'};
      final responseJson = jsonEncode(expectedResponse);

      when(
        () => mockHttpClient.delete(
          Uri.parse('https://api.example.com/test'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await client.delete('/test');
      expect(result, expectedResponse);
    });

    test('Should throw an exception on HTTP error', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('https://api.example.com/error'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Server error', 500));

      expect(
        () async => await client.get('/error'),
        throwsA(
          isA<AortemHttpException>().having(
            (e) => e.statusCode,
            'statusCode',
            500,
          ),
        ),
      );
    });

    test('Should throw an exception on timeout', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('https://api.example.com/timeout'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Future.delayed(
          Duration(seconds: 15),
          () => http.Response('{}', 200),
        ),
      );

      expect(
        () async => await client.get('/timeout'),
        throwsA(
          isA<AortemHttpException>().having(
            (e) => e.statusCode,
            'statusCode',
            408,
          ),
        ),
      );
    });

    test('Should throw an exception on invalid JSON response', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('https://api.example.com/invalid-json'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('invalid-json', 200));

      expect(
        () async => await client.get('/invalid-json'),
        throwsA(
          isA<exception.AortemHttpException>().having(
            (e) => e.message,
            'message',
            contains('Invalid JSON response'),
          ),
        ),
      );
    });
  });
}
