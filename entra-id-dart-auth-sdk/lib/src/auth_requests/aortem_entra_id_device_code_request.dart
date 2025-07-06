import 'dart:async';
import 'package:entra_id_dart_auth_sdk/src/enum/aortem_entra_id_device_code_request_enum.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/aortem_entra_id_device_code_request_exception.dart';
import 'package:entra_id_dart_auth_sdk/src/model/aortem_entra_id_device_code_request_model.dart';
import 'package:entra_id_dart_auth_sdk/src/model/aortem_entra_id_device_code_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

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
  final statusController = StreamController<DeviceCodeStatus>.broadcast();

  /// Current device code response
  DeviceCodeResponse? deviceCodeResponse;

  /// Polling timer
  Timer? pollingTimer;

  /// Creates a new instance of AortemEntraIdDeviceCodeRequest
  AortemEntraIdDeviceCodeRequest({
    required this.deviceCodeEndpoint,
    required this.tokenEndpoint,
    required this.parameters,
  }) {
    validateParameters();
  }

  /// Stream of device code status updates
  Stream<DeviceCodeStatus> get statusChanges => statusController.stream;

  /// Validates the request parameters
  void validateParameters() {
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
    if (deviceCodeResponse == null) {
      throw DeviceCodeException(
        'No device code response available',
        code: 'missing_device_code',
      );
    }

    final body = {
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
      'device_code': deviceCodeResponse!.deviceCode,
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
      deviceCodeResponse = DeviceCodeResponse.fromJson(response);
      _logger.info(
        'Device code received. Verification URL: ${deviceCodeResponse!.verificationUrl}',
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
    if (deviceCodeResponse == null) {
      throw DeviceCodeException(
        'Cannot start polling without device code',
        code: 'no_device_code',
      );
    }

    final expiresAt = DateTime.now().add(
      Duration(seconds: deviceCodeResponse!.expiresInSeconds),
    );

    pollingTimer = Timer.periodic(
      Duration(seconds: deviceCodeResponse!.pollingIntervalSeconds),
      (timer) async {
        if (DateTime.now().isAfter(expiresAt)) {
          timer.cancel();
          statusController.add(DeviceCodeStatus.expired);
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
            statusController.add(DeviceCodeStatus.pending);
          } else {
            timer.cancel();
            statusController.add(DeviceCodeStatus.failed);
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
    pollingTimer?.cancel();
    statusController.add(DeviceCodeStatus.cancelled);
    _logger.info('Device code flow cancelled');
  }

  /// Disposes of resources
  void dispose() {
    pollingTimer?.cancel();
    statusController.close();
    _logger.info('Device code request disposed');
  }
}
