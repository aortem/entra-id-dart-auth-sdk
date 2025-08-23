import 'package:entra_id_dart_auth_sdk/src/core/entra_id_configuration.dart';

void main() {
  // Test case 1: Successful initialization of configuration.
  final config1 = AortemEntraIdConfiguration.initialize(
    clientId: "test-client-id-1",
    tenantId: "test-tenant-id-1",
    authority: "https://login.microsoftonline.com/tenant-id-1",
    redirectUri: "com.example.app://redirect-1",
    enableLogging: true,
    cacheExpirationInSeconds: 1800,
  );

  // Validate configuration properties.
  assert(config1.clientId == "test-client-id-1", "Client ID does not match.");
  assert(config1.tenantId == "test-tenant-id-1", "Tenant ID does not match.");
  assert(
    config1.authority == "https://login.microsoftonline.com/tenant-id-1",
    "Authority does not match.",
  );
  assert(
    config1.redirectUri == "com.example.app://redirect-1",
    "Redirect URI does not match.",
  );
  assert(config1.enableLogging == true, "Logging should be enabled.");
  assert(
    config1.cacheExpirationInSeconds == 1800,
    "Cache expiration should be 1800 seconds.",
  );
  assert(
    AortemEntraIdConfiguration.isInitialized == true,
    "Configuration should be initialized.",
  );

  // Test case 2: Attempt to reinitialize (should not overwrite existing instance).
  final config2 = AortemEntraIdConfiguration.initialize(
    clientId: "test-client-id-2",
    tenantId: "test-tenant-id-2",
    authority: "https://login.microsoftonline.com/tenant-id-2",
    redirectUri: "com.example.app://redirect-2",
    enableLogging: false,
    cacheExpirationInSeconds: 3600,
  );

  // Ensure the original instance remains intact.
  assert(identical(config1, config2), "The same instance should be returned.");
  assert(
    config2.clientId == "test-client-id-1",
    "Client ID should remain as the first initialization.",
  );
  assert(
    config2.tenantId == "test-tenant-id-1",
    "Tenant ID should remain as the first initialization.",
  );
  assert(
    config2.authority == "https://login.microsoftonline.com/tenant-id-1",
    "Authority should remain as the first initialization.",
  );
  assert(
    config2.redirectUri == "com.example.app://redirect-1",
    "Redirect URI should remain as the first initialization.",
  );
  assert(
    config2.enableLogging == true,
    "Logging should remain as the first initialization.",
  );
  assert(
    config2.cacheExpirationInSeconds == 1800,
    "Cache expiration should remain as the first initialization.",
  );

  // Test case 3: Reset configuration and validate.
  AortemEntraIdConfiguration.reset();
  assert(
    AortemEntraIdConfiguration.isInitialized == false,
    "Configuration should be reset.",
  );

  // Test case 4: Reinitialize after reset.
  final config3 = AortemEntraIdConfiguration.initialize(
    clientId: "test-client-id-3",
    tenantId: "test-tenant-id-3",
    authority: "https://login.microsoftonline.com/tenant-id-3",
    redirectUri: "com.example.app://redirect-3",
    enableLogging: false,
    cacheExpirationInSeconds: 3600,
  );

  // Validate the new configuration properties.
  assert(
    config3.clientId == "test-client-id-3",
    "Client ID does not match after reset.",
  );
  assert(
    config3.tenantId == "test-tenant-id-3",
    "Tenant ID does not match after reset.",
  );
  assert(
    config3.authority == "https://login.microsoftonline.com/tenant-id-3",
    "Authority does not match after reset.",
  );
  assert(
    config3.redirectUri == "com.example.app://redirect-3",
    "Redirect URI does not match after reset.",
  );
  assert(
    config3.enableLogging == false,
    "Logging should be disabled after reset.",
  );
  assert(
    config3.cacheExpirationInSeconds == 3600,
    "Cache expiration should match after reset.",
  );
}
