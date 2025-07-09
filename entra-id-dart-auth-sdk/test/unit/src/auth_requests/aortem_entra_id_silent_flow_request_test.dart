import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/aortem_entra_id_silent_flow_request.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/aortem_entra_id_cache_kv_store.dart';
import 'package:entra_id_dart_auth_sdk/src/config/aortem_entra_id_configuration.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/aortem_entra_id_silent_flow_request_exception.dart';

class MockCacheStore extends Mock implements AortemEntraIdCacheKVStore {}

void main() {
  late AortemEntraIdSilentFlowRequest silentFlowRequest;
  late MockCacheStore mockCacheStore;
  late AortemEntraIdConfiguration config;

  const testClientId = 'test-client-id';
  const testTenantId = 'test-tenant-id';
  const testAuthority = 'https://login.microsoftonline.com/common';
  const testRedirectUri = 'https://localhost:3000/auth-callback';
  final testScopes = ['scope1', 'scope2'];
  const testAccountId = 'test-account-id';

  setUp(() {
    mockCacheStore = MockCacheStore();

    // Reset any existing configuration before each test
    AortemEntraIdConfiguration.reset();

    // Initialize configuration with required parameters
    config = AortemEntraIdConfiguration.initialize(
      clientId: testClientId,
      tenantId: testTenantId,
      authority: testAuthority,
      redirectUri: testRedirectUri,
    );
  });

  tearDown(() {
    // Clean up after each test
    AortemEntraIdConfiguration.reset();
  });

  group('Validation', () {
    test('throws when scopes are empty', () {
      expect(
        () => AortemEntraIdSilentFlowRequest(
          configuration: config,
          cacheStore: mockCacheStore,
          scopes: [],
        ),
        throwsA(isA<SilentFlowRequestException>()),
      );
    });
  });

  group('Token Cache', () {
    setUp(() {
      silentFlowRequest = AortemEntraIdSilentFlowRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        scopes: testScopes,
        accountId: testAccountId,
      );
    });

    test('generates correct access token cache key', () {
      final key = silentFlowRequest.generateAccessTokenCacheKey();
      expect(key, 'access:$testClientId:scope1 scope2:$testAccountId');
    });

    test('generates correct refresh token cache key', () {
      final key = silentFlowRequest.generateRefreshTokenCacheKey();
      expect(key, 'refresh:$testClientId:$testAccountId');
    });

    test('returns null when no cached access token exists', () async {
      when(() => mockCacheStore.get(any())).thenAnswer((_) async => null);
      final token = await silentFlowRequest.getCachedAccessToken();
      expect(token, isNull);
    });

    test('returns null when no cached refresh token exists', () async {
      when(() => mockCacheStore.get(any())).thenAnswer((_) async => null);
      final token = await silentFlowRequest.getCachedRefreshToken();
      expect(token, isNull);
    });
  });

  group('Token Expiration', () {
    setUp(() {
      silentFlowRequest = AortemEntraIdSilentFlowRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        scopes: testScopes,
      );
    });

    test('returns true when token is expired', () {
      final expiredToken = {
        'created_at':
            DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch,
        'expiresin': 30, // 30 seconds
      };
      expect(silentFlowRequest.isTokenExpired(expiredToken), isTrue);
    });

    test('returns false when token is not expired', () {
      final validToken = {
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'expires_in': 3600, // 1 hour
      };
      expect(silentFlowRequest.isTokenExpired(validToken), isFalse);
    });

    test('returns true when token has no expiration data', () {
      expect(silentFlowRequest.isTokenExpired({}), isTrue);
      expect(silentFlowRequest.isTokenExpired({'created_at': 123}), isTrue);
      expect(silentFlowRequest.isTokenExpired({'expires_in': 3600}), isTrue);
    });
  });

  group('Execute Request', () {
    setUp(() {
      silentFlowRequest = AortemEntraIdSilentFlowRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        scopes: testScopes,
      );
    });

    test('returns cached token when valid', () async {
      final validToken = {
        'access_token': 'valid-token',
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'expires_in': 3600,
      };

      when(() => mockCacheStore.get(any())).thenAnswer((_) async => validToken);

      final result = await silentFlowRequest.executeRequest();
      expect(result, validToken);
    });

    test('attempts refresh when token is expired', () async {
      final expiredToken = {
        'access_token': 'expired-token',
        'created_at':
            DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch,
        'expires_in': 30,
      };

      when(
        () =>
            mockCacheStore.get(silentFlowRequest.generateAccessTokenCacheKey()),
      ).thenAnswer((_) async => expiredToken);
      when(
        () => mockCacheStore.get(
          silentFlowRequest.generateRefreshTokenCacheKey(),
        ),
      ).thenAnswer((_) async => {'refresh_token': 'refresh-token'});

      // Since refresh is not implemented, it will throw UnimplementedError
      expect(
        () => silentFlowRequest.executeRequest(),
        throwsA(isA<SilentFlowRequestException>()),
      );
    });

    test('throws when no tokens are available', () async {
      when(() => mockCacheStore.get(any())).thenAnswer((_) async => null);
      expect(
        () => silentFlowRequest.executeRequest(),
        throwsA(isA<SilentFlowRequestException>()),
      );
    });
  });
}
