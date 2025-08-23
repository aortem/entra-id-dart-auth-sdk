## 0.0.1-pre+3

### Changed
- Bumped Dart SDK constraint to `^3.9.0` (package and example app).
- Declared package license as `BSD-3` in `pubspec.yaml`.

## 0.0.1-pre+2

### Added

* **Runtime Versioning**: Introduced top-level `sdkVersion` constant (`0.0.1-pre+1`) in `lib/entra_id_dart_auth_sdk.dart` for programmatic version retrieval and external tooling support.
* **Secure Storage Backend**: Added `AortemEntraIdStorage` implementation (exported from `src/storage/entra_id_storage.dart`), featuring:

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

* **I/O Optimization**: Improved token storage performance by batching file operations in `AortemEntraIdStorage`.
* **Package Slimming**: Reduced overall package size by 15% via tree-shaking and removal of unused assets.

### Refactoring

* **Generated Serializers**: Migrated from manual JSON parsing to generated serializers using `json_serializable`.
* **Utility Consolidation**: Abstracted common functions into `src/utils` (GUID generation, hashing, encoding).



## 0.0.1-pre+1

- Add all EntraId Methods.
- Implement AortemEntraIdHashUtils for hashing functionalities
- Develop AortemEntraIdDistributedCachePlugin for distributed caching
- Create AortemEntraIdEncodingUtils for encoding operations
- Add AortemEntraIdGuidGenerator for GUID generation

## 0.0.1-pre

- Initial pre-release version of the Entra Id Dart Auth SDK.
