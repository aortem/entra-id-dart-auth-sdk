/// Represents a device code response from the authorization endpoint
class DeviceCodeResponse {
  /// The device code for verification
  final String deviceCode;

  /// The user code to be entered on another device
  final String userCode;

  /// The verification URL where the user should enter the code
  final String verificationUrl;

  /// The polling interval in seconds
  final int pollingIntervalSeconds;

  /// The expiration time in seconds
  final int expiresInSeconds;

  /// Creates a new instance of DeviceCodeResponse
  DeviceCodeResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUrl,
    required this.pollingIntervalSeconds,
    required this.expiresInSeconds,
  });

  /// Creates a DeviceCodeResponse from JSON
  factory DeviceCodeResponse.fromJson(Map<String, dynamic> json) {
    return DeviceCodeResponse(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUrl: json['verification_uri'] as String,
      pollingIntervalSeconds: json['interval'] as int? ?? 5,
      expiresInSeconds: json['expires_in'] as int,
    );
  }
}
