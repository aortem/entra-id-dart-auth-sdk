/// Enum defining standard HTTP methods.
enum EntraIdHttpMethod {
  /// The HTTP GET method is used to retrieve data from a server.
  get,

  /// The HTTP POST method is used to send data to a server.
  post,

  /// The HTTP PUT method is used to update or create a resource.
  put,

  /// The HTTP DELETE method is used to delete a resource from a server.
  delete,

  /// The HTTP PATCH method is used to partially update a resource.
  patch,

  /// The HTTP HEAD method retrieves the headers of a resource without its body.
  head,

  /// The HTTP OPTIONS method describes the communication options for a resource.
  options,

  /// The HTTP TRACE method performs a diagnostic request for testing.
  trace,
}
