import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

class InMemoryTokenCache extends AortemEntraIdTokenCache {
  final List<CachedToken> _tokens = [];

  @override
  Future<void> saveToken(CachedToken token) async {
    validateToken(token);
    _tokens.removeWhere(
      (t) =>
          t.tokenType == token.tokenType &&
          t.clientId == token.clientId &&
          t.userId == token.userId &&
          _scopesMatch(t.scopes, token.scopes),
    );
    _tokens.add(token);
    notifyChange('saved');
  }

  @override
  Future<CachedToken?> getToken({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  }) async {
    final match = _tokens
        .where(
          (t) =>
              t.tokenType == tokenType &&
              t.clientId == clientId &&
              t.userId == userId &&
              (scopes == null || _scopesMatch(t.scopes, scopes)),
        )
        .toList();

    return match.isNotEmpty ? match.first : null;
  }

  @override
  Future<void> removeToken({
    required TokenType tokenType,
    required String clientId,
    String? userId,
    List<String>? scopes,
  }) async {
    _tokens.removeWhere(
      (t) =>
          t.tokenType == tokenType &&
          t.clientId == clientId &&
          t.userId == userId &&
          (scopes == null || _scopesMatch(t.scopes, scopes)),
    );
    notifyChange('removed');
  }

  @override
  Future<List<CachedToken>> findTokens({
    TokenType? tokenType,
    String? clientId,
    String? userId,
    List<String>? scopes,
  }) async {
    return _tokens
        .where(
          (t) =>
              (tokenType == null || t.tokenType == tokenType) &&
              (clientId == null || t.clientId == clientId) &&
              (userId == null || t.userId == userId) &&
              (scopes == null || _scopesMatch(t.scopes, scopes)),
        )
        .toList();
  }

  @override
  Future<void> clear() async {
    _tokens.clear();
    notifyChange('cleared');
  }

  @override
  Future<void> removeExpiredTokens() async {
    _tokens.removeWhere((t) => t.isExpired);
    notifyChange('expired_removed');
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    return {
      'total': _tokens.length,
      'expired': _tokens.where((t) => t.isExpired).length,
    };
  }

  bool _scopesMatch(List<String> a, List<String> b) {
    return Set.from(a).containsAll(b) && Set.from(b).containsAll(a);
  }
}

void main() {
  late InMemoryTokenCache cache;
  late CachedToken sampleToken;

  setUp(() {
    cache = InMemoryTokenCache();
    sampleToken = CachedToken(
      token: 'abc123',
      tokenType: TokenType.accessToken,
      expiresOn: DateTime.now().add(Duration(hours: 1)),
      clientId: 'client-001',
      userId: 'user-xyz',
      scopes: ['read', 'write'],
    );
  });

  test('save and get token', () async {
    await cache.saveToken(sampleToken);
    final retrieved = await cache.getToken(
      tokenType: TokenType.accessToken,
      clientId: 'client-001',
      userId: 'user-xyz',
      scopes: ['read', 'write'],
    );

    expect(retrieved, isNotNull);
    expect(retrieved!.token, equals('abc123'));
  });

  test('remove token', () async {
    await cache.saveToken(sampleToken);
    await cache.removeToken(
      tokenType: TokenType.accessToken,
      clientId: 'client-001',
      userId: 'user-xyz',
      scopes: ['read', 'write'],
    );

    final retrieved = await cache.getToken(
      tokenType: TokenType.accessToken,
      clientId: 'client-001',
      userId: 'user-xyz',
      scopes: ['read', 'write'],
    );

    expect(retrieved, isNull);
  });

  test('validateToken throws on empty token', () {
    final invalidToken = CachedToken(
      token: '',
      tokenType: TokenType.accessToken,
      expiresOn: DateTime.now().add(Duration(hours: 1)),
      clientId: 'client-001',
      scopes: ['read'],
    );

    expect(
      () => cache.validateToken(invalidToken),
      throwsA(isA<TokenCacheException>()),
    );
  });

  test('clear removes all tokens', () async {
    await cache.saveToken(sampleToken);
    await cache.clear();

    final stats = await cache.getCacheStats();
    expect(stats['total'], equals(0));
  });

  test('removeExpiredTokens removes only expired tokens', () async {
    final expiredToken = CachedToken(
      token: 'expired',
      tokenType: TokenType.accessToken,
      expiresOn: DateTime.now().subtract(Duration(seconds: 1)),
      clientId: 'client-001',
      scopes: ['read'],
    );

    await cache.saveToken(sampleToken);
    await cache.saveToken(expiredToken);
    await cache.removeExpiredTokens();

    final stats = await cache.getCacheStats();
    expect(stats['total'], equals(1));
    expect(stats['expired'], equals(0));
  });

  test('toJson and fromJson work correctly', () {
    final json = sampleToken.toJson();
    final newToken = CachedToken.fromJson(json);
    expect(newToken.token, sampleToken.token);
    expect(newToken.tokenType, sampleToken.tokenType);
    expect(newToken.clientId, sampleToken.clientId);
    expect(newToken.scopes, sampleToken.scopes);
  });

  test('generateCacheKey includes clientId and tokenType', () {
    final key = cache.generateCacheKey(
      tokenType: TokenType.idToken,
      clientId: 'client-x',
      userId: 'user-a',
      scopes: ['email'],
    );

    expect(key.contains('TokenType.idToken'), isTrue);
    expect(key.contains('client-x'), isTrue);
    expect(key.contains('user-a'), isTrue);
    expect(key.contains('email'), isTrue);
  });
}
