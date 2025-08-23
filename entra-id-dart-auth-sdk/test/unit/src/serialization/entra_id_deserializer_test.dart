import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('AortemEntraIdDeserializer', () {
    test(
      'deserializeTokenResponse should return correct data for valid response',
      () {
        const jsonResponse = '{"access_token": "token123", "expires_in": 3600}';
        final result = AortemEntraIdDeserializer.deserializeTokenResponse(
          jsonResponse,
        );

        expect(result['access_token'], 'token123');
        expect(result['expires_in'], 3600);
      },
    );

    test(
      'deserializeTokenResponse should throw FormatException for missing fields',
      () {
        const jsonResponse = '{"access_token": "token123"}';

        expect(
          () =>
              AortemEntraIdDeserializer.deserializeTokenResponse(jsonResponse),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'deserializeUserProfileResponse should return correct data for valid response',
      () {
        const jsonResponse = '{"id": "user123", "displayName": "User Name"}';
        final result = AortemEntraIdDeserializer.deserializeUserProfileResponse(
          jsonResponse,
        );

        expect(result['id'], 'user123');
        expect(result['displayName'], 'User Name');
      },
    );

    test(
      'deserializeUserProfileResponse should throw FormatException for missing fields',
      () {
        const jsonResponse = '{"id": "user123"}';

        expect(
          () => AortemEntraIdDeserializer.deserializeUserProfileResponse(
            jsonResponse,
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'deserializeErrorResponse should return correct data for valid error response',
      () {
        const jsonResponse =
            '{"error": "invalid_grant", "error_description": "The provided grant is invalid."}';
        final result = AortemEntraIdDeserializer.deserializeErrorResponse(
          jsonResponse,
        );

        expect(result['error'], 'invalid_grant');
        expect(result['error_description'], 'The provided grant is invalid.');
      },
    );

    test(
      'deserializeErrorResponse should throw FormatException for missing error fields',
      () {
        const jsonResponse = '{"error": "invalid_grant"}';

        expect(
          () =>
              AortemEntraIdDeserializer.deserializeErrorResponse(jsonResponse),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'deserializeResponse should deserialize using a custom fromJson function',
      () {
        const jsonResponse = '{"access_token": "token123", "expires_in": 3600}';

        final result =
            AortemEntraIdDeserializer.deserializeResponse<Map<String, dynamic>>(
              jsonResponse,
              (json) => json,
            );

        expect(result['access_token'], 'token123');
        expect(result['expires_in'], 3600);
      },
    );
  });
}
