import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:entra_id_dart_auth_sdk/src/api_clients/entra_id_http_method.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_http_exception.dart';

/// {@template entra_id_http_client}
/// A robust HTTP client specialized for communicating with Microsoft Entra ID APIs.
///
/// This client handles all aspects of HTTP communication, including:
/// - Constructing requests with proper base URLs and headers.
/// - Serializing request bodies to JSON.
/// - Managing request timeouts.
/// - Parsing successful JSON responses.
/// - Converting non-successful HTTP responses into structured exceptions.
///
/// It provides convenient, typed methods for all standard HTTP verbs (GET, POST, PUT, etc.).
/// {@endtemplate}
class EntraIdHttpClient {
  /// The base URL for all API requests (e.g., `https://login.microsoftonline.com`).
  final String baseUrl;

  /// Default headers added to every outgoing request.
  ///
  /// Headers provided in individual request methods will override these defaults.
  final Map<String, String> defaultHeaders;

  /// The internal HTTP client used to perform the actual network requests.
  final http.Client httpClient;

  /// The maximum duration to wait for a response from the server.
  final Duration timeout;

  /// Creates a new instance of [ EntraIdHttpClient].
  ///
  /// {@macro entra_id_http_client}
  ///
  /// Parameters:
  ///   - [baseUrl]: The root URL for the Entra ID API.
  ///   - [defaultHeaders]: Optional default headers (e.g., default `User-Agent`).
  ///   - [client]: An optional custom HTTP client (useful for testing or custom configurations).
  ///               If `null`, a default `http.Client()` is created.
  ///   - [timeout]: The timeout duration for requests. Defaults to 30 seconds.
  EntraIdHttpClient({
    required this.baseUrl,
    this.defaultHeaders = const {},
    http.Client? client,
    Duration? timeout,
  }) : httpClient = client ?? http.Client(),
       timeout = timeout ?? const Duration(seconds: 30);

  // ---------------------- Public Convenience Methods ----------------------

