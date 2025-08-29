import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_http_exception.dart';

import 'package:http/testing.dart' as http_testing;

void main() {
  group('AortemEntraIdHttpClient', () {
    test('handles all verbs: GET/POST/PUT/PATCH/DELETE/OPTIONS/HEAD', () async {
      final mock = http_testing.MockClient((http.Request req) async {
        final path = req.url.path; // e.g., /get, /post, etc.
        switch (req.method) {
          case 'GET':
            if (path == '/get') {
              return http.Response(
                jsonEncode({'ok': true, 'method': 'GET'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            break;

          case 'POST':
            if (path == '/post') {
              return http.Response(
                jsonEncode({
                  'ok': true,
                  'method': 'POST',
                  'body': req.body.isEmpty ? null : jsonDecode(req.body),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            break;

          case 'PUT':
            if (path == '/put') {
              return http.Response(
                jsonEncode({'ok': true, 'method': 'PUT'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            break;

          case 'PATCH':
            if (path == '/patch') {
              return http.Response(
                jsonEncode({'ok': true, 'method': 'PATCH'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            break;

          case 'DELETE':
            if (path == '/delete') {
              return http.Response(
                jsonEncode({'ok': true, 'method': 'DELETE'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            break;

          case 'OPTIONS':
            if (path == '/options') {
              // Often no body for OPTIONS; 204 No Content is common
              return http.Response(
                '',
                204,
                headers: {'allow': 'GET,POST,PUT,DELETE,OPTIONS,HEAD,PATCH'},
              );
            }
            break;

          case 'HEAD':
            if (path == '/head') {
              // HEAD must not include a body; return 200 with empty body
              return http.Response('', 200, headers: {'x-test': 'true'});
            }
            break;
        }

        // Default: Not found
        return http.Response('Not Found', 404);
      });

      final client = EntraIdHttpClient(
        baseUrl: 'https://example.com',
        client: mock,
        defaultHeaders: {'x-default': '1'},
      );

      // GET
      final g = await client.get('/get');
      expect(g['ok'], isTrue);
      expect(g['method'], equals('GET'));

      // POST with body
      final p = await client.post('/post', body: {'name': 'osman'});
      expect(p['ok'], isTrue);
      expect(p['method'], equals('POST'));
      expect(p['body'], equals({'name': 'osman'}));

      // PUT
      final u = await client.put('/put', body: {'x': 1});
      expect(u['ok'], isTrue);
      expect(u['method'], equals('PUT'));

      // PATCH
      final pa = await client.patch('/patch', body: {'y': 2});
      expect(pa['ok'], isTrue);
      expect(pa['method'], equals('PATCH'));

      // DELETE
      final d = await client.delete('/delete');
      expect(d['ok'], isTrue);
      expect(d['method'], equals('DELETE'));

      // OPTIONS (expect empty map {} since 204/empty body)
      final o = await client.options('/options');
      expect(o, isA<Map<String, dynamic>>());
      expect(o.isEmpty, isTrue);

      // HEAD (expect empty map {})
      final h = await client.head('/head');
      expect(h, isA<Map<String, dynamic>>());
      expect(h.isEmpty, isTrue);
    });

    test('returns {"data": "..."} for non-JSON content-type', () async {
      final mock = http_testing.MockClient((req) async {
        return http.Response(
          'plain text',
          200,
          headers: {'content-type': 'text/plain'},
        );
      });

      final client = EntraIdHttpClient(
        baseUrl: 'https://example.com',
        client: mock,
      );
      final res = await client.get('/text');
      expect(res, contains('data'));
      expect(res['data'], equals('plain text'));
    });

    test('throws HttpException on non-2xx', () async {
      final mock = http_testing.MockClient((req) async {
        return http.Response(
          jsonEncode({'error': 'bad'}),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      final client = EntraIdHttpClient(
        baseUrl: 'https://example.com',
        client: mock,
      );

      expect(
        () => client.get('/bad'),
        throwsA(predicate((e) => e is HttpException && e.statusCode == 400)),
      );
    });

    test('empty body on 200 still returns {} (e.g., HEAD-like)', () async {
      final mock = http_testing.MockClient((req) async {
        return http.Response(
          '',
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final client = EntraIdHttpClient(
        baseUrl: 'https://example.com',
        client: mock,
      );
      final res = await client.get('/empty');
      expect(res.isEmpty, isTrue);
    });
  });
}
