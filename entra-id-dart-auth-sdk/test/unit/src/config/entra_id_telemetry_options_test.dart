import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('EntraIdTelemetryOptions', () {
    test('should initialize with valid parameters', () {
      final options = EntraIdTelemetryOptions(
        enableTelemetry: true,
        telemetryEndpoint: 'https://telemetry.endpoint',
      );

      expect(options.enableTelemetry, isTrue);
      expect(options.telemetryEndpoint, equals('https://telemetry.endpoint'));
      expect(options.retryAttempts, equals(3)); // Default retry attempts
    });

    test(
      'should throw ArgumentError if telemetry is enabled but no endpoint is provided',
      () {
        expect(
          () => EntraIdTelemetryOptions(
            enableTelemetry: true,
            telemetryEndpoint: '',
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              equals(
                'Telemetry is enabled, but no telemetry endpoint is provided.',
              ),
            ),
          ),
        );
      },
    );

    test('should throw ArgumentError if retryAttempts is negative', () {
      expect(
        () => EntraIdTelemetryOptions(
          enableTelemetry: true,
          telemetryEndpoint: 'https://telemetry.endpoint',
          retryAttempts: -1,
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            equals('Retry attempts cannot be negative.'),
          ),
        ),
      );
    });

    test('should use default retryAttempts if not provided', () {
      final options = EntraIdTelemetryOptions(
        enableTelemetry: true,
        telemetryEndpoint: 'https://telemetry.endpoint',
      );

      expect(options.retryAttempts, equals(3)); // Default value should be 3
    });
  });
}
