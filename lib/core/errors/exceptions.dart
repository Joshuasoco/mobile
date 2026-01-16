/// MSME Pathways - Custom Exceptions
///
/// Typed exception classes for proper error handling
/// throughout the application.
library;

/// Base exception for all app-specific exceptions.
abstract class AppException implements Exception {
  const AppException(this.message, [this.code]);

  /// Human-readable error message.
  final String message;

  /// Optional error code for programmatic handling.
  final String? code;

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown during authentication operations.
///
/// Used for login, signup, logout, and token-related errors.
class AuthException extends AppException {
  const AuthException(super.message, [super.code]);

  /// Invalid credentials provided.
  factory AuthException.invalidCredentials() =>
      const AuthException('Invalid email or password', 'INVALID_CREDENTIALS');

  /// User not found.
  factory AuthException.userNotFound() =>
      const AuthException('User not found', 'USER_NOT_FOUND');

  /// Email already registered.
  factory AuthException.emailAlreadyExists() =>
      const AuthException('Email is already registered', 'EMAIL_EXISTS');

  /// Session expired.
  factory AuthException.sessionExpired() =>
      const AuthException('Your session has expired. Please log in again.', 'SESSION_EXPIRED');

  /// Account locked.
  factory AuthException.accountLocked() =>
      const AuthException('Account is locked. Please contact support.', 'ACCOUNT_LOCKED');

  /// Generic auth failure.
  factory AuthException.unknown() =>
      const AuthException('Authentication failed. Please try again.', 'AUTH_UNKNOWN');

  @override
  String toString() => 'AuthException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown during input validation.
///
/// Used when form fields or data don't meet requirements.
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);

  /// The field that failed validation.
  String? get field => code;

  /// Invalid email format.
  factory ValidationException.invalidEmail() =>
      const ValidationException('Please enter a valid email address', 'email');

  /// Password too short.
  factory ValidationException.weakPassword() =>
      const ValidationException('Password must be at least 6 characters', 'password');

  /// Passwords don't match.
  factory ValidationException.passwordMismatch() =>
      const ValidationException('Passwords do not match', 'confirmPassword');

  /// Required field missing.
  factory ValidationException.required(String fieldName) =>
      ValidationException('$fieldName is required', fieldName.toLowerCase());

  @override
  String toString() => 'ValidationException: $message${code != null ? ' (field: $code)' : ''}';
}

/// Exception thrown during network operations.
///
/// Used for API calls, connectivity issues, and timeouts.
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);

  /// HTTP status code if available.
  final int? statusCode = null;

  /// No internet connection.
  factory NetworkException.noConnection() =>
      const NetworkException('No internet connection. Please check your network.', 'NO_CONNECTION');

  /// Request timed out.
  factory NetworkException.timeout() =>
      const NetworkException('Request timed out. Please try again.', 'TIMEOUT');

  /// Server error (5xx).
  factory NetworkException.serverError() =>
      const NetworkException('Server error. Please try again later.', 'SERVER_ERROR');

  /// Bad request (4xx).
  factory NetworkException.badRequest([String? details]) =>
      NetworkException(details ?? 'Invalid request. Please try again.', 'BAD_REQUEST');

  /// Generic network failure.
  factory NetworkException.unknown() =>
      const NetworkException('Network error. Please try again.', 'NETWORK_UNKNOWN');

  @override
  String toString() => 'NetworkException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown during storage operations.
///
/// Used for SharedPreferences, file I/O, and database errors.
class StorageException extends AppException {
  const StorageException(super.message, [super.code]);

  /// Failed to read data.
  factory StorageException.readFailed(String key) =>
      StorageException('Failed to read data for key: $key', 'READ_FAILED');

  /// Failed to write data.
  factory StorageException.writeFailed(String key) =>
      StorageException('Failed to write data for key: $key', 'WRITE_FAILED');

  /// Storage not initialized.
  factory StorageException.notInitialized() =>
      const StorageException('Storage not initialized', 'NOT_INITIALIZED');

  @override
  String toString() => 'StorageException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown during OTP verification.
class OTPException extends AppException {
  const OTPException(super.message, [super.code]);

  /// Invalid OTP entered.
  factory OTPException.invalid() =>
      const OTPException('Invalid OTP. Please check and try again.', 'INVALID_OTP');

  /// OTP has expired.
  factory OTPException.expired() =>
      const OTPException('OTP has expired. Please request a new one.', 'OTP_EXPIRED');

  /// Too many attempts.
  factory OTPException.tooManyAttempts() =>
      const OTPException('Too many attempts. Please try again later.', 'TOO_MANY_ATTEMPTS');

  @override
  String toString() => 'OTPException: $message${code != null ? ' (code: $code)' : ''}';
}
