/// MSME Pathways - Signup ViewModel
///
/// Business logic and state management for the signup screen.
/// Follows MVVM pattern - no BuildContext or UI imports.
library;

import 'package:flutter/foundation.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Signup screen states.
enum SignupState {
  /// Initial state, ready for input.
  initial,

  /// Signup in progress.
  loading,

  /// Signup successful, ready to navigate.
  success,

  /// Signup failed with error.
  error,
}

/// ViewModel for signup screen business logic.
///
/// Manages:
/// - Signup state (loading, success, error)
/// - Input validation
/// - Terms acceptance
/// - Password strength
/// - Error messages
class SignupViewModel extends ChangeNotifier {
  /// Creates a SignupViewModel with required repository.
  SignupViewModel({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository;

  final IAuthRepository _authRepository;

  // ============================================================
  // STATE
  // ============================================================

  /// Current signup state.
  SignupState _state = SignupState.initial;
  SignupState get state => _state;

  /// The created user after successful signup.
  UserModel? _user;
  UserModel? get user => _user;

  /// Error message to display.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Whether terms and conditions are accepted.
  bool _acceptedTerms = false;
  bool get acceptedTerms => _acceptedTerms;

  /// Password strength score (0-4).
  int _passwordStrength = 0;
  int get passwordStrength => _passwordStrength;

  /// Whether signup is in progress.
  bool get isLoading => _state == SignupState.loading;

  /// Whether signup was successful.
  bool get isSuccess => _state == SignupState.success;

  /// Whether there's an error to show.
  bool get hasError => _state == SignupState.error && _errorMessage != null;

  /// Whether the form can be submitted.
  bool get canSubmit => _acceptedTerms && !isLoading;

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Performs signup with name, email, and password.
  ///
  /// Validates all input and creates the account.
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Clear previous error
    _errorMessage = null;

    // Validate terms acceptance
    if (!_acceptedTerms) {
      _setError('Please accept the Terms and Privacy Policy');
      return;
    }

    // Validate name
    final nameError = Validators.validateName(name);
    if (nameError != null) {
      _setError(nameError);
      return;
    }

    // Validate email
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return;
    }

    // Validate password
    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _setError(passwordError);
      return;
    }

    // Validate password confirmation
    final confirmError = Validators.validateConfirmPassword(password, confirmPassword);
    if (confirmError != null) {
      _setError(confirmError);
      return;
    }

    // Set loading state
    _setState(SignupState.loading);

    try {
      // Call repository
      final result = await _authRepository.signup(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      if (result.success && result.user != null) {
        _user = result.user;
        _setState(SignupState.success);
        debugPrint('SignupViewModel: Signup successful for ${_user?.email}');
      } else {
        _setError(result.errorMessage ?? 'Signup failed. Please try again.');
      }
    } on AuthException catch (e) {
      _setError(e.message);
    } on ValidationException catch (e) {
      _setError(e.message);
    } catch (e) {
      debugPrint('SignupViewModel: Unexpected error - $e');
      _setError('An unexpected error occurred. Please try again.');
    }
  }

  /// Toggles terms acceptance.
  void toggleTermsAccepted() {
    _acceptedTerms = !_acceptedTerms;
    notifyListeners();
  }

  /// Sets terms acceptance directly.
  void setTermsAccepted(bool value) {
    if (_acceptedTerms != value) {
      _acceptedTerms = value;
      notifyListeners();
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

  /// Clears any error message.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      if (_state == SignupState.error) {
        _state = SignupState.initial;
      }
      notifyListeners();
    }
  }

  /// Resets the ViewModel to initial state.
  void reset() {
    _state = SignupState.initial;
    _user = null;
    _errorMessage = null;
    _acceptedTerms = false;
    _passwordStrength = 0;
    notifyListeners();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  /// Sets the state and notifies listeners.
  void _setState(SignupState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Sets error state with message.
  void _setError(String message) {
    _state = SignupState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
