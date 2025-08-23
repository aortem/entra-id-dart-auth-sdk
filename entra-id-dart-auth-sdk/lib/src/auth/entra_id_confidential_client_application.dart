/// AortemEntraIdHttpStatus: Provides utilities for interpreting HTTP status codes.
class AortemEntraIdHttpStatus {
  /// Informational responses (100–199).
  /// Indicates that the request was received and the process is continuing.

  /// Status code for "Continue".
  static const int continue_ = 100;

  /// Status code for "Switching Protocols".
  static const int switchingProtocols = 101;

  /// Successful responses (200–299).
  /// Indicates that the request was successfully received, understood, and accepted.

  /// Status code for "OK".
  static const int ok = 200;

  /// Status code for "Created".
  static const int created = 201;

  /// Status code for "Accepted".
  static const int accepted = 202;

  /// Status code for "No Content".
  static const int noContent = 204;

  /// Client error responses (400–499).
  /// Indicates that the client seems to have made an error.

  /// Status code for "Bad Request".
  static const int badRequest = 400;

  /// Status code for "Unauthorized".
  static const int unauthorized = 401;

  /// Status code for "Forbidden".
  static const int forbidden = 403;

  /// Status code for "Not Found".
  static const int notFound = 404;

  /// Status code for "Conflict".
  static const int conflict = 409;

  /// Server error responses (500–599).
  /// Indicates that the server failed to fulfill a valid request.

  /// Status code for "Internal Server Error".
  static const int internalServerError = 500;

  /// Status code for "Not Implemented".
  static const int notImplemented = 501;

  /// Status code for "Bad Gateway".
  static const int badGateway = 502;

  /// Status code for "Service Unavailable".
  static const int serviceUnavailable = 503;

  /// Check if the status code indicates success.
  ///
  /// Returns `true` if the status code is between 200 and 299.
  ///
  /// - [statusCode]: The HTTP status code to check.
  static bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if the status code indicates a client error.
  ///
  /// Returns `true` if the status code is between 400 and 499.
  ///
  /// - [statusCode]: The HTTP status code to check.
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if the status code indicates a server error.
  ///
  /// Returns `true` if the status code is 500 or higher.
  ///
  /// - [statusCode]: The HTTP status code to check.
  static bool isServerError(int statusCode) {
    return statusCode >= 500;
  }

  /// Get a description for the status code.
  ///
  /// Returns a string description of the provided HTTP status code.
  ///
  /// - [statusCode]: The HTTP status code to describe.
  static String getDescription(int statusCode) {
    switch (statusCode) {
      case continue_:
        return 'Continue';
      case switchingProtocols:
        return 'Switching Protocols';
      case ok:
        return 'OK';
      case created:
        return 'Created';
      case accepted:
        return 'Accepted';
      case noContent:
        return 'No Content';
      case badRequest:
        return 'Bad Request';
      case unauthorized:
        return 'Unauthorized';
      case forbidden:
        return 'Forbidden';
      case notFound:
        return 'Not Found';
      case conflict:
        return 'Conflict';
      case internalServerError:
        return 'Internal Server Error';
      case notImplemented:
        return 'Not Implemented';
      case badGateway:
        return 'Bad Gateway';
      case serviceUnavailable:
        return 'Service Unavailable';
      default:
        return 'Unknown Status Code';
    }
  }
}
