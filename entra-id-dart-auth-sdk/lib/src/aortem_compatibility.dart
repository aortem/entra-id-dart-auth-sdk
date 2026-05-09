import 'auth_requests/entra_id_interactive_request.dart';
import 'auth_requests/entra_id_silent_flow_request.dart';
import 'authentication/entra_id_confidential_client.dart';
import 'authentication/entra_id_public_client.dart';
import 'enum/entra_id_interactive_request_enum.dart';
import 'exception/entra_id_authorization_user_cancle_exception.dart';
import 'exception/entra_id_network_exception.dart';
import 'model/entra_id_interactive_request_model.dart';

/// Backward-compatible confidential client application name for Aortem consumers.
typedef AortemEntraIdConfidentialClientApplication =
    EntraIdConfidentialClientApplication;

/// Backward-compatible public client application name for Aortem consumers.
typedef AortemEntraIdPublicClientApplication = EntraIdPublicClientApplication;

/// Backward-compatible silent authentication request name for Aortem consumers.
typedef AortemEntraIdSilentFlowRequest = EntraIdSilentFlowRequest;

/// Backward-compatible interactive authentication request name for Aortem consumers.
typedef AortemEntraIdInteractiveRequest = EntraIdInteractiveRequest;

/// Backward-compatible interactive request parameter name.
typedef AortemEntraIdInteractiveRequestParameters =
    InteractiveRequestParameters;

/// Backward-compatible interactive request status enum name.
typedef AortemEntraIdInteractiveRequestStatus = InteractiveRequestStatus;

/// Base compatibility exception for Aortem Entra ID consumers.
class AortemEntraIdException implements Exception {
  /// Human-readable error message.
  final String message;

  /// Optional stable error code.
  final String? code;

  /// Optional lower-level error cause.
  final Object? cause;

  /// Creates a base Aortem compatibility exception.
  const AortemEntraIdException(this.message, {this.code, this.cause});

  @override
  String toString() {
    final codeSuffix = code == null ? '' : ' (Code: $code)';
    final causeSuffix = cause == null ? '' : ' Cause: $cause';
    return 'AortemEntraIdException: $message$codeSuffix$causeSuffix';
  }
}

/// Raised when silent auth cannot continue without user interaction.
class AortemEntraIdUiRequiredException extends AortemEntraIdException {
  /// Creates a UI-required compatibility exception.
  const AortemEntraIdUiRequiredException([
    super.message = 'User interaction is required to continue authentication.',
    String code = 'ui_required',
    Object? cause,
  ]) : super(code: code, cause: cause);
}

/// Backward-compatible user-cancelled exception name.
typedef AortemEntraIdUserCancelledException = EntraIdUserCancelledException;

/// Backward-compatible network exception name.
typedef AortemEntraIdNetworkException = NetworkException;
