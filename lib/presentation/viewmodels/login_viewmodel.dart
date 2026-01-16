/// MSME Pathways - Login ViewModel
///
/// Business logic and state management for the login screen.
/// Follows MVVM pattern - no BuildContext or UI imports.
library;

import 'package:flutter/foundation.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Login screen states.
enum LoginState {
  /// Initial state, ready for input.
  initial,

  /// Login in progress.
  loading,

  /// Login successful, ready to navigate.
  success,

  /// Login failed with error.
  error,
}

/// ViewModel for login screen business logic.
///
/// Manages:
/// - Login state (loading, success, error)
/// - Input validation
/// - Remember me preference
/// - Error messages
class LoginViewModel extends ChangeNotifier {
  /// Creates a LoginViewModel with required repository.
  LoginViewModel({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository {
    _loadRememberMe();
  }

  final IAuthRepository _authRepository;

  // ============================================================
  // STATE
  // ============================================================

  /// Current login state.
  LoginState _state = LoginState.initial;
  LoginState get state => _state;

  /// The authenticated user after successful login.
  UserModel? _user;
  UserModel? get user => _user;

  /// Error message to display.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Remember me checkbox state.
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  /// Whether login is in progress.
  bool get isLoading => _state == LoginState.loading;

  /// Whether login was successful.
  bool get isSuccess => _state == LoginState.success;

  /// Whether there's an error to show.
  bool get hasError => _state == LoginState.error && _errorMessage != null;

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Performs login with email and password.
  ///
  /// Validates input, calls repository, and updates state.
  Future<void> login(String email, String password) async {
    // Clear previous error
    _errorMessage = null;

    // Validate input
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _setError(passwordError);
      return;
    }

    // Set loading state
    _setState(LoginState.loading);

    try {
      // Call repository
      final result = await _authRepository.login(email.trim(), password);

      if (result.success && result.user != null) {
        _user = result.user;

        // Save remember me preference
        await _authRepository.setRememberMe(_rememberMe);

        _setState(LoginState.success);
        debugPrint('LoginViewModel: Login successful for ${_user?.email}');
      } else {
        _setError(result.errorMessage ?? 'Login failed. Please try again.');
      }
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      debugPrint('LoginViewModel: Unexpected error - $e');
      _setError('An unexpected error occurred. Please try again.');
    }
  }

  /// Toggles the remember me checkbox.
  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  /// Sets remember me state directly.
  void setRememberMe(bool value) {
    if (_rememberMe != value) {
      _rememberMe = value;
      notifyListeners();
    }
  }

  /// Clears any error message.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      if (_state == LoginState.error) {
        _state = LoginState.initial;
      }
      notifyListeners();
    }
  }

  /// Resets the ViewModel to initial state.
  void reset() {
    _state = LoginState.initial;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // PRIVATE HELPERS
  // ============================================================

  /// Sets the state and notifies listeners.
  void _setState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Sets error state with message.
  void _setError(String message) {
    _state = LoginState.error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Loads remember me preference from storage.
  Future<void> _loadRememberMe() async {
    try {
      _rememberMe = await _authRepository.getRememberMe();
      notifyListeners();
    } catch (e) {
      // Ignore load errors
      debugPrint('LoginViewModel: Error loading remember me - $e');
    }
  }
}
