import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('DefaultPartitionManager', () {
    late DefaultPartitionManager partitionManager;

    setUp(() {
      partitionManager = DefaultPartitionManager();
    });

    test('getPartitionKey should return a valid partition key', () {
      final tenantId = 'tenant123';
      final clientId = 'client456';
      final partitionKey = partitionManager.getPartitionKey(tenantId, clientId);

      expect(partitionKey, equals('$tenantId-$clientId'));
    });

    test(
      'getPartitionKey should throw ArgumentError if tenantId or clientId is empty',
      () {
        expect(
          () => partitionManager.getPartitionKey('', 'client456'),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Tenant ID and Client ID cannot be empty.',
            ),
          ),
        );

        expect(
          () => partitionManager.getPartitionKey('tenant123', ''),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Tenant ID and Client ID cannot be empty.',
            ),
          ),
        );
      },
    );

    test('clearPartition should return true for valid partitionKey', () async {
      final partitionKey = 'tenant123-client456';
      final result = await partitionManager.clearPartition(partitionKey);

      expect(result, isTrue);
    });

    test(
      'clearPartition should return false if partitionKey is empty',
      () async {
        final result = await partitionManager.clearPartition('');

        expect(result, isFalse);
      },
    );

    test(
      'validatePartitionStrategy should return true for valid partitionKey',
      () {
        final partitionKey = 'tenant123-client456';
        final result = partitionManager.validatePartitionStrategy(partitionKey);

        expect(result, isTrue);
      },
    );

    test(
      'validatePartitionStrategy should return false for invalid partitionKey',
      () {
        final partitionKey = 'invalidPartitionKey';
        final result = partitionManager.validatePartitionStrategy(partitionKey);

        expect(result, isFalse);
      },
    );
  });
}
