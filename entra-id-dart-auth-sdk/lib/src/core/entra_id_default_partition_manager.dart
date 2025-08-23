import 'entra_id_i_partition_manager.dart';

/// Default implementation of AortemEntraIdIPartitionManager.
class DefaultPartitionManager implements AortemEntraIdIPartitionManager {
  /// Gets a partition key based on tenant and client ID.
  ///
  /// Combines the tenant and client ID with a delimiter to create a unique key.
  @override
  String getPartitionKey(String tenantId, String clientId) {
    if (tenantId.isEmpty || clientId.isEmpty) {
      throw ArgumentError('Tenant ID and Client ID cannot be empty.');
    }
    return '$tenantId-$clientId';
  }

  /// Clears the partition data for a specific partition key.
  ///
  /// Simulates clearing data by returning `true`.
  @override
  Future<bool> clearPartition(String partitionKey) async {
    if (partitionKey.isEmpty) {
      return false;
    }
    // Simulate clearing partition data.
    print('Clearing partition data for key: $partitionKey');
    return true;
  }

  /// Validates the partitioning strategy for a given key.
  ///
  /// Ensures the key contains a valid delimiter.
  @override
  bool validatePartitionStrategy(String partitionKey) {
    return partitionKey.contains('-');
  }
}
