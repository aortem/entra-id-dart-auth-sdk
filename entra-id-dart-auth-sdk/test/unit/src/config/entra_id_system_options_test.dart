import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('AortemEntraIdSystemOptions', () {
    test('should initialize and return the same instance', () {
      final options1 = AortemEntraIdSystemOptions.initialize(
        enableLogging: true,
        enableTelemetry: true,
        requestTimeoutInSeconds: 30,
        maxRetryAttempts: 3,
      );
      final options2 = AortemEntraIdSystemOptions.instance;

      expect(
        options1,
        equals(options2),
      ); // Ensure the same instance is returned
    });

    test('should reset and re-initialize the singleton', () {
      final options1 = AortemEntraIdSystemOptions.initialize(
        enableLogging: true,
        enableTelemetry: true,
        requestTimeoutInSeconds: 30,
        maxRetryAttempts: 3,
      );

      AortemEntraIdSystemOptions.reset();

      final options2 = AortemEntraIdSystemOptions.initialize(
        enableLogging: false,
        enableTelemetry: false,
        requestTimeoutInSeconds: 10,
        maxRetryAttempts: 1,
      );

      expect(
        options1,
        isNot(equals(options2)),
      ); // Ensure a new instance is created after reset
      expect(options2.enableLogging, equals(false));
      expect(options2.requestTimeoutInSeconds, equals(10));
      expect(options2.maxRetryAttempts, equals(1));
    });

    test(
      'should throw StateError if instance is accessed before initialization',
      () {
        AortemEntraIdSystemOptions.reset(); // Ensure it's uninitialized

        expect(
          () => AortemEntraIdSystemOptions.instance,
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              equals(
                'AortemEntraIdSystemOptions has not been initialized. Call initialize() first.',
              ),
            ),
          ),
        );
      },
    );
  });
}
