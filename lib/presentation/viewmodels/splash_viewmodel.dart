/// MSME Pathways - Splash ViewModel
///
/// Business logic for the splash screen, handling initialization,
/// app state detection, and navigation to the appropriate screen.
library;

import 'package:flutter/foundation.dart';

import '../../core/services/app_state_service.dart';

/// ViewModel for splash screen business logic.
///
/// Handles:
/// - App state detection using AppStateService
/// - Asset preloading (if needed)
/// - Navigation timing and target determination
/// - Smart routing based on completed steps
class SplashViewModel extends ChangeNotifier {
  /// Creates a SplashViewModel instance.
  SplashViewModel({
    this.splashDuration = const Duration(milliseconds: 4000),
    this.minimumDuration = const Duration(milliseconds: 3500),
    AppStateService? appStateService,
  }) : _appStateService = appStateService ?? AppStateService();

  // ============================================================
  // CONFIGURATION
  // ============================================================

  /// Total duration of splash screen display.
  final Duration splashDuration;

  /// Minimum duration to show splash (prevents flash).
  final Duration minimumDuration;

  /// App state service for determining initial route.
  final AppStateService _appStateService;

  // ============================================================
  // STATE
  // ============================================================

  /// Current loading/initialization progress (0.0 - 1.0).
  double _progress = 0.0;
  double get progress => _progress;

  /// Whether initialization is complete.
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// The target route path to navigate to.
  String _targetRoute = '/onboarding';
  String get targetRoute => _targetRoute;

  /// Whether navigation should proceed.
  bool _shouldNavigate = false;
  bool get shouldNavigate => _shouldNavigate;

  /// Error message if initialization fails.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// App launch state for debugging/logging.
  AppLaunchState? _appState;
  AppLaunchState? get appState => _appState;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize the splash screen and determine navigation target.
  ///
  /// This method:
  /// 1. Loads app state from persistent storage
  /// 2. Determines the appropriate route based on completed steps
  /// 3. Preloads any necessary assets
  /// 4. Waits for minimum splash duration
  Future<void> initialize() async {
    try {
      final startTime = DateTime.now();

      // Step 1: Get app state
      _updateProgress(0.2);
      _appState = await _appStateService.getAppState();
      debugPrint('SplashViewModel: App state loaded - $_appState');
      _updateProgress(0.4);

      // Step 2: Determine target route
      _targetRoute = _appStateService.getRouteForState(_appState!);
      debugPrint('SplashViewModel: Target route - $_targetRoute');
      _updateProgress(0.6);

      // Step 3: Preload assets (can be extended)
      await _preloadAssets();
      _updateProgress(0.8);

      // Step 4: Ensure minimum splash duration
      final elapsed = DateTime.now().difference(startTime);
      final remainingTime = splashDuration - elapsed;

      if (!remainingTime.isNegative && remainingTime.inMilliseconds > 0) {
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

      // Default to onboarding on error (safest route)
      _targetRoute = '/onboarding';
      _shouldNavigate = true;
      notifyListeners();
    }
  }

  /// Preload assets and perform any necessary initialization.
  Future<void> _preloadAssets() async {
    // Simulate asset preloading (extend as needed)
    // In production, you might preload:
    // - Images
    // - Fonts
    // - Configuration data
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Update progress and notify listeners.
  void _updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  // ============================================================
  // UTILITY METHODS
  // ============================================================

  /// Get the route path for navigation.
  String getTargetRoutePath() => _targetRoute;

  /// Skip splash and navigate immediately.
  void skipSplash() {
    _shouldNavigate = true;
    _isInitialized = true;
    notifyListeners();
  }

  /// Reset app state (for testing/development).
  Future<void> resetAppState() async {
    await _appStateService.resetAllState();
    debugPrint('SplashViewModel: App state reset');
  }
}
