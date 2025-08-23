/// Response from the loopback server
class LoopbackResponse {
  /// Query parameters from the redirect URI
  final Map<String, String> queryParameters;

  /// Raw request data
  final String rawRequest;

  /// Timestamp of the response
  final DateTime timestamp;

  ///constructure
  LoopbackResponse({
    required this.queryParameters,
    required this.rawRequest,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
