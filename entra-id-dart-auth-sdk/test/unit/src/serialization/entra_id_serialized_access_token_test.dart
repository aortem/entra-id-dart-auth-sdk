import 'package:ds_standard_features/ds_standard_features.dart' show DateFormat;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('AortemEntraIdSerializedAccessTokenEntity', () {
    late AortemEntraIdSerializedAccessTokenEntity tokenEntity;

    setUp(() {
      // Set up an initial instance of AortemEntraIdSerializedAccessTokenEntity
      tokenEntity = AortemEntraIdSerializedAccessTokenEntity(
        accessToken: 'sample-access-token',
        clientId: 'sample-client-id',
        issuedOn: DateTime.utc(2025, 4, 4, 10, 0, 0),
        expiresOn: DateTime.utc(2025, 4, 4, 12, 0, 0),
        tokenType: 'Bearer',
        scopes: ['read', 'write'],
        tenantId: 'sample-tenant-id',
        authority: 'sample-authority',
        isRefreshable: true,
        claims: {'claim1': 'value1'},
      );
    });

    test('should correctly initialize entity fields', () {
      expect(tokenEntity.accessToken, equals('sample-access-token'));
      expect(tokenEntity.clientId, equals('sample-client-id'));
      expect(tokenEntity.issuedOn, equals(DateTime.utc(2025, 4, 4, 10, 0, 0)));
      expect(tokenEntity.expiresOn, equals(DateTime.utc(2025, 4, 4, 12, 0, 0)));
      expect(tokenEntity.tokenType, equals('Bearer'));
      expect(tokenEntity.scopes, equals(['read', 'write']));
      expect(tokenEntity.tenantId, equals('sample-tenant-id'));
      expect(tokenEntity.authority, equals('sample-authority'));
      expect(tokenEntity.isRefreshable, isTrue);
      expect(tokenEntity.claims, equals({'claim1': 'value1'}));
    });

    test('should return true if token is a bearer token', () {
      expect(tokenEntity.isBearer, isTrue);
    });

    test('should generate a valid cache key', () {
      final cacheKey = tokenEntity.cacheKey;
      expect(cacheKey, isNotEmpty);
    });

    test('should correctly convert entity to JSON and from JSON', () {
      final json = tokenEntity.toJson();
      expect(json['accessToken'], equals('sample-access-token'));
      expect(json['clientId'], equals('sample-client-id'));
      expect(
        json['issuedOn'],
        equals(
          DateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
          ).format(tokenEntity.issuedOn),
        ),
      );
      expect(
        json['expiresOn'],
        equals(
          DateFormat(
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
          ).format(tokenEntity.expiresOn),
        ),
      );
      expect(json['tokenType'], equals('Bearer'));
      expect(json['scopes'], equals(['read', 'write']));
      expect(json['tenantId'], equals('sample-tenant-id'));
      expect(json['authority'], equals('sample-authority'));

      final fromJson = AortemEntraIdSerializedAccessTokenEntity.fromJson(json);
      expect(fromJson.accessToken, equals('sample-access-token'));
      expect(fromJson.clientId, equals('sample-client-id'));
      expect(fromJson.issuedOn, equals(tokenEntity.issuedOn));
      expect(fromJson.expiresOn, equals(tokenEntity.expiresOn));
      expect(fromJson.tokenType, equals('Bearer'));
      expect(fromJson.scopes, equals(['read', 'write']));
    });

    test('should throw AccessTokenEntityException for invalid token', () {
      expect(
        () => AortemEntraIdSerializedAccessTokenEntity(
          accessToken: '',
          clientId: 'sample-client-id',
          issuedOn: DateTime.utc(2025, 4, 4, 10, 0, 0),
          expiresOn: DateTime.utc(2025, 4, 4, 12, 0, 0),
          tokenType: 'Bearer',
          scopes: ['read', 'write'],
          tenantId: 'sample-tenant-id',
          authority: 'sample-authority',
        ),
        throwsA(isA<AccessTokenEntityException>()),
      );
    });
  });
}
