import 'dart:io';

/// AortemEntraIdNetworkUtils: Provides network utility methods for the SDK.
///
/// This class includes methods for connectivity checks, URL validation, and request retries.
class AortemEntraIdNetworkUtils {
  /// Checks if the device has an active internet connection.
  ///
  /// Returns `true` if the device is connected to the internet, otherwise `false`.
  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Validates the format of a given URL.
  ///
  /// Throws an [ArgumentError] if the URL is invalid.
  bool validateUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw ArgumentError('Invalid URL: $url');
    }
    return true;
  }

  /// Retries a network operation based on the given retry policy.
  ///
  /// [operation] is the network operation to retry.
  /// [retryCount] is the number of times to retry.
  /// [retryDelay] is the delay between retries in milliseconds.
  Future<T> retryRequest<T>(
    Future<T> Function() operation, {
    int retryCount = 3,
    int retryDelay = 1000,
  }) async {
    int attempt = 0;

    while (attempt < retryCount) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: retryDelay));
      }
    }
    throw Exception('Failed to complete the operation after $retryCount attempts');
  }
}
