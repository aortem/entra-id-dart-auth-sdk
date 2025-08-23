/// Microsoft Entra ID Authentication SDK for Dart
/// Provides authentication and authorization capabilities using Microsoft Entra ID
/// (formerly Azure Active Directory).
library;
// lib/entra_id_dart_auth_sdk.dart

// API Clients
export 'src/api_clients/entra_id_api.dart';
export 'src/api_clients/entra_id_http_client.dart';
export 'src/api_clients/entra_id_http_method.dart';
export 'src/api_clients/entra_id_http_status.dart';

// Authentication Requests
export 'src/auth_requests/entra_id_authorization_code_request.dart';
export 'src/auth_requests/entra_id_authorization_url_request.dart';
export 'src/auth_requests/entra_id_azure_loopback_client.dart';
export 'src/auth_requests/entra_id_client_credential_request.dart';
export 'src/auth_requests/entra_id_device_code_request.dart';
export 'src/auth_requests/entra_id_interactive_request.dart';
export 'src/auth_requests/entra_id_on_behalf_of_request.dart';
export 'src/auth_requests/entra_id_refresh_token_request.dart';
export 'src/auth_requests/entra_id_silent_flow_request.dart';
export 'src/auth_requests/entra_id_username_password_request.dart';

// Authentication
export 'src/authentication/entra_id_auth_options.dart';
export 'src/authentication/entra_id_client_application.dart';
export 'src/authentication/entra_id_confidential_client.dart';
export 'src/authentication/entra_id_public_client.dart';

// Cache
export 'src/cache/entra_id_azure_json_cache.dart';
export 'src/cache/entra_id_cache_kv_store.dart';
export 'src/cache/entra_id_cache_options.dart';
export 'src/cache/entra_id_distributed_cache_plugin.dart';
export 'src/cache/entra_id_in_memory_cache.dart';
export 'src/cache/entra_id_token_cache.dart';

// Configuration
export 'src/config/entra_id_configuration.dart';
export 'src/config/entra_id_proxy_status.dart';
export 'src/config/entra_id_system_options.dart';
export 'src/config/entra_id_telemetry_options.dart';

// Crypto
export 'src/crypto/entra_id_client_assertion.dart';
export 'src/crypto/entra_id_crypto_provider.dart';
export 'src/crypto/entra_id_pkce_generator.dart';

// Enums
export 'src/enum/entra_id_app_enviroment_enum.dart';
export 'src/enum/entra_id_application_type_enum.dart';
export 'src/enum/entra_id_browser_type_enum.dart';
export 'src/enum/entra_id_cache_eviction_policy_enum.dart';
export 'src/enum/entra_id_cache_storage_type_enum.dart';
export 'src/enum/entra_id_client_application_eum.dart';
export 'src/enum/entra_id_confidential_client_enum.dart';
export 'src/enum/entra_id_device_code_request_enum.dart';
export 'src/enum/entra_id_http_method_enum.dart';
export 'src/enum/entra_id_interactive_request_enum.dart';
export 'src/enum/entra_id_token_type_enum.dart';

// Exceptions
export 'src/exception/entra_id_authorization_code_request_exception.dart';
export 'src/exception/entra_id_authorization_url_request_exception.dart';
export 'src/exception/entra_id_authorization_user_cancle_exception.dart';
export 'src/exception/entra_id_azure_json_cache_exception.dart';
export 'src/exception/entra_id_azure_loopback_client_exception.dart';
export 'src/exception/entra_id_client_application_exception.dart';
export 'src/exception/entra_id_device_code_request_exception.dart';
export 'src/exception/entra_id_interactive_request_exception.dart';
export 'src/exception/entra_id_on_behalf_of_request_exception.dart';
export 'src/exception/entra_id_serialized_access_token_exception.dart';
export 'src/exception/entra_id_serialized_app_metadata_exception.dart';
export 'src/exception/entra_id_serialized_id_token_exception.dart';
export 'src/exception/entra_id_serialized_refresh_token_exception.dart';
export 'src/exception/entra_id_silent_flow_request_exception.dart';
export 'src/exception/entra_id_token_cache_exception.dart';

// Interfaces
export 'src/interfaces/entra_id_i_cache_client.dart';
export 'src/interfaces/entra_id_i_partition_manager.dart';
export 'src/interfaces/entra_id_i_public_client_application.dart';
export 'src/interfaces/entra_id_i_token_cache.dart';

// Models
export 'src/model/entra_id_authorization_code_request_model.dart';
export 'src/model/entra_id_authorization_url_request_model.dart';
export 'src/model/entra_id_azure_loopback_client_model.dart';
export 'src/model/entra_id_cache_kv_store_model.dart';
export 'src/model/entra_id_device_code_request_model.dart';
export 'src/model/entra_id_device_code_response_model.dart';
export 'src/model/entra_id_distributed_cache_plugin_model.dart';
export 'src/model/entra_id_in_memory_cache_model.dart';
export 'src/model/entra_id_interactive_request_model.dart';
export 'src/model/entra_id_token_cache_model.dart';

// Serialization
export 'src/serialization/entra_id_deserializer.dart';
export 'src/serialization/entra_id_serialized_access_token.dart';
export 'src/serialization/entra_id_serialized_app_metadata.dart';
export 'src/serialization/entra_id_serialized_id_token.dart';
export 'src/serialization/entra_id_serialized_refresh_token.dart';
export 'src/serialization/entra_id_serializer.dart';

// Storage
export 'src/storage/entra_id_storage.dart';

// Utils
export 'src/utils/entra_id_encoding_utils.dart';
export 'src/utils/entra_id_guid_generator.dart';
export 'src/utils/entra_id_hash_utils.dart';
export 'src/utils/entra_id_network_utils.dart';

/// Version information
const String sdkVersion = '0.0.1-pre+1';
