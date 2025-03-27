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
