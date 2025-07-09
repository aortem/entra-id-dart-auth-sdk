import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

// Mock implementation of AortemEntraIdITokenCache for testing purposes
class MockTokenCache implements AortemEntraIdITokenCache {
  final Map<String, Map<String, dynamic>> _cache = {};

  @override
  Future<void> saveToken(String key, Map<String, dynamic> tokenData) async {
    _cache[key] = tokenData;
  }

  @override
  Future<Map<String, dynamic>?> retrieveToken(String key) async {
    return _cache[key];
  }

  @override
  Future<void> removeToken(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> clearTokens() async {
    _cache.clear();
  }
}

void main() {
  group('AortemEntraIdITokenCache', () {
    late MockTokenCache tokenCache;

    setUp(() {
      tokenCache = MockTokenCache();
    });

    test('saveToken should store the token in the cache', () async {
      const key = 'token1';
      final tokenData = {'access_token': 'token123', 'expires_in': 3600};

      await tokenCache.saveToken(key, tokenData);

      final result = await tokenCache.retrieveToken(key);
      expect(result, tokenData);
    });

    test('retrieveToken should return null for missing token', () async {
      const key = 'nonExistentToken';

      final result = await tokenCache.retrieveToken(key);
      expect(result, isNull);
    });

    test('retrieveToken should return correct token data', () async {
      const key = 'token2';
      final tokenData = {'access_token': 'token456', 'expires_in': 7200};

      await tokenCache.saveToken(key, tokenData);

      final result = await tokenCache.retrieveToken(key);
      expect(result, tokenData);
    });

    test('removeToken should remove the token from the cache', () async {
      const key = 'tokenToRemove';
      final tokenData = {'access_token': 'token789', 'expires_in': 3600};

      await tokenCache.saveToken(key, tokenData);
      await tokenCache.removeToken(key);

      final result = await tokenCache.retrieveToken(key);
      expect(result, isNull);
    });

    test('clearTokens should remove all tokens from the cache', () async {
      const key1 = 'token1';
      const key2 = 'token2';
      final tokenData1 = {'access_token': 'token123', 'expires_in': 3600};
      final tokenData2 = {'access_token': 'token456', 'expires_in': 7200};

      await tokenCache.saveToken(key1, tokenData1);
      await tokenCache.saveToken(key2, tokenData2);

      await tokenCache.clearTokens();

      final result1 = await tokenCache.retrieveToken(key1);
      final result2 = await tokenCache.retrieveToken(key2);

      expect(result1, isNull);
      expect(result2, isNull);
    });
  });
}
