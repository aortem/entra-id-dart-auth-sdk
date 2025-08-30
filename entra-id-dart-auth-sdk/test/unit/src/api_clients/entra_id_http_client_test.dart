import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdHttpClient', () {
    late EntraIdHttpClient client;

    test('GET request returns parsed JSON response', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, equals('GET'));
        expect(request.url.toString(), equals('https://api.example.com/test'));
        return http.Response(jsonEncode({'message': 'success'}), 200);
      });

      client = EntraIdHttpClient(
        baseUrl: 'https://api.example.com',
        client: mockClient,
      );

      final response = await client.get('/test');
      expect(response, containsPair('message', 'success'));
    });

    test('POST request sends body and returns parsed JSON response', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, equals('POST'));
        expect(request.url.toString(), equals('https://api.example.com/post'));
        expect(jsonDecode(request.body), equals({'key': 'value'}));
        return http.Response(jsonEncode({'status': 'ok'}), 200);
      });

      client = EntraIdHttpClient(
        baseUrl: 'https://api.example.com',
        client: mockClient,
      );

      final response = await client.post('/post', body: {'key': 'value'});
      expect(response, containsPair('status', 'ok'));
    });

    test('GET request throws error on non-2xx response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not found', 404);
      });

      client = EntraIdHttpClient(
        baseUrl: 'https://api.example.com',
        client: mockClient,
      );

      expect(
        () async => await client.get('/missing'),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('HTTP Error: 404'),
          ),
        ),
      );
    });

    test('Uses default headers and allows override', () async {
      final mockClient = MockClient((request) async {
        expect(request.headers['Authorization'], equals('Bearer 123'));
        expect(request.headers['X-Custom'], equals('override'));
        return http.Response(jsonEncode({'message': 'headers ok'}), 200);
      });

      client = EntraIdHttpClient(
        baseUrl: 'https://api.example.com',
        defaultHeaders: {'Authorization': 'Bearer 123'},
        client: mockClient,
      );

      final response = await client.get(
        '/check',
        headers: {'X-Custom': 'override'},
      );
      expect(response, containsPair('message', 'headers ok'));
    });
  });
}
