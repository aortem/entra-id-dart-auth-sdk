<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">entra_id_dart_auth_sdk</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/entra_id_dart_auth_sdk/tags">
    <img alt="Release" src="https://img.shields.io/static/v1?label=release&message=v0.0.1-pre+10&color=blue&style=for-the-badge" />
  </a>
  <br/>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/entra_id_dart_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/entra_id_dart_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
 <!-- Firebase Badge -->
   <a href="https://firebase.google.com/docs/reference/admin/node/firebase-admin.auth?_gl=1*1ewipg9*_up*MQ..*_ga*NTUxNzc0Mzk3LjE3MzMxMzk3Mjk.*_ga_CW55HF8NVT*MTczMzEzOTcyOS4xLjAuMTczMzEzOTcyOS4wLjAuMA..">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
<!-- Pipeline Badge -->
<a href="https://github.com/aortem/entra_id_dart_auth_sdk/actions">
  <img alt="Pipeline Status" src="https://img.shields.io/github/actions/workflow/status/aortem/entra_id_dart_auth_sdk/dart-analysis.yml?branch=main&label=pipeline&style=for-the-badge" />
</a>
<!-- Code Coverage Badges -->
  </a>
  <a href="https://codecov.io/gh/open-feature/dart-server-sdk">
    <img alt="Code Coverage" src="https://codecov.io/gh/open-feature/dart-server-sdk/branch/main/graph/badge.svg?token=FZ17BHNSU5" />
<!-- Open Source Badge -->
  </a>
  <a href="https://bestpractices.coreinfrastructure.org/projects/6601">
    <img alt="CII Best Practices" src="https://bestpractices.coreinfrastructure.org/projects/6601/badge?style=for-the-badge" />
  </a>
</p>
<!-- x-hide-in-docs-start -->

# Entra Id Dart Auth SDK

The Entra ID Dart Auth SDK is designed to enable seamless integration with Microsoft Entra ID (formerly Azure AD) for Dart developers. It provides both low-level and high-level abstractions to support a wide variety of authentication and authorization scenarios.

## Features
This implementation provides critical functionalities to authenticate and manage users in Microsoft Entra ID. These features include support for OAuth2 flows, token management, and multi-tenant environments.
---

## **Feature Comparison Chart**


