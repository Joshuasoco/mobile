/// MSME Pathways - Reset Password ViewModel
///
/// Business logic for reset password screen.
/// Handles new password input and submission.
library;

import 'package:flutter/foundation.dart';

import '../../core/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';

/// Reset password screen states.
enum ResetPasswordState {
  /// Initial state, ready for input.
  initial,

  /// Resetting password in progress.
  loading,

  /// Password reset successful.
  success,

  /// Reset failed.
  error,
}

/// ViewModel for reset password screen.
///
/// Manages:
/// - Password validation
/// - Password strength
/// - Reset state
/// - Error handling
class ResetPasswordViewModel extends ChangeNotifier {
  /// Creates a ResetPasswordViewModel.
  ResetPasswordViewModel({
    required IAuthRepository authRepository,
    required String email,
  })  : _authRepository = authRepository,
        _email = email;

  final IAuthRepository _authRepository;
  final String _email;

  // ============================================================
  // STATE
  // ============================================================

  /// Current state.
  ResetPasswordState _state = ResetPasswordState.initial;
  ResetPasswordState get state => _state;

  /// Error message if any.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Password strength score (0-4).
  int _passwordStrength = 0;
  int get passwordStrength => _passwordStrength;

  /// The email being reset.
  String get email => _email;

  /// Whether loading is in progress.
  bool get isLoading => _state == ResetPasswordState.loading;

  /// Whether reset was successful.
  bool get isSuccess => _state == ResetPasswordState.success;

  /// Whether there's an error.
  bool get hasError => _state == ResetPasswordState.error;

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Resets the password.
  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    _errorMessage = null;

    // Validate new password
    final passwordError = Validators.validatePassword(newPassword);
    if (passwordError != null) {
      _setError(passwordError);
      return;
    }

    // Validate confirmation
    final confirmError = Validators.validateConfirmPassword(
      newPassword,
      confirmPassword,
    );
    if (confirmError != null) {
      _setError(confirmError);
      return;
    }

    _setState(ResetPasswordState.loading);

    try {
      final success = await _authRepository.resetPassword(_email, newPassword);

      if (success) {
        _setState(ResetPasswordState.success);
        debugPrint('ResetPasswordViewModel: Password reset for $_email');
      } else {
        _setError('Failed to reset password. Please try again.');
      }
    } catch (e) {
      debugPrint('ResetPasswordViewModel: Error - $e');
      _setError('An error occurred. Please try again.');
    }
  }

  /// Updates password strength when password changes.
  void updatePasswordStrength(String password) {
    final newStrength = Validators.getPasswordStrength(password);
    if (_passwordStrength != newStrength) {
      _passwordStrength = newStrength;
      notifyListeners();
    }
  }

  /// Clears error.
  void clearError() {
    _errorMessage = null;
    if (_state == ResetPasswordState.error) {
      _state = ResetPasswordState.initial;
    }
    notifyListeners();
  }

  /// Resets the ViewModel.
  void reset() {
    _state = ResetPasswordState.initial;
    _errorMessage = null;
    _passwordStrength = 0;
    notifyListeners();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  void _setState(ResetPasswordState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = ResetPasswordState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
