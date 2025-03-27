import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entra_id_default_partition_manager.dart';

void main() {
  group('DefaultPartitionManager', () {
    final partitionManager = DefaultPartitionManager();

    test('getPartitionKey should return a valid partition key', () {
      final key = partitionManager.getPartitionKey('tenant123', 'client456');
      expect(key, equals('tenant123-client456'));
    });

    test('getPartitionKey should throw for empty tenantId or clientId', () {
      expect(
        () => partitionManager.getPartitionKey('', 'client456'),
        throwsArgumentError,
      );
      expect(
        () => partitionManager.getPartitionKey('tenant123', ''),
        throwsArgumentError,
      );
    });

    test(
      'clearPartition should return true for valid partition keys',
      () async {
        final result = await partitionManager.clearPartition(
          'tenant123-client456',
        );
        expect(result, isTrue);
      },
    );

    test(
      'clearPartition should return false for empty partition key',
      () async {
        final result = await partitionManager.clearPartition('');
        expect(result, isFalse);
      },
    );

    test('validatePartitionStrategy should return true for valid keys', () {
      final isValid = partitionManager.validatePartitionStrategy(
        'tenant123-client456',
      );
      expect(isValid, isTrue);
    });

    test('validatePartitionStrategy should return false for invalid keys', () {
      final isValid = partitionManager.validatePartitionStrategy(
        'tenant123client456',
      );
      expect(isValid, isFalse);
    });
  });
}
