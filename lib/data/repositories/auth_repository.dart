/// MSME Pathways - Auth Repository
///
/// Repository for authentication operations including login,
/// signup, password reset, and session management.
library;

import 'package:flutter/foundation.dart';

import '../../core/errors/exceptions.dart';
import '../../core/services/app_state_service.dart';
import '../../core/services/storage_service.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

/// Storage keys for auth data.
abstract final class _AuthStorageKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String rememberMe = 'remember_me';
}

/// Abstract interface for authentication operations.
///
/// Enables dependency injection and mocking for tests.
abstract class IAuthRepository {
  /// Authenticates a user with email and password.
  Future<AuthResultModel> login(String email, String password);

  /// Creates a new user account.
  Future<AuthResultModel> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Sends OTP to email for password reset.
  Future<bool> sendPasswordResetOTP(String email);

  /// Verifies the OTP code.
  Future<bool> verifyOTP(String email, String otp);

  /// Resets password with new password.
  Future<bool> resetPassword(String email, String newPassword);

  /// Logs out the current user.
  Future<void> logout();

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn();

  /// Gets the current auth token if available.
  Future<String?> getAuthToken();

  /// Gets the currently logged in user.
  Future<UserModel?> getCurrentUser();

  /// Refreshes the auth token.
  Future<bool> refreshAuthToken();

  /// Saves remember me preference.
  Future<void> setRememberMe(bool value);

  /// Gets remember me preference.
  Future<bool> getRememberMe();
}

/// Mock implementation of [IAuthRepository].
///
/// Simulates authentication operations for development and testing.
/// Replace with real API implementation when backend is ready.
class AuthRepository implements IAuthRepository {
  AuthRepository({
    IStorageService? storageService,
    AppStateService? appStateService,
  })  : _storageService = storageService ?? StorageService(),
        _appStateService = appStateService ?? AppStateService();

  final IStorageService _storageService;
  final AppStateService _appStateService;

  // Simulated delay for async operations
  static const _simulatedDelay = Duration(milliseconds: 800);

  @override
  Future<AuthResultModel> login(String email, String password) async {
    await Future.delayed(_simulatedDelay);

    try {
      // Validation
      if (email.isEmpty || password.isEmpty) {
        throw AuthException.invalidCredentials();
      }

      // TODO: Replace with actual API call
      // Simulate successful login
      if (password.length >= 6) {
        final user = UserModel(
          id: 'user-${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          name: _extractNameFromEmail(email),
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        const token = 'mock-jwt-token-${1234567890}';
        const refreshToken = 'mock-refresh-token-${1234567890}';

        // Save auth data
        await _saveAuthData(user, token, refreshToken);

        // Update app state
        await _appStateService.setAuthToken(token, userId: user.id);

        debugPrint('AuthRepository: Login successful for ${user.email}');

        return AuthResultModel.success(
          user: user,
          token: token,
          refreshToken: refreshToken,
        );
      } else {
        throw AuthException.invalidCredentials();
      }
    } on AuthException catch (e) {
      return AuthResultModel.failure(message: e.message, code: e.code);
    } catch (e) {
      debugPrint('AuthRepository: Login error - $e');
      return AuthResultModel.failure(
        message: 'Login failed. Please try again.',
        code: 'LOGIN_ERROR',
      );
    }
  }

  @override
  Future<AuthResultModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(_simulatedDelay);

    try {
      // Validation
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw ValidationException.required('All fields');
      }

      if (password.length < 6) {
        throw ValidationException.weakPassword();
      }

      // TODO: Replace with actual API call
      // Simulate successful signup
      final user = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        isEmailVerified: false,
        createdAt: DateTime.now(),
      );

      const token = 'mock-jwt-token-signup';
      const refreshToken = 'mock-refresh-token-signup';

      // Save auth data
      await _saveAuthData(user, token, refreshToken);

      // Update app state
      await _appStateService.setAuthToken(token, userId: user.id);

      debugPrint('AuthRepository: Signup successful for ${user.email}');

