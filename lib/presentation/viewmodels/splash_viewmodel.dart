/// MSME Pathways - Splash ViewModel
///
/// Business logic for the splash screen, handling initialization,
/// first-launch detection, and navigation to the appropriate screen.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Navigation destination after splash screen.
enum SplashNavigationTarget {
  /// Navigate to onboarding for first-time users.
  onboarding,

  /// Navigate to login for returning users (not yet implemented).
  login,

  /// Navigate to home for authenticated users (not yet implemented).
  home,
}

/// ViewModel for splash screen business logic.
///
/// Handles:
/// - First launch detection using SharedPreferences
/// - Asset preloading (if needed)
/// - Navigation timing and target determination
/// - App initialization tasks
class SplashViewModel extends ChangeNotifier {
  /// Creates a SplashViewModel instance.
  SplashViewModel({
    this.splashDuration = const Duration(milliseconds: 4000),
    this.minimumDuration = const Duration(milliseconds: 3500),
  });

  // ============================================================
  // CONFIGURATION
  // ============================================================

  /// Total duration of splash screen display.
  final Duration splashDuration;

  /// Minimum duration to show splash (prevents flash).
  final Duration minimumDuration;

  /// Key for storing first launch status in SharedPreferences.
  static const String _firstLaunchKey = 'is_first_launch';

  // ============================================================
  // STATE
  // ============================================================

  /// Current loading/initialization progress (0.0 - 1.0).
  double _progress = 0.0;
  double get progress => _progress;

  /// Whether initialization is complete.
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Whether this is the user's first launch.
  bool _isFirstLaunch = true;
  bool get isFirstLaunch => _isFirstLaunch;

  /// The target screen to navigate to.
  SplashNavigationTarget _navigationTarget = SplashNavigationTarget.onboarding;
  SplashNavigationTarget get navigationTarget => _navigationTarget;

  /// Whether navigation should proceed.
  bool _shouldNavigate = false;
  bool get shouldNavigate => _shouldNavigate;

  /// Error message if initialization fails.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize the splash screen and determine navigation target.
  ///
  /// This method:
  /// 1. Checks if this is the first launch
  /// 2. Preloads any necessary assets
  /// 3. Waits for minimum splash duration
  /// 4. Sets the appropriate navigation target
  Future<void> initialize() async {
    try {
      final startTime = DateTime.now();

      // Step 1: Check first launch status
      await _checkFirstLaunch();
      _updateProgress(0.3);

      // Step 2: Preload assets (can be extended)
      await _preloadAssets();
      _updateProgress(0.6);

      // Step 3: Determine navigation target
      _determineNavigationTarget();
      _updateProgress(0.9);

      // Step 4: Ensure minimum splash duration
      final elapsed = DateTime.now().difference(startTime);
      final remainingTime = splashDuration - elapsed;
      
      if (remainingTime.isNegative == false && remainingTime.inMilliseconds > 0) {
        await Future.delayed(remainingTime);
      }

      // Mark as complete
      _updateProgress(1.0);
      _isInitialized = true;
      _shouldNavigate = true;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('SplashViewModel initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorMessage = 'Failed to initialize app. Please try again.';
      
      // Still allow navigation on error (fail gracefully)
      _shouldNavigate = true;
      notifyListeners();
    }
  }

  /// Check if this is the user's first launch.
  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
      
      // If first launch, mark it as no longer first launch for next time
      if (_isFirstLaunch) {
        await prefs.setBool(_firstLaunchKey, false);
      }
    } catch (e) {
      debugPrint('Error checking first launch: $e');
      // Default to first launch on error
      _isFirstLaunch = true;
    }
  }

  /// Preload assets and perform any necessary initialization.
  Future<void> _preloadAssets() async {
    // Simulate asset preloading (extend as needed)
    // In production, you might preload:
    // - Images
    // - Fonts
    // - Configuration data
    // - User preferences
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Determine where to navigate based on app state.
  void _determineNavigationTarget() {
    if (_isFirstLaunch) {
      _navigationTarget = SplashNavigationTarget.onboarding;
    } else {
      // For now, always go to onboarding
      // In future: check auth state to determine login vs home
      _navigationTarget = SplashNavigationTarget.onboarding;
    }
  }

  /// Update progress and notify listeners.
  void _updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  // ============================================================
  // UTILITY METHODS
  // ============================================================

  /// Get the route path for the navigation target.
  String getTargetRoutePath() {
    switch (_navigationTarget) {
      case SplashNavigationTarget.onboarding:
        return '/onboarding';
      case SplashNavigationTarget.login:
        return '/login';
      case SplashNavigationTarget.home:
        return '/home';
    }
  }

  /// Reset first launch flag (for testing/development).
  Future<void> resetFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, true);
      _isFirstLaunch = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting first launch: $e');
    }
  }

  /// Skip splash and navigate immediately.
  void skipSplash() {
    _shouldNavigate = true;
    _isInitialized = true;
    notifyListeners();
  }
}
