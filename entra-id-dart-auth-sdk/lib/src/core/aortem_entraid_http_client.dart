import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;



class AortemEntraIdHttpClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final http.Client httpClient;

  AortemEntraIdHttpClient({
    required this.baseUrl,
    this.defaultHeaders = const {},
    http.Client? client,
  }) : httpClient = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  Future<Map<String, dynamic>> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final combinedHeaders = {...defaultHeaders, if (headers != null) ...headers};
    late http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await httpClient.get(uri, headers: combinedHeaders);
          break;
        case 'POST':
          response = await httpClient.post(
            uri,
            headers: combinedHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'HTTP Error: ${response.statusCode}, body: ${response.body}');
    }
  }
}
