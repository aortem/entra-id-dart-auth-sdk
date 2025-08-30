import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_azure_json_cache.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_kv_store.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_options.dart';

class MockKVStore extends Mock implements EntraIdCacheKVStore {}

void main() {
  late EntraIdAzureJsonCache cache;
  late MockKVStore mockKvStore;

  setUp(() {
    mockKvStore = MockKVStore();
    // Create cache with custom constructor that accepts KV store
    cache = EntraIdAzureJsonCache.withStore(
      store: mockKvStore,
      options: EntraIdCacheOptions(namespace: 'azure_json_cache'),
    );
  });

  group('exportCache', () {
    test('should export the entire cache as JSON', () async {
      // Since getAllEntries() is implemented internally, we'll test the output format
      final result = await cache.exportCache();
      final decoded = jsonDecode(result) as Map<String, dynamic>;

      expect(decoded['version'], '1.0');
      expect(decoded['schema'], '1.0');
      expect(decoded['timestamp'], isNotNull);
      expect(decoded['entries'], isA<Map<String, dynamic>>());
    });
  });
}
