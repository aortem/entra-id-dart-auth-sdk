import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() {
  group('entra_id_dart_auth_sdk public exports', () {
    test(
      'exposes the in-memory cache client from the package entrypoint',
      () async {
        final cache = InMemoryCacheClient(enableSweeper: false);

        await cache.save('access_token', 'token-value');
        expect(await cache.retrieve('access_token'), 'token-value');

        await cache.remove('access_token');
        expect(await cache.retrieve('access_token'), isNull);

        cache.dispose();
      },
    );

    test(
      'exposes Aortem compatibility aliases from the package entrypoint',
      () {
        expect(
          AortemEntraIdConfidentialClientApplication,
          same(EntraIdConfidentialClientApplication),
        );
        expect(
          AortemEntraIdPublicClientApplication,
          same(EntraIdPublicClientApplication),
        );
        expect(AortemEntraIdSilentFlowRequest, same(EntraIdSilentFlowRequest));
        expect(
          AortemEntraIdInteractiveRequest,
          same(EntraIdInteractiveRequest),
        );
        expect(
          AortemEntraIdInteractiveRequestParameters,
          same(InteractiveRequestParameters),
        );
        expect(
          AortemEntraIdInteractiveRequestStatus,
          same(InteractiveRequestStatus),
        );
        expect(
          AortemEntraIdUserCancelledException,
          same(EntraIdUserCancelledException),
        );
        final networkException = AortemEntraIdNetworkException('network');
        expect(networkException.toString(), contains('NetworkException'));
      },
    );

    test('exposes Aortem compatibility exception classes', () {
      final base = AortemEntraIdException('failed', code: 'test_error');
      expect(base.message, 'failed');
      expect(base.code, 'test_error');
      expect(base.toString(), contains('AortemEntraIdException'));

      final uiRequired = AortemEntraIdUiRequiredException();
      expect(uiRequired.message, contains('User interaction'));
      expect(uiRequired.code, 'ui_required');
    });
  });
}
