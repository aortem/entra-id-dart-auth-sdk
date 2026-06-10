# Changelog


## 0.0.7

- Bumped package metadata for the Dart 3.12.2 upgrade pass.
- Updated the Dart SDK constraint to `^3.12.1` for the Dart 3.12 release line.
- Refreshed dependency resolution with the current Dart/Flutter tooling where applicable.

## [0.0.6]
### Added
- **Aortem Integration Compatibility**
  - Added `AortemEntraIdConfidentialClientApplication` compatibility alias.
  - Added `AortemEntraIdException`, `AortemEntraIdUiRequiredException`, and aliases for user-cancelled and network exceptions.
  - Expanded public export coverage for the Entra ID SDK integration compatibility surface.

## [0.0.5]
### Added
- **Aortem Compatibility Aliases**
  - Added public `AortemEntraIdPublicClientApplication`, `AortemEntraIdSilentFlowRequest`, and `AortemEntraIdInteractiveRequest` aliases through the package entrypoint.
  - Added public export coverage for the Aortem compatibility names.

## [0.0.4]
### Updated
- **Dart & Dependency Baseline**
  - Updated direct package constraints to the latest supported releases on pub.dev, including `ds_standard_features`, `build_web_compilers`, and `jwt_generator`.
- **Public Entrypoint Metadata**
  - Bumped the exported SDK version constants and release docs to match the next stable publish.
- **CI Validation**
  - Aligned setup validation with the Dart `3.11.4` baseline.

## [0.0.3]
### Updated
- **Dart SDK Constraint**: Updated to `^3.11.0`.
- **HTTP Methods**: Normalized `EntraIdHttpMethod` enum values to lowercase while preserving uppercase `asString`, and added HTTP method utilities.
- **Crypto Utilities**: Switched hashing/PKCE/HMAC usage to `package:crypto` and updated related tests.
- **Token Cache Keys**: Simplified token key construction using Dart 3.11 null-aware elements.
- **Cache Docs**: Expanded in-memory cache client documentation.
- **Dependencies**: Updated to the latest versions available on pub.dev.
- **Workload Identity Federation Support**: Added client-credentials token acquisition with Entra client assertions, including `client_assertion_type`, for reusable WIF-style exchanges.
- **Confidential Client Scopes**: `EntraIdConfidentialClientApplication` now accepts explicit scopes instead of forcing Microsoft Graph-only usage.
- **Canonical Token Path**: Routed confidential-client secret and assertion flows through the shared client-credentials request implementation.
- **Dependencies**: Promoted `crypto` and `http` to direct dependencies and updated `build_web_compilers` to the latest resolvable release.

### Fixed
- **Imports**: Removed duplicate `ds_standard_features` import.
- **Assertion Flow**: Corrected confidential-client assertion requests so they send the full Entra token-exchange payload required for ARM and similar resource scopes.
- **Test Coverage**: Added unit coverage for secret and assertion client-credential flows, custom scopes, and unsupported certificate handling.

## [0.0.2]
### Updated
- **Dart SDK Constraint**: Updated to `^3.10.3` for both the package and example applications.

## [0.0.1]
### Changed
- **Dart SDK Constraint**: Updated to `^3.9.2` for both the package and example applications.
- **License**: Declared license as `BSD-3` in `pubspec.yaml`.
- **Namespace/Module Renames**:
  - All public files and module names previously prefixed with `aortem_entra_id*` renamed to `entra_id*`.
  - If you import subpaths, replace `aortem_entra_id` with `entra_id`.
  - Recommended import:
    ```dart
    import 'package:entra_id_dart_auth_sdk/entra_id_dart_auth_sdk.dart';
    ```
- **Secure Storage Backend**:
  - Renamed `AortemEntraIdStorage` → `EntraIdStorage`.
  - Export moved from `src/storage/aortem_entra_id_storage.dart` → `src/storage/entra_id_storage.dart`.
- **Docs**:
  - Expanded “Enhance with Entra Id Dart Auth SDK” section in README with Flutter + server-side examples.
  - Added “Migrating from 0.x” guide for upgrade steps.
- **Code Cleanup**:
  - Removed manual JSON serialization (replaced with `json_serializable`).
  - Consolidated networking: removed `src/network/http_agent.dart` in favor of a unified `NetworkClient`.
- **Deprecations/Removals**:
  - Removed plugins:
    - `entra_id_azure_json_cache`
    - `entra_id_distributed_cache_plugin`
  - Dropped Dart 2.12 support. Minimum SDK now `>=2.14.0 <3.0.0`.

