/// MSME Pathways - Auth Result Model
///
/// Immutable data model for authentication operation results.
library;

import 'package:flutter/foundation.dart';

import 'user_model.dart';

/// Represents the result of an authentication operation.
///
/// Used for login, signup, and other auth responses.
@immutable
class AuthResultModel {
  /// Creates an auth result.
  const AuthResultModel({
    required this.success,
    this.user,
    this.token,
    this.refreshToken,
    this.errorMessage,
    this.errorCode,
  });

  /// Whether the operation was successful.
  final bool success;

  /// The authenticated user (if successful).
  final UserModel? user;

  /// Access token for authenticated requests.
  final String? token;

  /// Refresh token for token renewal.
  final String? refreshToken;

  /// Error message if operation failed.
  final String? errorMessage;

  /// Error code for programmatic handling.
  final String? errorCode;

  // ============================================================
  // FACTORY CONSTRUCTORS
  // ============================================================

  /// Creates a successful auth result.
  factory AuthResultModel.success({
    required UserModel user,
    required String token,
    String? refreshToken,
  }) {
    return AuthResultModel(
      success: true,
      user: user,
      token: token,
      refreshToken: refreshToken,
    );
  }

  /// Creates a failed auth result.
  factory AuthResultModel.failure({
    required String message,
    String? code,
  }) {
    return AuthResultModel(
      success: false,
      errorMessage: message,
      errorCode: code,
    );
  }

  /// Creates an error result from an exception.
  factory AuthResultModel.fromException(Exception e) {
    return AuthResultModel(
      success: false,
      errorMessage: e.toString(),
      errorCode: 'EXCEPTION',
    );
  }

  // ============================================================
  // JSON SERIALIZATION
  // ============================================================

  /// Creates an AuthResultModel from JSON.
  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      success: json['success'] as bool? ?? false,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      errorMessage: json['error_message'] as String?,
      errorCode: json['error_code'] as String?,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user': user?.toJson(),
      'token': token,
      'refresh_token': refreshToken,
      'error_message': errorMessage,
      'error_code': errorCode,
    };
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  /// Creates a copy with modified fields.
  AuthResultModel copyWith({
    bool? success,
    UserModel? user,
    String? token,
    String? refreshToken,
    String? errorMessage,
    String? errorCode,
  }) {
    return AuthResultModel(
      success: success ?? this.success,
      user: user ?? this.user,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  // ============================================================
  // EQUALITY
  // ============================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResultModel &&
        other.success == success &&
        other.user == user &&
        other.token == token &&
        other.refreshToken == refreshToken &&
        other.errorMessage == errorMessage &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode => Object.hash(
        success,
        user,
        token,
        refreshToken,
        errorMessage,
        errorCode,
      );

  @override
  String toString() =>
      'AuthResultModel(success: $success, user: ${user?.email}, error: $errorMessage)';
}
