import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_silent_flow_request.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_kv_store.dart';
import 'package:entra_id_dart_auth_sdk/src/config/entra_id_configuration.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_silent_flow_request_exception.dart';

class MockCacheStore extends Mock implements EntraIdCacheKVStore {}

void main() {
  late EntraIdSilentFlowRequest silentFlowRequest;
  late MockCacheStore mockCacheStore;
  late EntraIdConfiguration config;

  const testClientId = 'test-client-id';
  const testTenantId = 'test-tenant-id';
  const testAuthority = 'https://login.microsoftonline.com/common';
  const testRedirectUri = 'https://localhost:3000/auth-callback';
  final testScopes = ['scope1', 'scope2'];
  const testAccountId = 'test-account-id';

  setUp(() {
    mockCacheStore = MockCacheStore();

    // Reset any existing configuration before each test
    EntraIdConfiguration.reset();

    // Initialize configuration with required parameters
    config = EntraIdConfiguration.initialize(
      clientId: testClientId,
      tenantId: testTenantId,
      authority: testAuthority,
      redirectUri: testRedirectUri,
    );
  });

  tearDown(() {
    // Clean up after each test
    EntraIdConfiguration.reset();
  });

  group('Validation', () {
    test('throws when scopes are empty', () {
      expect(
        () => EntraIdSilentFlowRequest(
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
      silentFlowRequest = EntraIdSilentFlowRequest(
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
  });

  group('Token Expiration', () {
    setUp(() {
      silentFlowRequest = EntraIdSilentFlowRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        scopes: testScopes,
      );
    });

    test('returns true when token is expired', () {
      final expiredToken = {
        'created_at': DateTime.now()
            .subtract(Duration(hours: 1))
            .millisecondsSinceEpoch,
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
      silentFlowRequest = EntraIdSilentFlowRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        scopes: testScopes,
      );
    });
  });
}
