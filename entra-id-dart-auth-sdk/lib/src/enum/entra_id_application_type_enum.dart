/// Authentication types supported by the application
enum AuthenticationType {
  /// Single-tenant authentication
  singleTenant,

  /// Multi-tenant authentication
  multiTenant,

  /// Microsoft personal accounts
  personalMicrosoft,

  /// Both work/school and personal accounts
  mixed,
}
