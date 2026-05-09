import 'auth_requests/entra_id_interactive_request.dart';
import 'auth_requests/entra_id_silent_flow_request.dart';
import 'authentication/entra_id_public_client.dart';
import 'enum/entra_id_interactive_request_enum.dart';
import 'model/entra_id_interactive_request_model.dart';

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
