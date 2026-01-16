/// MSME Pathways - OTP Verification ViewModel
///
/// Business logic for OTP verification screen.
/// Handles OTP input, verification, and resend.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';

/// OTP verification screen states.
enum OTPVerificationState {
  /// Initial state, waiting for input.
  initial,

  /// Verifying OTP in progress.
  verifying,

  /// Resending OTP in progress.
  resending,

  /// OTP verified successfully.
  success,

  /// Verification failed.
  error,
}

/// ViewModel for OTP verification screen.
///
/// Manages:
/// - OTP input and validation
/// - Verification state
/// - Resend functionality with cooldown
/// - Error handling
class OTPVerificationViewModel extends ChangeNotifier {
  /// Creates an OTPVerificationViewModel.
  OTPVerificationViewModel({
    required IAuthRepository authRepository,
    required String email,
  })  : _authRepository = authRepository,
        _email = email {
    _startResendTimer();
  }

  final IAuthRepository _authRepository;
  final String _email;

  // Resend cooldown in seconds
  static const int _resendCooldownSeconds = 60;

  // ============================================================
  // STATE
  // ============================================================

  /// Current state.
  OTPVerificationState _state = OTPVerificationState.initial;
  OTPVerificationState get state => _state;

  /// Error message if any.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Seconds remaining until resend is available.
  int _resendCountdown = _resendCooldownSeconds;
  int get resendCountdown => _resendCountdown;

  /// Whether resend is available.
  bool get canResend => _resendCountdown == 0 && !isLoading;

  /// Timer for resend countdown.
  Timer? _resendTimer;

  /// The email OTP was sent to.
  String get email => _email;

  /// Masked email for display.
  String get maskedEmail {
    if (_email.isEmpty) return '';
    final parts = _email.split('@');
    if (parts.length != 2) return _email;

    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 3) {
      return '${name[0]}***@$domain';
    }

    return '${name.substring(0, 2)}***${name[name.length - 1]}@$domain';
  }

  /// Whether any loading is in progress.
  bool get isLoading =>
      _state == OTPVerificationState.verifying ||
      _state == OTPVerificationState.resending;

  /// Whether verification was successful.
  bool get isSuccess => _state == OTPVerificationState.success;

  /// Whether there's an error.
  bool get hasError => _state == OTPVerificationState.error;

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Verifies the OTP code.
  Future<void> verifyOTP(String otp) async {
    _errorMessage = null;

    // Validate OTP format
    final otpError = Validators.validateOTP(otp);
    if (otpError != null) {
      _setError(otpError);
      return;
    }

    _setState(OTPVerificationState.verifying);

    try {
      final success = await _authRepository.verifyOTP(_email, otp);

      if (success) {
        _setState(OTPVerificationState.success);
        debugPrint('OTPVerificationViewModel: OTP verified for $_email');
      } else {
        _setError('Invalid OTP. Please check and try again.');
      }
    } catch (e) {
      debugPrint('OTPVerificationViewModel: Error - $e');
      _setError('Verification failed. Please try again.');
    }
  }

  /// Resends OTP to email.
  Future<void> resendOTP() async {
    if (!canResend) return;

    _errorMessage = null;
    _setState(OTPVerificationState.resending);

    try {
      final success = await _authRepository.sendPasswordResetOTP(_email);

      if (success) {
        // Reset timer
        _resendCountdown = _resendCooldownSeconds;
        _startResendTimer();
        _setState(OTPVerificationState.initial);
        debugPrint('OTPVerificationViewModel: OTP resent to $_email');
      } else {
        _setError('Failed to resend OTP. Please try again.');
      }
    } catch (e) {
      debugPrint('OTPVerificationViewModel: Resend error - $e');
      _setError('Failed to resend OTP. Please try again.');
    }
  }

  /// Clears error.
  void clearError() {
    _errorMessage = null;
    if (_state == OTPVerificationState.error) {
      _state = OTPVerificationState.initial;
    }
    notifyListeners();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  void _setState(OTPVerificationState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _state = OTPVerificationState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        _resendCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
