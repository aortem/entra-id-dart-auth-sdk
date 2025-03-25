import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/src/auth/aortem_entra_id_auth_deserializer.dart';

void main() {
  group('AortemEntraIdDeserializer Tests', () {
    test(
      'deserializeTokenResponse should correctly deserialize valid token response',
      () {
        final String jsonResponse =
            '{"access_token": "token123", "expires_in": 3600}';

        final result = AortemEntraIdDeserializer.deserializeTokenResponse(
          jsonResponse,
        );

        expect(result['access_token'], 'token123');
        expect(result['expires_in'], 3600);
      },
    );

    test(
      'deserializeTokenResponse should throw FormatException for invalid token response',
      () {
        final String jsonResponse =
            '{"access_token": "token123"}'; // Missing 'expires_in'

        expect(
          () =>
              AortemEntraIdDeserializer.deserializeTokenResponse(jsonResponse),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'deserializeUserProfileResponse should correctly deserialize valid user profile response',
      () {
        final String jsonResponse =
            '{"id": "user123", "displayName": "John Doe"}';

        final result = AortemEntraIdDeserializer.deserializeUserProfileResponse(
          jsonResponse,
        );

        expect(result['id'], 'user123');
        expect(result['displayName'], 'John Doe');
      },
    );

    test(
      'deserializeUserProfileResponse should throw FormatException for invalid user profile response',
      () {
        final String jsonResponse =
            '{"id": "user123"}'; // Missing 'displayName'

        expect(
          () => AortemEntraIdDeserializer.deserializeUserProfileResponse(
            jsonResponse,
          ),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'deserializeErrorResponse should correctly deserialize valid error response',
      () {
        final String jsonResponse =
            '{"error": "invalid_grant", "error_description": "The grant is invalid"}';

        final result = AortemEntraIdDeserializer.deserializeErrorResponse(
          jsonResponse,
        );

        expect(result['error'], 'invalid_grant');
        expect(result['error_description'], 'The grant is invalid');
      },
    );

    test(
      'deserializeErrorResponse should throw FormatException for invalid error response',
      () {
        final String jsonResponse =
            '{"error": "invalid_grant"}'; // Missing 'error_description'

        expect(
          () =>
              AortemEntraIdDeserializer.deserializeErrorResponse(jsonResponse),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
