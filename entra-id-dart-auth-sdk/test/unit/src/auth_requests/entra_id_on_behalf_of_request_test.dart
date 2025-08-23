import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth_requests/entra_id_on_behalf_of_request.dart';
import 'package:entra_id_dart_auth_sdk/src/cache/entra_id_cache_kv_store.dart';
import 'package:entra_id_dart_auth_sdk/src/config/entra_id_configuration.dart';
import 'package:entra_id_dart_auth_sdk/src/exception/entra_id_on_behalf_of_request_exception.dart';

class MockCacheStore extends Mock implements AortemEntraIdCacheKVStore {}

void main() {
  late AortemEntraIdOnBehalfOfRequest oboRequest;
  late MockCacheStore mockCacheStore;
  late AortemEntraIdConfiguration config;

  const testClientId = 'test-client-id';
  const testTenantId = 'test-tenant-id';
  const testAuthority = 'https://login.microsoftonline.com/common';
  const testRedirectUri = 'https://localhost:3000/auth-callback';
  const testUserAssertion = 'test-user-assertion';
  final testScopes = ['scope1', 'scope2'];

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
    test('throws when user assertion is empty', () {
      expect(
        () => AortemEntraIdOnBehalfOfRequest(
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
        () => AortemEntraIdOnBehalfOfRequest(
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
      oboRequest = AortemEntraIdOnBehalfOfRequest(
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

    test('returns null when no cached token exists', () async {
      when(() => mockCacheStore.get(any())).thenAnswer((_) async => null);
      final token = await oboRequest.getCachedToken();
      expect(token, isNull);
    });

    test('caches token response correctly', () async {
      final tokenResponse = {'access_token': 'test-token', 'expires_in': 3600};
      when(() => mockCacheStore.set(any(), any())).thenAnswer((_) async => {});

      await oboRequest.cacheToken(tokenResponse);

      verify(
        () => mockCacheStore.set(
          'obo:$testClientId:scope1 scope2',
          tokenResponse,
        ),
      ).called(1);
    });
  });

  group('Execute Request', () {
    setUp(() {
      oboRequest = AortemEntraIdOnBehalfOfRequest(
        configuration: config,
        cacheStore: mockCacheStore,
        userAssertion: testUserAssertion,
        scopes: testScopes,
      );
    });

    test('returns cached token when available', () async {
      final cachedToken = {'access_token': 'cached-token', 'expires_in': 3600};

      when(
        () => mockCacheStore.get(any()),
      ).thenAnswer((_) async => cachedToken);

      final result = await oboRequest.executeRequest();
      expect(result, cachedToken);
    });

    test('throws when token exchange is not implemented', () async {
      when(() => mockCacheStore.get(any())).thenAnswer((_) async => null);

      expect(
        () => oboRequest.executeRequest(),
        throwsA(isA<OnBehalfOfRequestException>()),
      );
    });

    test('properly handles errors during execution', () async {
      when(() => mockCacheStore.get(any())).thenThrow(Exception('Cache error'));

      expect(
        () => oboRequest.executeRequest(),
        throwsA(isA<OnBehalfOfRequestException>()),
      );
    });
  });
  group('Token Exchange', () {
    test('implements token exchange logic', () async {
      // This test will be implemented once _exchangeToken is implemented
      expect(true, isTrue); // Placeholder
    });
  });
}
