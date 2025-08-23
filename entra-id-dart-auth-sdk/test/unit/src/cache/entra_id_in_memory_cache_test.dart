import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('EntraIdInMemoryCache', () {
    late EntraIdInMemoryCache cache;

    setUp(() {
      cache = EntraIdInMemoryCache(
        config: InMemoryCacheConfig(
          maxTokens: 5,
          cleanupInterval: Duration(seconds: 1),
          enableAutomaticCleanup: false,
        ),
      );
    });

    tearDown(() {
      cache.dispose();
    });

    test('should save and retrieve token', () async {
      final token = CachedToken(
        tokenType: TokenType.accessToken,
        clientId: 'client-123',
        userId: 'user-1',
        scopes: ['scope1'],
        token: 'abc123',
        expiresOn: DateTime.now().add(Duration(minutes: 10)),
      );

      await cache.saveToken(token);

      final retrieved = await cache.getToken(
        tokenType: TokenType.accessToken,
        clientId: 'client-123',
        userId: 'user-1',
        scopes: ['scope1'],
      );

      expect(retrieved, isNotNull);
      expect(retrieved!.token, equals('abc123'));
    });

    test('should find tokens by filter', () async {
      final token = CachedToken(
        tokenType: TokenType.accessToken,
        clientId: 'filter-client',
        scopes: ['email', 'profile'],
        token: 'filter-token',
        expiresOn: DateTime.now().add(Duration(minutes: 10)),
      );

      await cache.saveToken(token);

      final found = await cache.findTokens(
        clientId: 'filter-client',
        scopes: ['email'],
      );

      expect(found.length, equals(1));
      expect(found.first.token, equals('filter-token'));
    });

    test('should remove expired tokens', () async {
      final expiredToken = CachedToken(
        tokenType: TokenType.accessToken,
        clientId: 'client-1',
        token: 'expired-token',
        scopes: ['scope1'],
        expiresOn: DateTime.now().subtract(Duration(minutes: 1)),
      );

      await cache.saveToken(expiredToken);
      await cache.removeExpiredTokens();

      final stats = await cache.getCacheStats();
      expect(stats['expiredTokens'], equals(0));
      expect(stats['activeTokens'], equals(0));
    });

    test('should evict oldest tokens when max size reached', () async {
      for (int i = 0; i < 5; i++) {
        await cache.saveToken(
          CachedToken(
            tokenType: TokenType.accessToken,
            clientId: 'client-$i',
            token: 'token-$i',
            scopes: ['scope1'],
            expiresOn: DateTime.now().add(Duration(minutes: 5 + i)),
          ),
        );
      }

      await cache.saveToken(
        CachedToken(
          tokenType: TokenType.accessToken,
          clientId: 'client-new',
          token: 'new-token',
          scopes: ['scope1'],
          expiresOn: DateTime.now().add(Duration(minutes: 20)),
        ),
      );

      final stats = await cache.getCacheStats();
      expect(stats['totalTokens'] <= 5, isTrue);
    });

    test('should clear all tokens', () async {
      await cache.saveToken(
        CachedToken(
          tokenType: TokenType.accessToken,
          clientId: 'client-xyz',
          token: 'clear-me',
          scopes: ['scope1'],
          expiresOn: DateTime.now().add(Duration(minutes: 10)),
        ),
      );

      await cache.clear();

      final stats = await cache.getCacheStats();
      expect(stats['totalTokens'], equals(0));
    });
  });
}
