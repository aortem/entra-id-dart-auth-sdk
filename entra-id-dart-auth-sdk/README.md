# Entra Id Dart Auth SDK

Entra Id Dart Auth SDK provides Dart-first building blocks for Microsoft Entra ID authentication flows, token handling, caching, and request utilities. The package currently exposes low-level and mid-level APIs for confidential-client flows, authorization URL generation, serialization, HTTP helpers, and cache primitives.

## Features

The package does not yet provide a fully complete Entra ID surface. The table below reflects the current exported SDK behavior.

| Capability | Status | Notes |
| --- | --- | --- |
| Configuration via `EntraIdConfiguration` | Supported | Shared SDK configuration object. |
| HTTP method and status helpers | Supported | Includes `GET`, `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`, and `HEAD`. |
| HTTP client wrapper | Supported | Request helpers available through `EntraIdHttpClient`. |
| Client credentials with client secret | Supported | Available through `EntraIdClientCredentialRequest` and `EntraIdConfidentialClientApplication`. |
| Client credentials with client assertion | Supported | Assertion-based token exchange is supported. |
| Client credentials with certificate | Not supported | `EntraIdConfidentialClientApplication` currently throws `UnsupportedError` for certificate credentials. |
| Refresh token request | Supported | Available through `EntraIdRefreshTokenRequest`. |
| Authorization URL generation | Supported | Available through `EntraIdAuthorizationUrlRequest`. |
| Interactive request orchestration | Partial | URL generation and callback validation exist, but the full interactive token exchange is not complete. |
| Public client application | Partial | Class is exported, but current token methods still use placeholder return values. |
| Silent flow request | Partial | Cache lookup exists, but refresh behavior still needs hardening. |
| Device code flow | Partial | Request/response helpers exist, but polling/token acquisition is not fully implemented. |
| On-behalf-of flow | Not supported | `EntraIdOnBehalfOfRequest` is exported but token exchange is not yet implemented. |
| Token cache abstractions | Supported | Includes cache store, cache options, token cache base class, and in-memory token cache. |
| Serialization entities and serializer | Supported | Access token, refresh token, ID token, app metadata, serializer, and deserializer are exported. |
| Utility helpers | Supported | Includes encoding, GUID generation, hashing, and network retry helpers. |

## Installation

Add the package to your project:

```bash
dart pub add entra_id_dart_auth_sdk
```

Or add it manually to `pubspec.yaml`:

```yaml
dependencies:
  entra_id_dart_auth_sdk: ^0.0.4
```

Then install dependencies:

```bash
dart pub get
```

## Getting Started

Import the package:

```dart
import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';
```

Create shared configuration:

```dart
final config = EntraIdConfiguration.initialize(
  clientId: 'your-client-id',
  tenantId: 'your-tenant-id',
  authority: 'https://login.microsoftonline.com',
  redirectUri: 'https://localhost:3000/auth/callback',
);
```

## Examples

### Client Credentials Flow With Client Secret

```dart
final request = EntraIdClientCredentialRequest(
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  authority: 'https://login.microsoftonline.com',
  tenantId: 'your-tenant-id',
  scopes: const ['https://graph.microsoft.com/.default'],
);

final token = await request.acquireToken();
print(token['access_token']);
```

### Client Credentials Flow With Client Assertion

```dart
final request = EntraIdClientCredentialRequest.assertion(
  clientId: 'your-client-id',
  clientAssertion: 'signed-jwt-assertion',
  authority: 'https://login.microsoftonline.com',
  tenantId: 'your-tenant-id',
  scopes: const ['https://management.azure.com/.default'],
);

final token = await request.acquireToken();
print(token['access_token']);
```

### Confidential Client Application Wrapper

```dart
final app = EntraIdConfidentialClientApplication(
  clientId: 'your-client-id',
  authority: 'https://login.microsoftonline.com/your-tenant-id',
  credential: 'your-client-secret',
  scopes: const ['https://graph.microsoft.com/.default'],
);

final token = await app.acquireToken();
print(token['access_token']);
```

### Build An Authorization URL

```dart
final urlRequest = EntraIdAuthorizationUrlRequest(
  authorityUrl:
      'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
  parameters: AuthorizationUrlRequestParameters(
    clientId: 'your-client-id',
    redirectUri: 'https://localhost:3000/auth/callback',
    scopes: const ['openid', 'profile', 'offline_access'],
  ),
);

final authorizationUrl = urlRequest.buildUrl();
print(authorizationUrl);
```

### Refresh A Token

```dart
final refreshRequest = EntraIdRefreshTokenRequest(
  refreshToken: 'existing-refresh-token',
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  tokenEndpoint:
      'https://login.microsoftonline.com/your-tenant-id/oauth2/v2.0/token',
);

final refreshed = await refreshRequest.refresh();
print(refreshed['access_token']);
```

### Cache Arbitrary Token Data

```dart
final cache = EntraIdCacheKVStore(
  EntraIdCacheOptions(namespace: 'entra-id-demo'),
);

await cache.set('graph-token', {
  'access_token': 'token-value',
  'expires_in': 3600,
});

final cachedToken = await cache.get('graph-token');
print(cachedToken);
```

## Current Limitations

- Do not rely on `EntraIdPublicClientApplication` for production interactive or device-code flows yet; those methods still return placeholder values.
- Do not rely on `EntraIdOnBehalfOfRequest` yet; the token exchange path is not implemented.
- Do not use certificate credentials with `EntraIdConfidentialClientApplication` yet; only secret and assertion flows are currently usable.
- Treat the interactive, silent, and device-code helpers as partial building blocks until the remaining flow logic is completed.

## Available Versions / Sample Apps

Entra Id Dart Auth SDK is currently published as a single package version. The repository also contains sample app placeholders under `/example` for future end-to-end flow validation across Dart, Flutter, and web scenarios.

## Documentation

For detailed guides, API references, and migration notes, visit the GitBook documentation:

[Entra Id Dart Auth SDK Documentation](https://aortem.gitbook.io/entra-id-dart-auth-sdk/)

## Examples Directory

Explore the `/example` directory in this repository for package integration scaffolding and sample-app placeholders.

## Contributing

Contributions are welcome. If you want to improve the SDK, open an issue or submit a pull request against this repository.

## Support

For support across Aortem open-source products, visit [Aortem Support](https://aortem.io/support).

## Licensing

This package is licensed under the BSD-3 license. See [LICENSE](LICENSE) for details.