  /// Performs an HTTP GET request.
  ///
  /// Used for retrieving resources from the specified endpoint.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` that completes with the parsed JSON
  ///   response body from the server.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions (e.g., `SocketException`).
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.get,
    endpoint: endpoint,
    headers: headers,
    queryParameters: queryParameters,
  );

  /// Performs an HTTP POST request.
  ///
  /// Used for creating new resources at the specified endpoint.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [body]: The optional request body, which will be JSON-encoded.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` that completes with the parsed JSON
  ///   response body from the server.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.post,
    endpoint: endpoint,
    headers: headers,
    body: body,
    queryParameters: queryParameters,
  );

  /// Performs an HTTP PUT request.
  ///
  /// Used for replacing a resource at the specified endpoint or creating it
  /// with a known identifier.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [body]: The optional request body, which will be JSON-encoded.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` that completes with the parsed JSON
  ///   response body from the server.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.put,
    endpoint: endpoint,
    headers: headers,
    body: body,
    queryParameters: queryParameters,
  );

  /// Performs an HTTP PATCH request.
  ///
  /// Used for performing a partial update on a resource at the specified endpoint.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [body]: The optional request body containing the partial update, which will be JSON-encoded.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` that completes with the parsed JSON
  ///   response body from the server.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions.
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.patch,
    endpoint: endpoint,
    headers: headers,
    body: body,
    queryParameters: queryParameters,
  );

  /// Performs an HTTP DELETE request.
  ///
  /// Used for deleting a resource at the specified endpoint.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [body]: An optional request body, which will be JSON-encoded.
  ///             Some APIs may require a body for a DELETE operation.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` that completes with the parsed JSON
  ///   response body from the server. Often an empty map for successful deletions.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions.
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.delete,
    endpoint: endpoint,
    headers: headers,
    body: body,
    queryParameters: queryParameters,
  );

  /// Performs an HTTP OPTIONS request.
  ///
  /// Used to describe the communication options for the target resource.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` that completes with the parsed JSON
  ///   response body from the server, if any.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions.
  Future<Map<String, dynamic>> options(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.options,
    endpoint: endpoint,
    headers: headers,
    queryParameters: queryParameters,
  );

  /// Performs an HTTP HEAD request.
  ///
  /// Identical to a GET request but asks the server to return only the headers,
  /// not the response body. Useful for checking resource existence or metadata.
  ///
  /// Parameters:
  ///   - [endpoint]: The path of the API resource, appended to the [baseUrl].
  ///   - [headers]: Optional headers specific to this request.
  ///   - [queryParameters]: Optional query parameters to append to the URL.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` which is always an empty map, as HEAD
  ///   requests by definition have no response body.
  ///
  /// Throws:
  ///   - [ HttpException] if the HTTP response status code is not 2xx.
  ///   - [TimeoutException] if the request exceeds the specified [timeout].
  ///   - Other network-related exceptions.
  Future<Map<String, dynamic>> head(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) => _sendRequest(
    method: EntraIdHttpMethod.head,
    endpoint: endpoint,
    headers: headers,
    queryParameters: queryParameters,
  );

  // ---------------------- Core Private Logic ----------------------

  /// Internal method that orchestrates the sending of an HTTP request.
  ///
  /// This method constructs the URI, merges headers, encodes the body,
  /// delegates to the specific HTTP method implementation, handles timeouts,
  /// and processes the response.
  ///
  /// Parameters:
  ///   - [method]: The HTTP method to use for the request.
  ///   - [endpoint]: The API endpoint path.
  ///   - [headers]: Optional request-specific headers.
  ///   - [body]: Optional request body data.
  ///   - [queryParameters]: Optional query parameters.
  ///
  /// Returns:
  ///   A `Future<Map<String, dynamic>>` with the parsed response.
  ///
  /// Throws:
  ///   - [ HttpException] for HTTP errors.
  ///   - [TimeoutException] on timeout.
  ///   - Other exceptions for network failures.
  Future<Map<String, dynamic>> _sendRequest({
    required EntraIdHttpMethod method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    final combinedHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...defaultHeaders,
      if (headers != null) ...headers,
    };

    String? encodedBody;
    final allowsBody = switch (method) {
      EntraIdHttpMethod.post ||
      EntraIdHttpMethod.put ||
      EntraIdHttpMethod.patch ||
      EntraIdHttpMethod.delete => true,
      _ => false,
    };
    if (allowsBody && body != null) {
      encodedBody = jsonEncode(body);
    }

    late http.Response response;

    try {
      switch (method) {
        case EntraIdHttpMethod.get:
          response = await httpClient
              .get(uri, headers: combinedHeaders)
              .timeout(timeout);
          break;
        case EntraIdHttpMethod.post:
          response = await httpClient
              .post(uri, headers: combinedHeaders, body: encodedBody)
              .timeout(timeout);
          break;
        case EntraIdHttpMethod.put:
          response = await httpClient
              .put(uri, headers: combinedHeaders, body: encodedBody)
              .timeout(timeout);
          break;
        case EntraIdHttpMethod.delete:
          response = await httpClient
              .delete(uri, headers: combinedHeaders, body: encodedBody)
              .timeout(timeout);
          break;
        case EntraIdHttpMethod.patch:
          response = await httpClient
              .patch(uri, headers: combinedHeaders, body: encodedBody)
              .timeout(timeout);
          break;
        case EntraIdHttpMethod.options:
          response = await _sendRaw(
            method: 'OPTIONS',
            uri: uri,
            headers: combinedHeaders,
          );
          break;
        case EntraIdHttpMethod.head:
          response = await _sendRaw(
            method: 'HEAD',
            uri: uri,
            headers: combinedHeaders,
          );
          break;
      }

      return _handleResponse(uri, response);
    } catch (e) {
      // Network errors / unreachable server
      throw HttpException(
        statusCode: -1,
        message: 'Network error: $e',
        uri: uri,
        headers: combinedHeaders,
      );
    }
  }

  /// Constructs a complete [Uri] from the base URL, endpoint, and query parameters.
  ///
  /// Parameters:
  ///   - [endpoint]: The API endpoint path.
  ///   - [query]: A map of query parameters.
  ///
  /// Returns:
  ///   A fully constructed [Uri] object.
  Uri _buildUri(String endpoint, Map<String, dynamic>? query) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (query == null || query.isEmpty) return uri;

    final qp = {
      ...uri.queryParameters,
      for (final e in query.entries) e.key: e.value?.toString() ?? '',
    };
    return uri.replace(queryParameters: qp);
  }

  /// Sends a raw HTTP request for methods not directly supported by the `http` package's convenience methods.
  ///
  /// This is used for OPTIONS and HEAD requests.
  ///
  /// Parameters:
  ///   - [method]: The HTTP method as a string.
  ///   - [uri]: The target URI.
  ///   - [headers]: The headers to send.
  ///   - [body]: The optional request body.
  ///
  /// Returns:
  ///   A `Future<http.Response>` containing the server's response.
  Future<http.Response> _sendRaw({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    String? body,
  }) async {
    final req = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) req.body = body;
    final streamed = await httpClient.send(req).timeout(timeout);
    return http.Response.fromStream(streamed);
  }

  /// Processes the HTTP response, handling success and error cases.
  ///
  /// - For successful responses (2xx status codes), it parses the JSON response body.
  /// - For responses without a body (e.g., 204 No Content, HEAD requests), it returns an empty map.
  /// - For error responses (non-2xx status codes), it throws an [ HttpException].
  ///
  /// Parameters:
  ///   - [uri]: The original URI that was requested.
  ///   - [response]: The response received from the server.
  ///
  /// Returns:
  ///   A `Map<String, dynamic>` containing the parsed response data.
  ///
  /// Throws:
  ///   - [ HttpException] if the response status code indicates an error.
  Map<String, dynamic> _handleResponse(Uri uri, http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      // Handle responses that are defined to have no content body
      if (status == 204 || // No Content
          status == 205 || // Reset Content
          status == 304 || // Not Modified
          response.request?.method == 'HEAD' ||
          response.body.isEmpty) {
        return <String, dynamic>{};
      }

      final contentType = response.headers['content-type'] ?? '';
      // Attempt to parse JSON if the content-type suggests it
      if (contentType.contains('application/json')) {
        try {
          final decoded = jsonDecode(response.body);
          // If the root is not a Map (e.g., a List), wrap it for consistency
          return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
        } catch (_) {
          // If JSON parsing fails, return the raw body as a string under a 'data' key
          return {'data': response.body};
        }
      }
      // For non-JSON responses, return the raw body under a 'data' key
      return {'data': response.body};
    }

    // For any non-2xx status code, throw a structured exception
    throw HttpException(
      statusCode: status,
      message: 'HTTP $status',
      uri: uri,
      headers: response.headers,
      responseBody: response.body,
    );
  }
}
