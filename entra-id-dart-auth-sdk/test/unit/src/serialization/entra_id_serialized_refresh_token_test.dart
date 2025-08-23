import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

// Import the actual file path where your class is defined

void main() {
  group('AortemEntraIdSerializedRefreshTokenEntity', () {
    test('should create an entity from JSON and serialize back to JSON', () {
      final json = {
        'refreshToken': 'test-refresh-token',
        'clientId': 'test-client-id',
        'tenantId': 'test-tenant-id',
        'issuedOn': '2025-01-01T00:00:00.000Z',
        'scopes': ['scope1', 'scope2'],
        'environment': 'test-environment',
        'realm': 'test-realm',
        'userId': 'test-user-id',
        'familyId': 'test-family-id',
        'homeAccountId': 'test-home-account-id',
        'metadata': {'key': 'value'},
      };

      final entity = AortemEntraIdSerializedRefreshTokenEntity.fromJson(json);

      // Test that the entity was created correctly
      expect(entity.refreshToken, 'test-refresh-token');
      expect(entity.clientId, 'test-client-id');
      expect(entity.tenantId, 'test-tenant-id');
      expect(entity.issuedOn, DateTime.utc(2025, 1, 1));
      expect(entity.scopes, ['scope1', 'scope2']);
      expect(entity.environment, 'test-environment');
      expect(entity.realm, 'test-realm');
      expect(entity.userId, 'test-user-id');
      expect(entity.familyId, 'test-family-id');
      expect(entity.homeAccountId, 'test-home-account-id');
      expect(entity.metadata, {'key': 'value'});

      // Test serialization back to JSON
      final serializedJson = entity.toJson();
      expect(serializedJson['refreshToken'], 'test-refresh-token');
      expect(serializedJson['clientId'], 'test-client-id');
      expect(serializedJson['tenantId'], 'test-tenant-id');
      expect(serializedJson['issuedOn'], '2025-01-01T00:00:00.000Z');
      expect(serializedJson['scopes'], ['scope1', 'scope2']);
      expect(serializedJson['environment'], 'test-environment');
      expect(serializedJson['realm'], 'test-realm');
      expect(serializedJson['userId'], 'test-user-id');
      expect(serializedJson['familyId'], 'test-family-id');
      expect(serializedJson['homeAccountId'], 'test-home-account-id');
      expect(serializedJson['metadata'], {'key': 'value'});
    });

    test('should throw exception if required fields are empty', () {
      expect(
        () => AortemEntraIdSerializedRefreshTokenEntity(
          refreshToken: '',
          clientId: 'test-client-id',
          tenantId: 'test-tenant-id',
          issuedOn: DateTime.utc(2025, 1, 1),
          scopes: ['scope1'],
          environment: 'test-environment',
          realm: 'test-realm',
        ),
        throwsA(isA<RefreshTokenEntityException>()),
      );

      expect(
        () => AortemEntraIdSerializedRefreshTokenEntity(
          refreshToken: 'test-refresh-token',
          clientId: '',
          tenantId: 'test-tenant-id',
          issuedOn: DateTime.utc(2025, 1, 1),
          scopes: ['scope1'],
          environment: 'test-environment',
          realm: 'test-realm',
        ),
        throwsA(isA<RefreshTokenEntityException>()),
      );

      expect(
        () => AortemEntraIdSerializedRefreshTokenEntity(
          refreshToken: 'test-refresh-token',
          clientId: 'test-client-id',
          tenantId: '',
          issuedOn: DateTime.utc(2025, 1, 1),
          scopes: ['scope1'],
          environment: 'test-environment',
          realm: 'test-realm',
        ),
        throwsA(isA<RefreshTokenEntityException>()),
      );
    });

    test('should generate a unique cache key', () {
      final entity = AortemEntraIdSerializedRefreshTokenEntity(
        refreshToken: 'test-refresh-token',
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        issuedOn: DateTime.utc(2025, 1, 1),
        scopes: ['scope1'],
        environment: 'test-environment',
        realm: 'test-realm',
      );

      final cacheKey = entity.cacheKey;

      // Test that cacheKey is not null or empty
      expect(cacheKey, isNotEmpty);
    });

    test('should correctly copy and update fields', () {
      final entity = AortemEntraIdSerializedRefreshTokenEntity(
        refreshToken: 'test-refresh-token',
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        issuedOn: DateTime.utc(2025, 1, 1),
        scopes: ['scope1'],
        environment: 'test-environment',
        realm: 'test-realm',
      );

      final updatedEntity = entity.copyWith(refreshToken: 'new-refresh-token');

      // Test that the copyWith method correctly updates the specified field
      expect(updatedEntity.refreshToken, 'new-refresh-token');
      expect(updatedEntity.clientId, entity.clientId); // Should remain the same
    });

    test('should check for required scopes', () {
      final entity = AortemEntraIdSerializedRefreshTokenEntity(
        refreshToken: 'test-refresh-token',
        clientId: 'test-client-id',
        tenantId: 'test-tenant-id',
        issuedOn: DateTime.utc(2025, 1, 1),
        scopes: ['scope1', 'scope2'],
        environment: 'test-environment',
        realm: 'test-realm',
      );

      final hasScopes = entity.hasScopes(['scope1', 'scope2']);
      final hasMissingScopes = entity.hasScopes(['scope1', 'scope3']);

      // Test that the entity has the required scopes
      expect(hasScopes, isTrue);

      // Test that the entity does not have missing scopes
      expect(hasMissingScopes, isFalse);
    });
  });
}
