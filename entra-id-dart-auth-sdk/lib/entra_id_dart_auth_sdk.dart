/// Microsoft Entra ID Authentication SDK for Dart
/// Provides authentication and authorization capabilities using Microsoft Entra ID
/// (formerly Azure Active Directory).
library;

export 'src/entra_auth.dart';
export 'src/auth/auth_entra_id_configuration.dart';
export 'src/auth/auth_crypto_provider.dart';
export 'src/auth/auth_entra_id_deserializer.dart';

// Version information
/// The version of the SDK.
///
/// This follows semantic versioning and indicates the current pre-release version.
const String sdkVersion = '0.0.1-pre+1';
