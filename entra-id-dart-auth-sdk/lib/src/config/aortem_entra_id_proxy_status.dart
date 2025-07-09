import 'dart:convert'; // Provides utilities for encoding and decoding data, such as Base64.
import 'package:ds_standard_features/ds_standard_features.dart'
    as http; // Imports the HTTP client library.

/// AortemEntraIdProxyStatus: Manages and monitors proxy configurations for the SDK.
///
/// Handles settings for proxy URLs, authentication, and status checking to ensure seamless network connectivity.
class AortemEntraIdProxyStatus {
  /// The proxy server's URL or IP address.
  final String proxyUrl;

  /// The port number for the proxy server.
  final int port;

  /// The username for proxy authentication (optional).
  final String? username;

  /// The password for proxy authentication (optional).
  final String? password;

  /// Constructor to initialize the proxy settings.
  ///
  /// Requires [proxyUrl] and [port] as mandatory parameters. [username] and [password] are optional.
  AortemEntraIdProxyStatus({
    required this.proxyUrl, // Initializes the proxy URL.
    required this.port, // Initializes the port number.
    this.username, // Initializes the optional username for proxy authentication.
    this.password, // Initializes the optional password for proxy authentication.
  });

  /// Validate the proxy configuration by attempting a simple network request.
  ///
  /// Returns true if the proxy configuration is valid and reachable, false otherwise.
  Future<bool> validateProxy() async {
    try {
      // Constructs the proxy URI from the provided URL and port.
      final proxyUri = Uri.parse('http://$proxyUrl:$port');

      // Creates an HTTP client for sending the request.
      final client = http.Client();

      // Creates an HTTP GET request to the proxy URI.
      final proxyRequest = http.Request('GET', proxyUri)
        ..headers.addAll({
          // Adds the Proxy-Authorization header if username and password are provided.
          'Proxy-Authorization':
              username != null && password != null
                  ? 'Basic ${base64Encode(utf8.encode('$username:$password'))}' // Encodes credentials in Base64 format.
                  : '',
        });

      // Sends the proxy request and waits for the response.
      final response = await client.send(proxyRequest);

      // Retrieves the status code from the response.
      final statusCode = response.statusCode;

      // Returns true if the status code indicates success (200).
      if (statusCode == 200) {
        return true;
      } else {
        // Throws an exception if the response status code is not 200.
        throw Exception('Failed to connect to proxy. Status code: $statusCode');
      }
    } catch (e) {
      // Throws an exception if any error occurs during the proxy validation process.
      throw Exception('Proxy validation failed: $e');
    }
  }

  /// Applies proxy settings for network requests.
  ///
  /// You can configure this method to make network requests using the proxy settings.
  Future<void> applyProxySettings() async {
    // This method can be enhanced to set proxy configurations globally for SDK
    // network requests or HttpClient configurations.
  }
}
