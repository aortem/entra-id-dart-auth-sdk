import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';

/// Exception thrown for loopback client operations.
///
/// This is used to handle errors occurring within the loopback client,
/// particularly during the handling of local HTTP server operations.
class LoopbackClientException implements Exception {
  /// Error message describing the exception.
  final String message;

  /// Optional error code providing additional context.
  final String? code;

  /// Additional details about the error, if available.
  final dynamic details;

  /// Creates a new [LoopbackClientException] with a message and optional details.
  LoopbackClientException(this.message, {this.code, this.details});

  @override
  String toString() => 'LoopbackClientException: $message (Code: $code)';
}

/// Represents a response from the loopback server.
///
/// This is used to capture authentication responses from the redirect URI.
class LoopbackResponse {
  /// Query parameters extracted from the redirect URI.
  final Map<String, String> queryParameters;

  /// The raw request URI string received from the client.
  final String rawRequest;

  /// Timestamp indicating when the response was received.
  final DateTime timestamp;

  /// Creates a [LoopbackResponse] instance.
  ///
  /// - [queryParameters]: The extracted query parameters from the redirect URI.
  /// - [rawRequest]: The raw request string received.
  /// - [timestamp]: Optional timestamp (defaults to the current time).
  LoopbackResponse({
    required this.queryParameters,
    required this.rawRequest,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Handles a local HTTP server for authentication redirects.
///
/// This server listens on a loopback address and captures authentication
/// responses sent to the redirect URI.
class AortemEntraIdAzureLoopbackClient {
  final Logger _logger = Logger('AortemEntraIdAzureLoopbackClient');

  /// The port the server will listen on (0 means auto-assign).
  final int port;

  /// The redirect endpoint path for authentication.
  final String path;

  /// Timeout duration for waiting for authentication responses.
  final Duration timeout;

  /// The internal HTTP server instance.
  HttpServer? _server;

  /// Completer used to capture the response asynchronously.
  Completer<LoopbackResponse>? _responseCompleter;

  /// Creates an instance of [AortemEntraIdAzureLoopbackClient].
  ///
  /// - [port]: The port for the local HTTP server (0 to auto-assign).
  /// - [path]: The path used for authentication redirection.
  /// - [timeout]: The maximum duration to wait for a response.
  AortemEntraIdAzureLoopbackClient({
    this.port = 0, // System assigns an available port.
    this.path = '/redirect',
    this.timeout = const Duration(minutes: 5),
  });

  /// Starts the loopback server and returns the assigned port.
  ///
  /// This binds an HTTP server to `127.0.0.1` (loopback address) and begins
  /// listening for incoming authentication requests.
  ///
  /// Throws [LoopbackClientException] if the server fails to start.
  Future<int> start() async {
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      _logger.info('Loopback server started on port ${_server!.port}');

      _listenForConnections();
      return _server!.port;
    } catch (e) {
      _logger.severe('Failed to start loopback server', e);
      throw LoopbackClientException(
        'Failed to start loopback server',
        code: 'start_failed',
        details: e,
      );
    }
  }

  /// Waits for an authentication response from the redirect URI.
  ///
  /// This method blocks until a valid response is received or the timeout is reached.
  ///
  /// Throws [LoopbackClientException] if the server is not started or times out.
  Future<LoopbackResponse> waitForResponse() async {
    if (_server == null) {
      throw LoopbackClientException(
        'Server not started',
        code: 'server_not_started',
      );
    }

    _responseCompleter = Completer<LoopbackResponse>();

    try {
      return await _responseCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          throw LoopbackClientException(
            'Timeout waiting for redirect',
            code: 'timeout',
          );
        },
      );
    } finally {
      await stop();
    }
  }

  /// Stops the loopback server.
  ///
  /// Closes the HTTP server if it is running.
  Future<void> stop() async {
    if (_server != null) {
      await _server!.close();
      _server = null;
      _logger.info('Loopback server stopped');
    }
  }

  /// Listens for incoming connections and handles authentication redirects.
  void _listenForConnections() {
    _server!.listen(
      (HttpRequest request) async {
        try {
          if (request.method == 'GET' && request.uri.path == path) {
            await _handleRedirect(request);
          } else {
            await _sendNotFound(request);
          }
        } catch (e) {
          _logger.severe('Error handling request', e);
          await _sendError(request);
        }
      },
      onError: (error) {
        _logger.severe('Server error', error);
        _responseCompleter?.completeError(
          LoopbackClientException(
            'Server error',
            code: 'server_error',
            details: error,
          ),
        );
      },
    );
  }

  /// Handles incoming authentication redirect requests.
  ///
  /// Extracts query parameters from the request and sends a response
  /// indicating that authentication is complete.
  Future<void> _handleRedirect(HttpRequest request) async {
    final response = LoopbackResponse(
      queryParameters: request.uri.queryParameters,
      rawRequest: request.uri.toString(),
    );

    // Send success response to the user.
    request.response.statusCode = HttpStatus.ok;
    request.response.headers.contentType = ContentType.html;
    request.response.write('''
      <!DOCTYPE html>
      <html>
        <body>
          <h1>Authentication Complete</h1>
          <p>You can close this window and return to the application.</p>
          <script>window.close();</script>
        </body>
      </html>
    ''');
    await request.response.close();

    // Complete the response future.
    _responseCompleter?.complete(response);
  }

  /// Sends a 404 Not Found response.
  ///
  /// This is used when an unknown request is received.
  Future<void> _sendNotFound(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;
    await request.response.close();
  }

  /// Sends a 500 Internal Server Error response.
  ///
  /// This is used when an unexpected error occurs.
  Future<void> _sendError(HttpRequest request) async {
    request.response.statusCode = HttpStatus.internalServerError;
    await request.response.close();
  }

  /// Returns the redirect URI for this loopback server.
  ///
  /// This URI should be registered as an allowed redirect URI in
  /// the authentication provider's configuration.
  ///
  /// Throws [LoopbackClientException] if the server is not started.
  String getRedirectUri() {
    if (_server == null) {
      throw LoopbackClientException(
        'Server not started',
        code: 'server_not_started',
      );
    }
    return 'http://localhost:${_server!.port}$path';
  }
}
