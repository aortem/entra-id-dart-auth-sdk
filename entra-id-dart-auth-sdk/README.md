# Entra Id Dart Auth SDK

## Overview

The **Entra Id Dart Auth SDK** provides first-class integration with Microsoft Entra ID (formerly Azure AD) authentication flows for both server-side Dart applications and Flutter clients. With this SDK you can:

* Acquire and manage OAuth 2.0 access & ID tokens
* Authenticate users via interactive, ROPC, and client credentials flows
* Handle token caching and automatic refresh
* Integrate with MSAL.js for Flutter web
* Use customizable secure storage backends
* Perform admin operations via Microsoft Graph tokens

Whether you’re building a Dart backend service or a Flutter mobile/web app, this SDK streamlines Entra ID authentication.

## Features

* **Unified Auth Flows**
  Support for authorization code (PKCE), resource owner password credential (ROPC), client credentials, and refresh token flows.
* **Token Management**
  Automatic token caching, expiration checks, and silent token refresh.
* **Secure Storage**
  Pluggable `TokenStorage` interface with built-in `AortemEntraIdStorage` (file, in-memory, or custom backends).
* **MSAL.js Integration (Web)**
  Leverage Microsoft’s MSAL.js library under the hood for Flutter web PKCE flows.
* **Graph API Support**
  Acquire on-behalf-of and Graph tokens, with helper methods for common scopes (User.Read, Mail.Send, etc.).
* **Platform-Agnostic**
  Works in Dart VM (server), Flutter mobile, and Flutter web environments.

## Getting Started

1. **Prerequisites**

   * Dart SDK ≥ 2.14.0 (for null-safety) or Flutter SDK ≥ 3.0
   * An Azure AD (Entra ID) tenant with an app registration configured for your chosen flow

2. **Configure Entra ID App**

   * Define redirect URIs (for web/mobile).
   * Create client secrets (for server flows).
   * Grant Graph API permissions and admin consent if needed.

## Installation

Add the SDK to your project:

```bash
# Dart:
dart pub add entra_id_dart_auth_sdk

# Flutter:
flutter pub add entra_id_dart_auth_sdk
```

Or manually in your `pubspec.yaml`:

```yaml
dependencies:
  entra_id_dart_auth_sdk: ^0.0.1
```

Then run:

```bash
dart pub get
```

## Usage

### Initialize the SDK

```dart
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';

void main() async {
  final auth = EntraIdAuth(
    tenantId: 'your-tenant-id',
    clientId: 'your-client-id',
    redirectUri: Uri.parse('com.example.app://auth'),
  );
}
```

### Authorization Code (PKCE) Flow

```dart
// Trigger interactive auth
final result = await auth.acquireTokenInteractive(
  scopes: ['User.Read', 'Mail.Send'],
);
print('Access Token: ${result.accessToken}');
```

### Client Credentials Flow (Server)

```dart
// Uses client secret from environment
final creds = ClientCredentials.fromEnv();
final authServer = EntraIdAuth.server(
  tenantId: 'your-tenant-id',
  clientCredentials: creds,
);

final token = await authServer.acquireTokenForClient(
  scopes: ['https://graph.microsoft.com/.default'],
);
print('Client Token: ${token.accessToken}');
```

### Token Storage & Refresh

```dart
// Use the default file-based storage
await auth.initStorage();

// Later, silently get a valid token
final cached = await auth.acquireTokenSilent(
  scopes: ['User.Read'],
);
```

## Advanced

* **Custom Storage**: Implement `TokenStorage` for secure database or keychain storage.
* **Graph Helpers**: Use `GraphClient` for easy requests:

  ```dart
  final graph = GraphClient(auth);
  final user = await graph.getCurrentUser();
  ```

## Documentation

For full API reference, examples, and migration guides, see our GitBook:

👉 [Entra Id Dart Auth SDK Docs](https://aortem.gitbook.io/entra-id-dart-auth-sdk/)
