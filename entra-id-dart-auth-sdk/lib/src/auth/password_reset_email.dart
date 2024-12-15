import 'dart:convert';
import 'package:entra_id_dart_auth_sdk/src/exceptions.dart';

///password reset
class PasswordResetEmailService {
  ///auth
  final dynamic auth;

  ///password reset
  PasswordResetEmailService({required this.auth});

  ///password reset function
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final url = Uri.https(
        'identitytoolkit.googleapis.com',
        '/v1/accounts:sendOobCode',
        {'key': auth.apiKey},
      );

      final response = await auth.httpClient.post(
        url,
        body: json.encode({
          'requestType': 'PASSWORD_RESET',
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body)['error'];
        throw FirebaseAuthException(
          code: error['message'],
          message: error['message'],
        );
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'password-reset-error',
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }
}
