/// MSME Pathways - Contextual Tutorial ViewModel
///
/// Manages the state and business logic for step-by-step contextual tutorials.
/// Handles tutorial progress, navigation, and persistence.
library;

import 'package:flutter/material.dart';

import '../../core/services/tooltip_service.dart';
import '../../data/models/tooltip_model.dart';

/// ViewModel for managing contextual tutorials.
///
/// Follows the app's MVVM pattern using ChangeNotifier.
class ContextualTutorialViewModel extends ChangeNotifier {
  ContextualTutorialViewModel({required ITooltipService tooltipService})
      : _tooltipService = tooltipService;

  final ITooltipService _tooltipService;

  // ============================================================
  // STATE
  // ============================================================

  /// Whether tutorials are currently enabled.
  bool _tutorialsEnabled = true;
  bool get tutorialsEnabled => _tutorialsEnabled;

  /// Whether a tutorial is currently being displayed.
  bool _isShowingTutorial = false;
  bool get isShowingTutorial => _isShowingTutorial;

  /// The currently displayed tutorial.
  TutorialConfig? _currentTutorial;
  TutorialConfig? get currentTutorial => _currentTutorial;

  /// Current step index (0-based).
  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  /// Current step (1-based display).
  int get currentStepNumber => _currentStepIndex + 1;

  /// Total steps in current tutorial.
  int get totalSteps => _currentTutorial?.totalSteps ?? 0;

  /// Progress percentage (0.0 - 1.0).
  double get progress =>
      totalSteps > 0 ? (currentStepNumber) / totalSteps : 0.0;

  /// Current step data.
  TutorialStep? get currentStep {
    if (_currentTutorial == null ||
        _currentStepIndex >= _currentTutorial!.steps.length) {
      return null;
    }
    return _currentTutorial!.steps[_currentStepIndex];
  }

  /// Whether on the first step.
  bool get isFirstStep => _currentStepIndex == 0;

  /// Whether on the last step.
  bool get isLastStep =>
      _currentTutorial != null &&
      _currentStepIndex == _currentTutorial!.steps.length - 1;

  /// Whether the tutorial can be skipped.
  bool get canSkip => _currentTutorial?.canSkip ?? true;

  /// Animation state.
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  /// Target rect for current step's highlight (if any).
  Rect? _highlightRect;
  Rect? get highlightRect => _highlightRect;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize the ViewModel.
  Future<void> initialize() async {
    _tutorialsEnabled = await _tooltipService.areTutorialsEnabled();
    notifyListeners();
  }

  // ============================================================
  // TUTORIAL MANAGEMENT
  // ============================================================

  /// Start a tutorial if it should be shown.
  ///
  /// Returns true if the tutorial was started, false otherwise.
  Future<bool> startTutorial(TutorialConfig tutorial) async {
    if (!_tutorialsEnabled) return false;
    if (_isShowingTutorial) return false;

    final shouldShow = await _tooltipService.shouldShowTutorial(tutorial.id);
    if (!shouldShow) return false;

    _currentTutorial = tutorial;
    _currentStepIndex = 0;
    _isShowingTutorial = true;

    await _tooltipService.markTutorialStarted(tutorial.id);
    await _updateHighlightRect();

    notifyListeners();
    return true;
  }

  /// Force start a tutorial (ignores shouldShow check).
  /// Used for "replay tutorial" from settings.
  Future<void> forceStartTutorial(TutorialConfig tutorial) async {
    if (_isShowingTutorial) {
      await endTutorial();
    }

    _currentTutorial = tutorial;
    _currentStepIndex = 0;
    _isShowingTutorial = true;

    await _tooltipService.markTutorialStarted(tutorial.id);
    await _updateHighlightRect();

    notifyListeners();
  }

