import 'dart:async';
import 'package:logging/logging.dart';

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

/// Parameters for device code flow requests
class DeviceCodeRequestParameters {
  /// The client ID of the application
  final String clientId;

  /// The scopes to request
  final List<String> scopes;

  /// Optional client secret for confidential clients
  final String? clientSecret;

  /// Optional correlation ID for request tracing
  final String? correlationId;

  /// Creates a new instance of DeviceCodeRequestParameters
  DeviceCodeRequestParameters({
    required this.clientId,
    required this.scopes,
    this.clientSecret,
    this.correlationId,
  });
}

/// Exception thrown for device code flow errors
/// Exception thrown for errors related to the device code flow.
/// This exception is used when there are issues in obtaining or validating the device code.
class DeviceCodeException implements Exception {
  /// The error message describing the issue.
  final String message;

  /// An optional error code to categorize the type of error.
  final String? code;

  /// Additional details about the error, such as debug information or stack trace.
  final dynamic details;

  /// Creates a new instance of [DeviceCodeException].
  ///
  /// - [message]: A required description of the error.
  /// - [code]: An optional identifier for the error type.
  /// - [details]: Optional extra details related to the error, such as a stack trace.
  DeviceCodeException(this.message, {this.code, this.details});

  /// Returns a string representation of the exception, including the error message and optional code.
  @override
  String toString() => 'DeviceCodeException: $message (Code: $code)';
}

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

/// Handles device code authentication flow
class AortemEntraIdDeviceCodeRequest {
  final Logger _logger = Logger('AortemEntraIdDeviceCodeRequest');

  /// The device code endpoint URL
  final String deviceCodeEndpoint;

  /// The token endpoint URL
  final String tokenEndpoint;

  /// Parameters for the device code request
  final DeviceCodeRequestParameters parameters;

  /// Stream controller for status updates
  final _statusController = StreamController<DeviceCodeStatus>.broadcast();

  /// Current device code response
  DeviceCodeResponse? _deviceCodeResponse;

  /// Polling timer
  Timer? _pollingTimer;

  /// Creates a new instance of AortemEntraIdDeviceCodeRequest
  AortemEntraIdDeviceCodeRequest({
    required this.deviceCodeEndpoint,
    required this.tokenEndpoint,
    required this.parameters,
  }) {
    _validateParameters();
  }

  /// Stream of device code status updates
  Stream<DeviceCodeStatus> get statusChanges => _statusController.stream;

  /// Validates the request parameters
  void _validateParameters() {
    if (parameters.clientId.isEmpty) {
      throw DeviceCodeException(
        'Client ID cannot be empty',
        code: 'empty_client_id',
      );
    }
    if (parameters.scopes.isEmpty) {
      throw DeviceCodeException(
        'At least one scope must be specified',
        code: 'empty_scopes',
      );
    }
  }

  /// Gets the request body for device code request
  Map<String, String> getDeviceCodeRequestBody() {
    return {
      'client_id': parameters.clientId,
      'scope': parameters.scopes.join(' '),
    };
  }

  /// Gets the request body for token request
  Map<String, String> getTokenRequestBody() {
    if (_deviceCodeResponse == null) {
      throw DeviceCodeException(
        'No device code response available',
        code: 'missing_device_code',
      );
    }

    final body = {
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
      'device_code': _deviceCodeResponse!.deviceCode,
      'client_id': parameters.clientId,
    };

    if (parameters.clientSecret != null) {
      body['client_secret'] = parameters.clientSecret!;
    }

    return body;
  }

  /// Gets headers for requests
  Map<String, String> getHeaders() {
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    if (parameters.correlationId != null) {
      headers['client-request-id'] = parameters.correlationId!;
    }

    return headers;
  }

  /// Handles a device code response
  void handleDeviceCodeResponse(Map<String, dynamic> response) {
    try {
      _deviceCodeResponse = DeviceCodeResponse.fromJson(response);
      _logger.info(
        'Device code received. Verification URL: ${_deviceCodeResponse!.verificationUrl}',
      );
    } catch (e) {
      throw DeviceCodeException(
        'Failed to parse device code response',
        code: 'invalid_response',
        details: e,
      );
    }
  }

  /// Starts polling for token
  void startPolling(Function(Map<String, dynamic>) onToken) {
    if (_deviceCodeResponse == null) {
      throw DeviceCodeException(
        'Cannot start polling without device code',
        code: 'no_device_code',
      );
    }

    final expiresAt = DateTime.now().add(
      Duration(seconds: _deviceCodeResponse!.expiresInSeconds),
    );

    _pollingTimer = Timer.periodic(
      Duration(seconds: _deviceCodeResponse!.pollingIntervalSeconds),
      (timer) async {
        if (DateTime.now().isAfter(expiresAt)) {
          timer.cancel();
          _statusController.add(DeviceCodeStatus.expired);
          return;
        }

        // Simulated token check - replace with actual API call
        try {
          // Implement token request here
          // If successful:
          // onToken(tokenResponse);
          // _statusController.add(DeviceCodeStatus.completed);
          // timer.cancel();
        } catch (e) {
          if (_isPendingError(e)) {
            _statusController.add(DeviceCodeStatus.pending);
          } else {
            timer.cancel();
            _statusController.add(DeviceCodeStatus.failed);
            rethrow;
          }
        }
      },
    );
  }

  /// Checks if an error indicates pending authentication
  bool _isPendingError(dynamic error) {
    // Add logic to check for "authorization_pending" error
    return false;
  }

  /// Cancels the authentication flow
  void cancel() {
    _pollingTimer?.cancel();
    _statusController.add(DeviceCodeStatus.cancelled);
    _logger.info('Device code flow cancelled');
  }

  /// Disposes of resources
  void dispose() {
    _pollingTimer?.cancel();
    _statusController.close();
    _logger.info('Device code request disposed');
  }
}
