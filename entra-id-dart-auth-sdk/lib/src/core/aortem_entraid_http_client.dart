import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// AortemEntraIdHttpClient: A lightweight HTTP client for making REST API requests.
///
/// This class simplifies HTTP communication by providing easy-to-use methods
/// for common HTTP operations such as GET, POST, PUT, and DELETE. It also supports
/// custom headers and request body handling.
///
/// Features:
/// - Base URL support for consistent endpoint construction.
/// - Customizable headers for authentication or other purposes.
/// - Automatic response handling with error checking.
class AortemEntraIdHttpClient {
  /// The base URL for the API. All requests will be made relative to this URL.
  final String baseUrl;

  /// Default headers to include in all HTTP requests.
  final Map<String, String> defaultHeaders;

  /// The underlying HTTP client used to send requests.
  final http.Client httpClient;

  /// Constructor for `AortemEntraIdHttpClient`.
  ///
  /// - [baseUrl]: The base URL for API requests.
  /// - [defaultHeaders]: Optional default headers to include in all requests.
  /// - [client]: An optional custom HTTP client instance.
  AortemEntraIdHttpClient({
    required this.baseUrl,
    this.defaultHeaders = const {},
    http.Client? client,
  }) : httpClient = client ?? http.Client();

  /// Sends a GET request to the specified endpoint.
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(method: 'GET', endpoint: endpoint, headers: headers);
  }

  /// Sends a POST request to the specified endpoint.
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

  /// Sends a PUT request to the specified endpoint.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest(
      method: 'PUT',
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
  }

  /// Sends a DELETE request to the specified endpoint.
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(method: 'DELETE', endpoint: endpoint, headers: headers);
  }

  /// Sends an HTTP request based on the specified method, endpoint, and parameters.
  Future<Map<String, dynamic>> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final combinedHeaders = {
      ...defaultHeaders,
      if (headers != null) ...headers,
      'Content-Type': 'application/json',
    };
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
        case 'PUT':
          response = await httpClient.put(
            uri,
            headers: combinedHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await httpClient.delete(uri, headers: combinedHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Handles the HTTP response and parses it as JSON.
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'HTTP Error: ${response.statusCode}, body: ${response.body}',
      );
    }
  }
}
