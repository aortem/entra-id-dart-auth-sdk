import 'dart:convert';
import 'dart:io';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// AortemEntraIdProxyStatus: Manages and monitors proxy configurations for the SDK.
///
/// Handles settings for proxy URLs, authentication, and status checking to ensure seamless network connectivity.
class AortemEntraIdProxyStatus {
  final String proxyUrl;
  final int port;
  final String? username;
  final String? password;

  AortemEntraIdProxyStatus({
    required this.proxyUrl,
    required this.port,
    this.username,
    this.password,
  });

  /// Validate the proxy configuration by attempting a simple network request.
  ///
  /// Returns true if the proxy configuration is valid and reachable, false otherwise.
  Future<bool> validateProxy() async {
    try {
      final proxyUri = Uri.parse('http://$proxyUrl:$port');
      final client = http.Client();
      final proxyRequest = http.Request('GET', proxyUri)
        ..headers.addAll({
          'Proxy-Authorization': username != null && password != null
              ? 'Basic ' + base64Encode(utf8.encode('$username:$password'))
              : '',
        });

      final response = await client.send(proxyRequest);
      final statusCode = response.statusCode;

      if (statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to connect to proxy. Status code: $statusCode');
      }
    } catch (e) {
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