| Feature                                | Description                                            | Supported | Notes                                                                                   |
|----------------------------------------|--------------------------------------------------------|-----------|-----------------------------------------------------------------------------------------|
| **AortemAzureApiId**                   | Identifies API endpoints for authentication.          | ✅         | Centralized management of API identifiers.                                              |
| **AortemAzureAuthorizationCodeRequest**| Handles authorization code flow for OAuth2.           | ✅         | Core to enabling secure authorization flows.                                            |
| **AortemAzureAuthorizationUrlRequest** | Builds URLs for authorization requests.               | ✅         | Helps construct valid URLs for redirect-based flows.                                    |
| **AortemAzureCacheKVStore**            | Provides a key-value store for caching.               | ✅         | Supports efficient data caching for tokens and configurations.                         |
| **AortemAzureCacheOptions**            | Configures cache behavior and settings.               | ✅         | Allows flexibility in how cache is managed.                                             |
| **AortemAzureClientApplication**       | Represents the client application using the SDK.      | ✅         | Serves as the entry point for SDK integration.                                          |
| **AortemAzureClientAssertion**         | Supports client assertion flows for secure tokens.    | ✅         | Designed for apps requiring high-security authentication.                              |
| **AortemAzureClientCredentialRequest** | Handles client credential-based authentication flows. | ✅         | Simplifies the acquisition of access tokens using client credentials.                  |
| **AortemAzureConfidentialClientApplication** | Manages client credentials for confidential applications. | ✅         | Ensures secure operations for apps with client secrets.                                |
| **AortemAzurePublicClientApplication**      | Supports user-based flows for public applications.        | ✅         | Useful for applications without secure client secret storage.                          |
| **AortemAzureAuthOptions**                  | Configures authentication options for flexibility.        | ✅         | Provides developers with a configurable authentication setup.                          |
| **AortemAzureConfiguration**               | Manages global SDK configurations.                       | ✅         | Handles tenant IDs, endpoints, and other global settings.                              |
| **AortemAzureInteractiveRequest**          | Handles user-based interactive authentication.            | ✅         | Enables user interaction for login via redirect or browser flows.                      |
| **AortemAzureSilentFlowRequest**           | Acquires tokens silently using cached credentials.        | ✅         | Improves performance by avoiding repeated login prompts.                               |
| **AortemAzureTokenCache**                  | Handles token storage and retrieval.                      | ✅         | Centralized token cache for reuse across SDK components.                               |
| **AortemAzureInMemoryCache**               | Provides in-memory caching for fast token access.         | ✅         | Recommended for single-instance applications with predictable memory constraints.      |
| **AortemAzureJsonCache**                   | Stores tokens in a structured JSON format.                | ✅         | Ensures compatibility with external storage or APIs that require JSON.                |
| **AortemAzureSerializedAccessTokenEntity** | Represents serialized access tokens for storage.          | ✅         | Designed for efficient token storage and retrieval.                                    |
| **AortemAzureSerializedRefreshTokenEntity** | Manages serialized refresh tokens for token renewal.      | ✅         | Helps ensure smooth token renewal workflows.                                           |
| **AortemAzureSerializedAppMetadataEntity** | Stores application-specific metadata.                     | ✅         | Keeps metadata for application-specific configurations or states.                     |
| **AortemAzureHttpClient**                  | Makes HTTP requests for authentication workflows.          | ✅         | Streamlines HTTP operations for token acquisition and API calls.                      |
| **AortemAzureHttpMethod**                  | Defines HTTP methods (GET, POST, etc.).                   | ✅         | Simplifies request method selection across the SDK.                                    |
| **AortemAzureHttpStatus**                  | Manages HTTP status codes and error handling.              | ✅         | Standardizes HTTP response handling and improves error clarity.                       |
| **AortemAzureNetworkUtils**                | Provides utilities for network checks and retries.         | ✅         | Helps manage connectivity and ensures reliability through retries.                    |
| **AortemAzureProxyStatus**                 | Handles proxy-related configurations and statuses.         | ✅         | Allows integration with proxy configurations where required.                          |
| **AortemAzureCryptoProvider**              | Performs cryptographic operations like hashing.            | ✅         | Ensures secure data transmission and token management.                                |
| **AortemAzurePkceGenerator**               | Generates PKCE codes for enhanced OAuth security.          | ✅         | Supports secure authorization code flows in compliance with OAuth2.                   |
| **AortemAzureGuidGenerator**               | Generates globally unique identifiers.                     | ✅         | Provides UUID generation for session or correlation tracking.                         |
| **AortemAzureHashUtils**                   | Provides hashing utilities for secure operations.          | ✅         | Enables secure and consistent hashing for sensitive data.                             |
| **AortemAzureEncodingUtils**               | Handles encoding and decoding tasks.                       | ✅         | Facilitates base64 and other encoding operations for data handling.                   |
| **AortemAzureSerializer**                  | Serializes objects for storage and transmission.           | ✅         | Converts data into a transferable format.                                             |
| **AortemAzureDeserializer**                | Deserializes objects into usable formats.                  | ✅         | Converts stored or transmitted data back to its original structure.                   |
| **AortemAzureStorage**                     | Handles storage-specific configurations.                   | ✅         | Allows developers to define custom storage settings.                                  |
| **AortemAzureSystemOptions**               | Manages system-wide settings for the SDK.                  | ✅         | Governs operational configurations and environmental options.                         |
| **AortemAzureTelemetryOptions**            | Configures telemetry for SDK performance tracking.         | ✅         | Enables monitoring and debugging via detailed telemetry data.                         |
| **AortemAzureIPartitionManager**           | Manages token partitioning for multi-tenant scenarios.     | ✅         | Ensures secure and logical separation of tenant-specific data.                        |
| **AortemAzureDeviceCodeRequest**           | Handles device code-based authentication flows.            | ✅         | Simplifies login on devices without browsers (e.g., smart TVs).                       |
| **AortemAzureLoopbackClient**              | Provides a localhost HTTP server for redirects.            | ✅         | Facilitates local redirection during authentication workflows.                       |
| **AortemAzureClientCredentialRequest**     | Acquires tokens for applications via client credentials.   | ✅         | Simplifies access token retrieval for app-only flows.                                |
| **AortemAzureDistributedCachePlugin**      | Supports distributed caching strategies.                   | ✅         | Ensures scalability in cloud or multi-server environments.                           |
| **AortemAzureAuthorizationCodeRequest**    | Handles OAuth2 authorization code grant flows.             | ✅         | Core to enabling secure, standards-compliant authentication flows.                   |
| **AortemAzureInteractiveRequest**          | Manages browser-based interactive logins.                  | ✅         | Provides user interaction for login with redirects.                                  |

---

## Available Versions

The SDK is available in two versions to cater to different needs:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Pre-Release - Edge Version**: Provided as an early indication of a release when breaking changes are expect.  This release is inconsistent. Use only if you are looking to test new features.

## Documentation

For detailed guides, API references, and example projects, visit our [Entra ID Dart Auth SDK Documentation](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk). Start building with  Microsoft Entra Id today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Firebase Dart Admin Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Firebase Dart Admin Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support

For support across all Aortem open-source products, including this SDK, visit our Support Page.

## Licensing

The **EntraID Dart Auth SDK** is licensed under a dual-license approach:

1. **BSD-3 License**:
   - Applies to all packages and libraries in the SDK.
   - Allows use, modification, and redistribution, provided that credit is given and compliance with the BSD-3 terms is maintained.
   - Permits usage in open-source projects, applications, and private deployments.

2. **Enhanced License Version 2 (ELv2)**:
   - Applies to all use cases where the SDK or its derivatives are offered as part of a **cloud service**.
   - This ensures that the SDK cannot be directly used by cloud providers to offer competing services without explicit permission.
   - Example restricted use cases:
     - Including the SDK in a hosted SaaS authentication platform.
     - Offering the SDK as a component of a managed cloud service.

### **Summary**
- You are free to use the SDK in your applications, including open-source and commercial projects, as long as the SDK is not directly offered as part of a third-party cloud service.
- For details, refer to the [LICENSE](LICENSE.md) file.


## Enhance with Entra ID Dart Auth SDK

We hope the Entra Id Dart Admin Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!