      return AuthResultModel.success(
        user: user,
        token: token,
        refreshToken: refreshToken,
      );
    } on ValidationException catch (e) {
      return AuthResultModel.failure(message: e.message, code: e.code);
    } on AuthException catch (e) {
      return AuthResultModel.failure(message: e.message, code: e.code);
    } catch (e) {
      debugPrint('AuthRepository: Signup error - $e');
      return AuthResultModel.failure(
        message: 'Signup failed. Please try again.',
        code: 'SIGNUP_ERROR',
      );
    }
  }

  @override
  Future<bool> sendPasswordResetOTP(String email) async {
    await Future.delayed(_simulatedDelay);

    try {
      if (email.isEmpty) {
        throw ValidationException.required('Email');
      }

      // TODO: Replace with actual API call
      debugPrint('AuthRepository: OTP sent to $email');
      return true;
    } catch (e) {
      debugPrint('AuthRepository: Send OTP error - $e');
      return false;
    }
  }

  @override
  Future<bool> verifyOTP(String email, String otp) async {
    await Future.delayed(_simulatedDelay);

    try {
      if (otp.length != 6) {
        throw OTPException.invalid();
      }

      // TODO: Replace with actual API call
      // Simulate OTP verification (accept any 6-digit code)
      debugPrint('AuthRepository: OTP verified for $email');
      return true;
    } catch (e) {
      debugPrint('AuthRepository: Verify OTP error - $e');
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String email, String newPassword) async {
    await Future.delayed(_simulatedDelay);

    try {
      if (newPassword.length < 6) {
        throw ValidationException.weakPassword();
      }

      // TODO: Replace with actual API call
      debugPrint('AuthRepository: Password reset for $email');
      return true;
    } catch (e) {
      debugPrint('AuthRepository: Reset password error - $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Clear auth data from storage
      await _storageService.remove(_AuthStorageKeys.authToken);
      await _storageService.remove(_AuthStorageKeys.refreshToken);
      await _storageService.remove(_AuthStorageKeys.userId);
      await _storageService.remove(_AuthStorageKeys.userEmail);
      await _storageService.remove(_AuthStorageKeys.userName);

      // Update app state
      await _appStateService.logout();

      debugPrint('AuthRepository: Logged out');
    } catch (e) {
      debugPrint('AuthRepository: Logout error - $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storageService.getString(_AuthStorageKeys.authToken);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getAuthToken() async {
    return _storageService.getString(_AuthStorageKeys.authToken);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = await _storageService.getString(_AuthStorageKeys.userId);
      final userEmail = await _storageService.getString(_AuthStorageKeys.userEmail);
      final userName = await _storageService.getString(_AuthStorageKeys.userName);

      if (userId == null || userEmail == null) {
        return null;
      }

      return UserModel(
        id: userId,
        email: userEmail,
        name: userName ?? '',
      );
    } catch (e) {
      debugPrint('AuthRepository: Get current user error - $e');
      return null;
    }
  }

  @override
  Future<bool> refreshAuthToken() async {
    // TODO: Implement token refresh with actual API
    return true;
  }

  @override
  Future<void> setRememberMe(bool value) async {
    await _storageService.saveBool(_AuthStorageKeys.rememberMe, value);
  }

  @override
  Future<bool> getRememberMe() async {
    return await _storageService.getBool(_AuthStorageKeys.rememberMe) ?? false;
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  /// Saves authentication data to storage.
  Future<void> _saveAuthData(
    UserModel user,
    String token,
    String refreshToken,
  ) async {
    await _storageService.saveString(_AuthStorageKeys.authToken, token);
    await _storageService.saveString(_AuthStorageKeys.refreshToken, refreshToken);
    await _storageService.saveString(_AuthStorageKeys.userId, user.id);
    await _storageService.saveString(_AuthStorageKeys.userEmail, user.email);
    await _storageService.saveString(_AuthStorageKeys.userName, user.name);
  }

  /// Extracts a display name from email.
  String _extractNameFromEmail(String email) {
    final parts = email.split('@');
    if (parts.isEmpty) return 'User';
    return parts[0]
        .split('.')
        .map((part) => part.isNotEmpty
            ? '${part[0].toUpperCase()}${part.substring(1)}'
            : '')
        .join(' ');
  }
}
