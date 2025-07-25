/// AortemEntraIdIPartitionManager: Interface for partition management.
///
/// This interface defines the contract for managing token and cache
/// partitioning in multi-tenant or multi-client scenarios.
abstract class AortemEntraIdIPartitionManager {
  /// Gets the partition key based on the provided [tenantId] or [clientId].
  ///
  /// Throws an [ArgumentError] if no valid key can be generated.
  String getPartitionKey(String tenantId, String clientId);

  /// Clears the partition data associated with the given [partitionKey].
  ///
  /// Returns `true` if the operation is successful, otherwise `false`.
  Future<bool> clearPartition(String partitionKey);

  /// Validates the partitioning strategy for the provided [partitionKey].
  ///
  /// Returns `true` if the strategy is valid, otherwise `false`.
  bool validatePartitionStrategy(String partitionKey);
}

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
