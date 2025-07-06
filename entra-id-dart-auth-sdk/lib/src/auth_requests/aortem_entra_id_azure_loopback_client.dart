import 'dart:async';
import 'dart:io';
import 'package:entra_id_dart_auth_sdk/src/exception/aortem_entra_id_azure_loopback_client_exception.dart';
import 'package:entra_id_dart_auth_sdk/src/model/aortem_entra_id_azure_loopback_client_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

/// Handles local HTTP server for authentication redirects
class AortemEntraIdAzureLoopbackClient {
  final Logger _logger = Logger('AortemEntraIdAzureLoopbackClient');

  /// The port to listen on
  final int port;

  /// Path for the redirect endpoint
  final String path;

  /// Timeout duration for waiting for the redirect
  final Duration timeout;

  /// The HTTP server instance
  HttpServer? _server;

  /// Completer for the response
  Completer<LoopbackResponse>? _responseCompleter;

  /// Creates a new instance of AortemEntraIdAzureLoopbackClient
  AortemEntraIdAzureLoopbackClient({
    this.port = 0, // 0 means let the system choose an available port
    this.path = '/redirect',
    this.timeout = const Duration(minutes: 5),
  });

  /// Starts the loopback server
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

  /// Waits for and returns the redirect response
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

  /// Stops the loopback server
  Future<void> stop() async {
    if (_server != null) {
      await _server!.close();
      _server = null;
      _logger.info('Loopback server stopped');
    }
  }

  /// Listens for incoming connections
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

  /// Handles the redirect request
  Future<void> _handleRedirect(HttpRequest request) async {
    final response = LoopbackResponse(
      queryParameters: request.uri.queryParameters,
      rawRequest: request.uri.toString(),
    );

    // Send success response
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

    // Complete the response
    _responseCompleter?.complete(response);
  }

  /// Sends a 404 Not Found response
  Future<void> _sendNotFound(HttpRequest request) async {
    request.response.statusCode = HttpStatus.notFound;
    await request.response.close();
  }

  /// Sends an error response
  Future<void> _sendError(HttpRequest request) async {
    request.response.statusCode = HttpStatus.internalServerError;
    await request.response.close();
  }

  /// Gets the redirect URI for this loopback server
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
