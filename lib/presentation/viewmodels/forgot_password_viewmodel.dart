/// MSME Pathways - Forgot Password ViewModel
///
/// Business logic for forgot password screen.
/// Handles OTP request for password reset.
library;

import 'package:flutter/foundation.dart';

import '../../core/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';

/// Forgot password screen states.
enum ForgotPasswordState {
  /// Initial state, ready for input.
  initial,

  /// Sending OTP in progress.
  loading,

  /// OTP sent successfully.
  success,

  /// Failed to send OTP.
  error,
}

/// ViewModel for forgot password screen.
///
/// Manages:
/// - Email validation
/// - OTP sending state
/// - Error handling
class ForgotPasswordViewModel extends ChangeNotifier {
  /// Creates a ForgotPasswordViewModel.
  ForgotPasswordViewModel({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository;

  final IAuthRepository _authRepository;

  // ============================================================
  // STATE
  // ============================================================

  /// Current state.
  ForgotPasswordState _state = ForgotPasswordState.initial;
  ForgotPasswordState get state => _state;

  /// Error message if any.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Email that OTP was sent to.
  String? _emailSentTo;
  String? get emailSentTo => _emailSentTo;

  /// Whether loading is in progress.
  bool get isLoading => _state == ForgotPasswordState.loading;

  /// Whether OTP was sent successfully.
  bool get isSuccess => _state == ForgotPasswordState.success;

  /// Whether there's an error.
  bool get hasError => _state == ForgotPasswordState.error;

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Sends password reset OTP to email.
  Future<void> sendOTP(String email) async {
    _errorMessage = null;

    // Validate email
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return;
    }

    _setState(ForgotPasswordState.loading);

    try {
      final success = await _authRepository.sendPasswordResetOTP(email.trim());

      if (success) {
        _emailSentTo = email.trim();
        _setState(ForgotPasswordState.success);
        debugPrint('ForgotPasswordViewModel: OTP sent to $email');
      } else {
        _setError('Failed to send OTP. Please try again.');
      }
    } catch (e) {
      debugPrint('ForgotPasswordViewModel: Error - $e');
      _setError('An error occurred. Please try again.');
    }
  }

  /// Clears error and resets to initial state.
  void clearError() {
    _errorMessage = null;
    if (_state == ForgotPasswordState.error) {
      _state = ForgotPasswordState.initial;
    }
    notifyListeners();
  }

  /// Resets the ViewModel.
  void reset() {
    _state = ForgotPasswordState.initial;
    _errorMessage = null;
    _emailSentTo = null;
    notifyListeners();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  void _setState(ForgotPasswordState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = ForgotPasswordState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
