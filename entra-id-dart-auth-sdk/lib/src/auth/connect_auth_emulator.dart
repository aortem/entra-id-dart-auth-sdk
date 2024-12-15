import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

///connect auth class
class ConnectAuthEmulatorService {
  ///auth instance
  final FirebaseAuth auth;

  ///connect auth service
  ConnectAuthEmulatorService(this.auth);

  ///connect auth function
  void connect(String host, int port) {
    final url = 'http://$host:$port';
    auth.setEmulatorUrl(url);
    print('Connected to Firebase Auth Emulator at $url');
  }
}