  /// Update the highlight rect for the current step.
  Future<void> _updateHighlightRect() async {
    final step = currentStep;
    if (step == null || step.targetKey == null || !step.highlightTarget) {
      _highlightRect = null;
      return;
    }

    final context = step.targetKey!.currentContext;
    if (context == null) {
      _highlightRect = null;
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      _highlightRect = null;
      return;
    }

    final position = renderBox.localToGlobal(Offset.zero);
    _highlightRect = Rect.fromLTWH(
      position.dx,
      position.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  /// Move to the next step.
  Future<void> nextStep() async {
    if (_currentTutorial == null) return;

    if (isLastStep) {
      await completeTutorial();
      return;
    }

    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 150));

    _currentStepIndex++;
    await _tooltipService.updateTutorialProgress(
      _currentTutorial!.id,
      _currentStepIndex,
    );

    await _updateHighlightRect();

    _isAnimating = false;
    notifyListeners();
  }

  /// Move to the previous step.
  Future<void> previousStep() async {
    if (_currentTutorial == null || isFirstStep) return;

    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 150));

    _currentStepIndex--;
    await _tooltipService.updateTutorialProgress(
      _currentTutorial!.id,
      _currentStepIndex,
    );

    await _updateHighlightRect();

    _isAnimating = false;
    notifyListeners();
  }

  /// Go to a specific step by index.
  Future<void> goToStep(int index) async {
    if (_currentTutorial == null) return;
    if (index < 0 || index >= _currentTutorial!.steps.length) return;

    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 150));

    _currentStepIndex = index;
    await _tooltipService.updateTutorialProgress(
      _currentTutorial!.id,
      _currentStepIndex,
    );

    await _updateHighlightRect();

    _isAnimating = false;
    notifyListeners();
  }

  // ============================================================
  // COMPLETION
  // ============================================================

  /// Complete the tutorial successfully.
  Future<void> completeTutorial() async {
    if (_currentTutorial == null) return;

    await _tooltipService.markTutorialCompleted(_currentTutorial!.id);

    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _endTutorial();
  }

  /// Skip the tutorial.
  Future<void> skipTutorial() async {
    if (_currentTutorial == null) return;

    await _tooltipService.markTutorialSkipped(_currentTutorial!.id);

    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _endTutorial();
  }

  /// End the tutorial without saving completion status.
  Future<void> endTutorial() async {
    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _endTutorial();
  }

  /// Internal method to clean up tutorial state.
  void _endTutorial() {
    _currentTutorial = null;
    _currentStepIndex = 0;
    _isShowingTutorial = false;
    _isAnimating = false;
    _highlightRect = null;

    notifyListeners();
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  /// Enable or disable tutorials globally.
  Future<void> setTutorialsEnabled(bool enabled) async {
    _tutorialsEnabled = enabled;
    await _tooltipService.setTutorialsEnabled(enabled);

    if (!enabled && _isShowingTutorial) {
      _endTutorial();
    }

    notifyListeners();
  }

  /// Reset all tutorial states.
  Future<void> resetAllTutorials() async {
    if (_isShowingTutorial) {
      _endTutorial();
    }

    await _tooltipService.resetAllTutorials();
    debugPrint('ContextualTutorialViewModel: All tutorials reset');
  }

  /// Reset everything (tooltips + tutorials).
  Future<void> resetAll() async {
    if (_isShowingTutorial) {
      _endTutorial();
    }

    await _tooltipService.resetAll();
    debugPrint('ContextualTutorialViewModel: All states reset');
  }

  // ============================================================
  // HELPERS
  // ============================================================

  /// Check if a tutorial has been completed.
  Future<bool> isTutorialCompleted(String tutorialId) async {
    final state = await _tooltipService.getTutorialState(tutorialId);
    return state.status == TutorialStateStatus.completed;
  }

  /// Check if a tutorial should be shown.
  Future<bool> shouldShowTutorial(String tutorialId) async {
    return _tooltipService.shouldShowTutorial(tutorialId);
  }

  
}
