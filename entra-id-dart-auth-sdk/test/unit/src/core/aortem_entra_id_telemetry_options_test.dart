
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entra_id_telemetry_options.dart';

void main() {
  group('AortemEntraIdTelemetryOptions', () {
    test('should initialize with valid parameters', () {
      final options = AortemEntraIdTelemetryOptions(
        enableTelemetry: true,
        telemetryEndpoint: 'https://telemetry.example.com',
        retryAttempts: 3,
      );

      expect(options.enableTelemetry, true);
      expect(options.telemetryEndpoint, 'https://telemetry.example.com');
      expect(options.retryAttempts, 3);
    });

    test('should throw error if telemetry is enabled but endpoint is empty', () {
      expect(
        () => AortemEntraIdTelemetryOptions(
          enableTelemetry: true,
          telemetryEndpoint: '',
        ),
        throwsArgumentError,
      );
    });

    test('should throw error for negative retry attempts', () {
      expect(
        () => AortemEntraIdTelemetryOptions(
          enableTelemetry: true,
          telemetryEndpoint: 'https://telemetry.example.com',
          retryAttempts: -1,
        ),
        throwsArgumentError,
      );
    });

    test('should initialize with default retry attempts', () {
      final options = AortemEntraIdTelemetryOptions(
        enableTelemetry: true,
        telemetryEndpoint: 'https://telemetry.example.com',
      );

      expect(options.retryAttempts, 3); // Default value
    });
  });
}
