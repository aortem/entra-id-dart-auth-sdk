import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

///confirm results

class ConfirmationResult {
  ///verify id
  final String verificationId;

  ///confirm function
  final Future<UserCredential> Function(String) confirm;

  ///confirm result

  ConfirmationResult({required this.verificationId, required this.confirm});
}
