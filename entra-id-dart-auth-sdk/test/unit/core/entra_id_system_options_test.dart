import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/entra_id_system_options.dart';

void main() {
  group('EntraIdSystemOptions Tests', () {
    setUp(() {
      // Reset options before each test
      EntraIdSystemOptions.reset();
    });

    test('Initialize with valid values', () {
      final options = EntraIdSystemOptions.initialize(
        enableLogging: true,
        enableTelemetry: false,
        requestTimeoutInSeconds: 60,
        maxRetryAttempts: 5,
      );

      expect(options.enableLogging, isTrue);
      expect(options.enableTelemetry, isFalse);
      expect(options.requestTimeoutInSeconds, equals(60));
      expect(options.maxRetryAttempts, equals(5));
    });

    test('Default values are applied', () {
      final options = EntraIdSystemOptions.initialize();

      expect(options.enableLogging, isFalse);
      expect(options.enableTelemetry, isTrue);
      expect(options.requestTimeoutInSeconds, equals(30));
      expect(options.maxRetryAttempts, equals(3));
    });

    test('Throws error if request timeout is zero or negative', () {
      expect(
        () => EntraIdSystemOptions.initialize(requestTimeoutInSeconds: 0),
        throwsArgumentError,
      );

      expect(
        () =>
            EntraIdSystemOptions.initialize(requestTimeoutInSeconds: -1),
        throwsArgumentError,
      );
    });

    test('Throws error if max retry attempts is negative', () {
      expect(
        () => EntraIdSystemOptions.initialize(maxRetryAttempts: -1),
        throwsArgumentError,
      );
    });

    test('Throws error if accessing instance before initialization', () {
      expect(() => EntraIdSystemOptions.instance, throwsStateError);
    });

    test('Reset allows reinitialization', () {
      EntraIdSystemOptions.initialize(enableLogging: true);
      expect(EntraIdSystemOptions.instance.enableLogging, isTrue);

      EntraIdSystemOptions.reset();

      expect(() => EntraIdSystemOptions.instance, throwsStateError);

      final options = EntraIdSystemOptions.initialize(
        enableLogging: false,
      );
      expect(options.enableLogging, isFalse);
    });
  });
}