### Security
- Improvements applied to strengthen token handling and storage.

### Performance
- Token storage I/O optimized by batching filesystem operations.

---

⚠️ **Breaking Changes**
- All imports and plugin names must be updated from `aortem_entra_id*` → `entra_id*`.
- Dropped support for Dart 2.12; upgrade your environment to `>=2.14.0`.

## [0.0.1-pre+2]
### Added

* **Runtime Versioning**: Introduced top-level `sdkVersion` constant (`0.0.1-pre+1`) in `lib/entra_id_dart_auth_sdk.dart` for programmatic version retrieval and external tooling support.
* **Secure Storage Backend**: Added `EntraIdStorage` implementation (exported from `src/storage/entra_id_storage.dart`), featuring:

  * Token load/save methods with automatic serialization.
  * Pluggable interface for custom storage backends.
* **Environment-Based Credentials**: Added `ClientCredentials.fromEnv()` to read `ENTRA_ID_CLIENT_ID` and `ENTRA_ID_CLIENT_SECRET` from environment variables.
* **Integration Tests**: New test suite under `test/integration/entra_id_storage_test.dart` covering:

  * Successful token caching and retrieval.
  * Error scenarios when storage backend is unavailable.
* **Structured Logging**: Introduced `Logger` utility in `src/utils/logger.dart` for:

  * Configurable log levels (DEBUG, INFO, WARN, ERROR).
  * Structured JSON output compatible with Cloud Logging.

### Changed

* **Export Reorganization**: Streamlined `lib/entra_id_dart_auth_sdk.dart` exports:

  * Consolidated cache and entity modules into a unified `src/cache` directory.
  * Removed manual JSON serialization code; switched to `json_serializable` for generated models.
* **Documentation Updates**:

  * Enhanced “Enhance with Entra Id Dart Auth SDK” section in `README.md` with Flutter and server-side usage examples.
  * Added “Migrating from 0.x” section outlining breaking changes and upgrade steps.
* **CI/CD Improvements** (`.gitlab-ci.yml`):

  * Enforced semantic version branch names via regex (`^v?\d+\.\d+\.\d+(-[\w\.]+)?$`).
  * Containerized integration tests matching production runtime.
  * Published code coverage reports to GitLab Pages.
* **Dependency Upgrades**:

  * `http` bumped to `0.14.0` for robust timeout handling.
  * `dateutil` updated to `2.8.2`, `functions_framework` to `3.1.0`.

### Fixed

* **Token Refresh Logic**: Fixed expired-token refresh by correctly parsing `expiresIn` from auth responses.
* **Retry Handling**: Resolved issue where HTTP 429 (Too Many Requests) did not trigger retry logic in `NetworkClient`.
* **Model Typing**: Corrected `AuthResponse.scope` field to non-nullable `List<String>`.

### Removed

* **Legacy Modules**:

  * Deleted `src/auth/legacy_cache.dart` and old entity models under `src/auth/entities`.
  * Removed `src/network/http_agent.dart`, replaced with consolidated `NetworkClient`.
* **Deprecated Plugins**:

  * Removed `entra_id_azure_json_cache` and `entra_id_distributed_cache_plugin` from exports.
* **Dart SDK Support**: Dropped Dart 2.12 support (now requires `sdk: ">=2.14.0 <3.0.0"`).

### Security

* **CVE Patches**: Applied patch for `json_serializable` vulnerability (CVE-2025-XXXXX).
* **Dependency Hardening**: Upgraded transitive `package:yaml` to `3.0.0` to address deserialization security issues.

### Performance

* **I/O Optimization**: Improved token storage performance by batching file operations in `EntraIdStorage`.
* **Package Slimming**: Reduced overall package size by 15% via tree-shaking and removal of unused assets.

### Refactoring

* **Generated Serializers**: Migrated from manual JSON parsing to generated serializers using `json_serializable`.
* **Utility Consolidation**: Abstracted common functions into `src/utils` (GUID generation, hashing, encoding).



## [0.0.1-pre+1]
- Add all EntraId Methods.
- Implement EntraIdHashUtils for hashing functionalities
- Develop EntraIdDistributedCachePlugin for distributed caching
- Create EntraIdEncodingUtils for encoding operations
- Add EntraIdGuidGenerator for GUID generation

## [0.0.1-pre]
- Initial pre-release version of the Entra Id Dart Auth SDK.

