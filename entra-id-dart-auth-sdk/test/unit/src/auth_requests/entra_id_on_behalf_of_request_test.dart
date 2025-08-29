import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_on_behalf_of_request.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_kv_store.dart';
import 'package:entra_id_dart_auth_sdk/src/config/entra_id_configuration.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_on_behalf_of_request_exception.dart';

class MockCacheStore extends Mock implements EntraIdCacheKVStore {}

void main() {
  late EntraIdOnBehalfOfRequest oboRequest;
  late MockCacheStore mockCacheStore;
  late EntraIdConfiguration config;

  const testClientId = 'test-client-id';
  const testTenantId = 'test-tenant-id';
  const testAuthority = 'https://login.microsoftonline.com/common';
  const testRedirectUri = 'https://localhost:3000/auth-callback';
  const testUserAssertion = 'test-user-assertion';
  final testScopes = ['scope1', 'scope2'];

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
    test('throws when user assertion is empty', () {
      expect(
        () => EntraIdOnBehalfOfRequest(
          configuration: config,
          cacheStore: mockCacheStore,
          userAssertion: '',
          scopes: testScopes,
        ),
        throwsA(isA<OnBehalfOfRequestException>()),
      );
    });

    test('throws when scopes are empty', () {
      expect(
        () => EntraIdOnBehalfOfRequest(
          configuration: config,
          cacheStore: mockCacheStore,
          userAssertion: testUserAssertion,
          scopes: [],
        ),
        throwsA(isA<OnBehalfOfRequestException>()),
      );
    });
  });

  group('Cache Operations', () {
    setUp(() {
      oboRequest = EntraIdOnBehalfOfRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        userAssertion: testUserAssertion,
        scopes: testScopes,
      );
    });

    test('generates correct cache key', () {
      final key = oboRequest.generateCacheKey();
      expect(key, 'obo:$testClientId:scope1 scope2');
    });
  });

  group('Token Exchange', () {
    test('implements token exchange logic', () async {
      // This test will be implemented once _exchangeToken is implemented
      expect(true, isTrue); // Placeholder
    });
  });
}
