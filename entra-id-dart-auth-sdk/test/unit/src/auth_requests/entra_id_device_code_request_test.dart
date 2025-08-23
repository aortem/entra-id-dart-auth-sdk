import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';
import 'package:ds_standard_features/ds_standard_features.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('EntraIdDeviceCodeRequest', () {
    late EntraIdDeviceCodeRequest deviceCodeRequest;

    setUp(() {
      deviceCodeRequest = EntraIdDeviceCodeRequest(
        deviceCodeEndpoint: 'https://example.com/device/code',
        tokenEndpoint: 'https://example.com/token',
        parameters: DeviceCodeRequestParameters(
          clientId: 'mockClientId',
          scopes: ['mock_scope'],
        ),
      );
    });

    test('should handle device code response correctly', () {
      final mockResponse = {
        'device_code': 'mockDeviceCode',
        'user_code': 'mockUserCode',
        'verification_uri': 'https://example.com/verify',
        'interval': 5,
        'expires_in': 600,
      };

      deviceCodeRequest.handleDeviceCodeResponse(mockResponse);

      expect(
        deviceCodeRequest.deviceCodeResponse?.deviceCode,
        'mockDeviceCode',
      );
      expect(
        deviceCodeRequest.deviceCodeResponse?.verificationUrl,
        'https://example.com/verify',
      );
    });
  });
}
