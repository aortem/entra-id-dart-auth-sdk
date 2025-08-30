import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Represents a request to refresh an OAuth token using a refresh token.
///
/// This class handles the process of sending a request to the token endpoint
/// to obtain a new access token using a previously obtained refresh token.
class EntraIdRefreshTokenRequest {
  /// The refresh token used to request a new access token.
  final String refreshToken;

  /// The client ID of the application making the request.
  final String clientId;

  /// The client secret of the application making the request.
  final String clientSecret;

  /// The URL of the token endpoint where the request will be sent.
  final String tokenEndpoint;

  /// Constructs a new [EntraIdRefreshTokenRequest] with the given [refreshToken],
  /// [clientId], [clientSecret], and [tokenEndpoint].
  EntraIdRefreshTokenRequest({
    required this.refreshToken,
    required this.clientId,
    required this.clientSecret,
    required this.tokenEndpoint,
  });

  /// Initiates the token refresh process by sending a POST request to the token endpoint.
  ///
  /// Sends the refresh token, client ID, and client secret in the body of the request.
  /// If the request is successful, the response body is decoded and returned as a map.
  /// If the request fails, an exception is thrown.
  ///
  /// Returns a [Map<String, dynamic>] containing the refreshed token data.
  /// Throws an [Exception] if the refresh token request fails.
  Future<Map<String, dynamic>> refresh() async {
    final response = await http.post(
      Uri.parse(tokenEndpoint),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception(
        'Failed to refresh token: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
