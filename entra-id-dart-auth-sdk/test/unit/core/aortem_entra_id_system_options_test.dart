import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entra_id_system_options.dart';

void main() {
  group('AortemEntraIdSystemOptions Tests', () {
    setUp(() {
      // Reset options before each test
      AortemEntraIdSystemOptions.reset();
    });

    test('Initialize with valid values', () {
      final options = AortemEntraIdSystemOptions.initialize(
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
      final options = AortemEntraIdSystemOptions.initialize();

      expect(options.enableLogging, isFalse);
      expect(options.enableTelemetry, isTrue);
      expect(options.requestTimeoutInSeconds, equals(30));
      expect(options.maxRetryAttempts, equals(3));
    });

    test('Throws error if request timeout is zero or negative', () {
      expect(
        () => AortemEntraIdSystemOptions.initialize(requestTimeoutInSeconds: 0),
        throwsArgumentError,
      );

      expect(
        () =>
            AortemEntraIdSystemOptions.initialize(requestTimeoutInSeconds: -1),
        throwsArgumentError,
      );
    });

    test('Throws error if max retry attempts is negative', () {
      expect(
        () => AortemEntraIdSystemOptions.initialize(maxRetryAttempts: -1),
        throwsArgumentError,
      );
    });

    test('Throws error if accessing instance before initialization', () {
      expect(() => AortemEntraIdSystemOptions.instance, throwsStateError);
    });

    test('Reset allows reinitialization', () {
      AortemEntraIdSystemOptions.initialize(enableLogging: true);
      expect(AortemEntraIdSystemOptions.instance.enableLogging, isTrue);

      AortemEntraIdSystemOptions.reset();

      expect(() => AortemEntraIdSystemOptions.instance, throwsStateError);

      final options = AortemEntraIdSystemOptions.initialize(
        enableLogging: false,
      );
      expect(options.enableLogging, isFalse);
    });
  });
}
