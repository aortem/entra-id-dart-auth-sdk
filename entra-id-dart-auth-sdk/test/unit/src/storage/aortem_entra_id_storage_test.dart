import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/storage/aortem_entra_id_storage.dart';

void main() {
  group('AortemEntraIdStorage Tests', () {
    late AortemEntraIdStorage inMemoryStorage;
    late AortemEntraIdStorage persistentStorage;
    final testKey = 'accessToken';
    final testToken = 'test-token-value';

    setUp(() async {
      inMemoryStorage = AortemEntraIdStorage(persistent: false);
      persistentStorage = AortemEntraIdStorage(persistent: true);
      await persistentStorage.clearStorage(); // Ensure clean state
    });

    test('Save and retrieve token (in-memory)', () async {
      await inMemoryStorage.saveToken(testKey, testToken);
      final retrievedToken = await inMemoryStorage.getToken(testKey);
      expect(retrievedToken, equals(testToken));
    });

    test('Save and retrieve token (persistent)', () async {
      await persistentStorage.saveToken(testKey, testToken);
      final retrievedToken = await persistentStorage.getToken(testKey);
      expect(retrievedToken, equals(testToken));
    });

    test('Delete token (in-memory)', () async {
      await inMemoryStorage.saveToken(testKey, testToken);
      await inMemoryStorage.deleteToken(testKey);
      final retrievedToken = await inMemoryStorage.getToken(testKey);
      expect(retrievedToken, isNull);
    });

    test('Delete token (persistent)', () async {
      await persistentStorage.saveToken(testKey, testToken);
      await persistentStorage.deleteToken(testKey);
      final retrievedToken = await persistentStorage.getToken(testKey);
      expect(retrievedToken, isNull);
    });

    test('Clear storage (in-memory)', () async {
      await inMemoryStorage.saveToken(testKey, testToken);
      await inMemoryStorage.clearStorage();
      final retrievedToken = await inMemoryStorage.getToken(testKey);
      expect(retrievedToken, isNull);
    });

    test('Clear storage (persistent)', () async {
      await persistentStorage.saveToken(testKey, testToken);
      await persistentStorage.clearStorage();
      final retrievedToken = await persistentStorage.getToken(testKey);
      expect(retrievedToken, isNull);
    });
  });
}
