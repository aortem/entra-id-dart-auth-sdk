/// Status of the device code authentication flow
enum DeviceCodeStatus {
  /// Waiting for user to complete authentication
  pending,

  /// User has completed authentication
  completed,

  /// Authentication failed
  failed,

  /// User cancelled the authentication
  cancelled,

  /// The device code expired
  expired,
}
