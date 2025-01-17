
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/core/aortem_entraid_storage.dart';


void main() {
  group('AortemEntraIdStorage Tests', () {
    late AortemEntraIdStorage inMemoryStorage;
    late AortemEntraIdStorage persistentStorage;

    setUp(() async {
      inMemoryStorage = AortemEntraIdStorage();
      persistentStorage = AortemEntraIdStorage(persistent: true);

      // Initialize persistent storage
      await persistentStorage.initialize();
    });

    test('Save and Retrieve Token (In-Memory)', () async {
      await inMemoryStorage.saveToken('testKey', 'testToken');
      final token = await inMemoryStorage.getToken('testKey');
      expect(token, 'testToken');
    });

    test('Save and Retrieve Token (Persistent)', () async {
      await persistentStorage.saveToken('testKey', 'testToken');
      final token = await persistentStorage.getToken('testKey');
      expect(token, 'testToken');
    });

    test('Delete Token (In-Memory)', () async {
      await inMemoryStorage.saveToken('testKey', 'testToken');
      await inMemoryStorage.deleteToken('testKey');
      final token = await inMemoryStorage.getToken('testKey');
      expect(token, isNull);
    });

    test('Delete Token (Persistent)', () async {
      await persistentStorage.saveToken('testKey', 'testToken');
      await persistentStorage.deleteToken('testKey');
      final token = await persistentStorage.getToken('testKey');
      expect(token, isNull);
    });

    test('Clear Storage (In-Memory)', () async {
      await inMemoryStorage.saveToken('key1', 'token1');
      await inMemoryStorage.saveToken('key2', 'token2');
      await inMemoryStorage.clearStorage();
      final token1 = await inMemoryStorage.getToken('key1');
      final token2 = await inMemoryStorage.getToken('key2');
      expect(token1, isNull);
      expect(token2, isNull);
    });

    test('Clear Storage (Persistent)', () async {
      await persistentStorage.saveToken('key1', 'token1');
      await persistentStorage.saveToken('key2', 'token2');
      await persistentStorage.clearStorage();
      final token1 = await persistentStorage.getToken('key1');
      final token2 = await persistentStorage.getToken('key2');
      expect(token1, isNull);
      expect(token2, isNull);
    });
  });
}
