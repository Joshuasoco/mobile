/// MSME Pathways - Tooltip ViewModel
///
/// Manages the state and business logic for the Feature Tooltips system.
/// Handles sequential tooltip display, dismissal, and persistence.
library;

import 'package:flutter/material.dart';

import '../../core/services/tooltip_service.dart';
import '../../data/models/tooltip_model.dart';

/// ViewModel for managing feature tooltips.
///
/// Follows the app's MVVM pattern using ChangeNotifier.
class TooltipViewModel extends ChangeNotifier {
  TooltipViewModel({required ITooltipService tooltipService})
      : _tooltipService = tooltipService;

  final ITooltipService _tooltipService;

  // ============================================================
  // STATE
  // ============================================================

  /// Whether tooltips are currently enabled.
  bool _tooltipsEnabled = true;
  bool get tooltipsEnabled => _tooltipsEnabled;

  /// Whether the tooltip system is currently active/showing.
  bool _isActive = false;
  bool get isActive => _isActive;

  /// The currently displayed tooltip (null if none).
  TooltipConfig? _currentTooltip;
  TooltipConfig? get currentTooltip => _currentTooltip;

  /// Queue of tooltips waiting to be shown.
  final List<TooltipConfig> _tooltipQueue = [];
  List<TooltipConfig> get tooltipQueue => List.unmodifiable(_tooltipQueue);

  /// Index of current tooltip in sequence.
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  /// Total tooltips in current sequence.
  int get totalTooltips => _tooltipQueue.length;

  /// Whether there are more tooltips in the queue.
  bool get hasMoreTooltips => _currentIndex < _tooltipQueue.length - 1;

  /// Calculated position for the current tooltip.
  Rect? _targetRect;
  Rect? get targetRect => _targetRect;

  /// Whether the overlay should be visible.
  bool _showOverlay = false;
  bool get showOverlay => _showOverlay;

  /// Animation controller state.
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize the ViewModel.
  Future<void> initialize() async {
    _tooltipsEnabled = await _tooltipService.areTooltipsEnabled();
    notifyListeners();
  }

  // ============================================================
  // TOOLTIP QUEUE MANAGEMENT
  // ============================================================

  /// Start showing a sequence of tooltips.
  ///
  /// Filters out tooltips that have already been permanently dismissed
  /// or shouldn't be shown based on user preferences.
  Future<void> startTooltipSequence(List<TooltipConfig> tooltips) async {
    if (!_tooltipsEnabled || tooltips.isEmpty) return;

    // Filter tooltips that should be shown
    final List<TooltipConfig> filteredTooltips = [];
    for (final tooltip in tooltips) {
      final shouldShow = await _tooltipService.shouldShowTooltip(tooltip.id);
      if (shouldShow) {
        filteredTooltips.add(tooltip);
      }
    }

    if (filteredTooltips.isEmpty) return;

    _tooltipQueue.clear();
    _tooltipQueue.addAll(filteredTooltips);
    _currentIndex = 0;
    _isActive = true;

    // Show first tooltip after initial delay
    await Future.delayed(Duration(milliseconds: filteredTooltips.first.delayMs));
    await _showCurrentTooltip();
  }

  /// Show a single tooltip immediately.
  Future<void> showTooltip(TooltipConfig tooltip) async {
    if (!_tooltipsEnabled) return;

    final shouldShow = await _tooltipService.shouldShowTooltip(tooltip.id);
    if (!shouldShow) return;

    _tooltipQueue.clear();
    _tooltipQueue.add(tooltip);
    _currentIndex = 0;
    _isActive = true;

    await Future.delayed(Duration(milliseconds: tooltip.delayMs));
    await _showCurrentTooltip();
  }

  /// Internal method to show the current tooltip.
  Future<void> _showCurrentTooltip() async {
    if (_currentIndex >= _tooltipQueue.length) {
      await _endTooltipSequence();
      return;
    }

    final tooltip = _tooltipQueue[_currentIndex];

    // Calculate target position
    _targetRect = _calculateTargetRect(tooltip.targetKey);
    if (_targetRect == null) {
      debugPrint('TooltipViewModel: Could not find target for ${tooltip.id}');
      // Skip to next tooltip if target not found
      await _moveToNextTooltip();
      return;
    }

    _currentTooltip = tooltip;
    _showOverlay = true;
    _isAnimating = true;

    await _tooltipService.markTooltipShown(tooltip.id);

    notifyListeners();

    // Mark animation complete after duration
    await Future.delayed(const Duration(milliseconds: 300));
    _isAnimating = false;
    notifyListeners();
  }

  /// Calculate the target widget's rect.
  Rect? _calculateTargetRect(GlobalKey targetKey) {
    final context = targetKey.currentContext;
    if (context == null) return null;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    final position = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
      position.dx,
      position.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
  }

  // ============================================================
  // USER ACTIONS
  // ============================================================

  /// Dismiss the current tooltip and show the next one.
  Future<void> dismissCurrentTooltip() async {
    if (_currentTooltip == null) return;

    await _tooltipService.markTooltipDismissed(_currentTooltip!.id);
    await _moveToNextTooltip();
  }

  /// Dismiss the current tooltip with "Don't show again" option.
  Future<void> dismissPermanently() async {
    if (_currentTooltip == null) return;

    await _tooltipService.markTooltipPermanentlyDismissed(_currentTooltip!.id);
    await _moveToNextTooltip();
  }

  /// Skip all remaining tooltips in the sequence.
  Future<void> skipAllTooltips() async {
    // Mark remaining tooltips as dismissed
    for (int i = _currentIndex; i < _tooltipQueue.length; i++) {
      await _tooltipService.markTooltipDismissed(_tooltipQueue[i].id);
    }

    await _endTooltipSequence();
  }

  /// Move to the next tooltip in the sequence.
  Future<void> _moveToNextTooltip() async {
    _isAnimating = true;
    _showOverlay = false;
    notifyListeners();

    // Wait for fade out animation
    await Future.delayed(const Duration(milliseconds: 300));

    _currentIndex++;

    if (_currentIndex < _tooltipQueue.length) {
      // Delay between tooltips
      await Future.delayed(const Duration(milliseconds: 500));
      await _showCurrentTooltip();
    } else {
      await _endTooltipSequence();
    }
  }

  /// End the tooltip sequence.
  Future<void> _endTooltipSequence() async {
    _isAnimating = true;
    _showOverlay = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _currentTooltip = null;
    _targetRect = null;
    _isActive = false;
    _isAnimating = false;
    _tooltipQueue.clear();
    _currentIndex = 0;

    notifyListeners();
  }

  /// Go to a specific tooltip by index.
  Future<void> goToTooltip(int index) async {
    if (index < 0 || index >= _tooltipQueue.length) return;

    _currentIndex = index;
    await _showCurrentTooltip();
  }

  /// Go to previous tooltip.
  Future<void> previousTooltip() async {
    if (_currentIndex > 0) {
      await goToTooltip(_currentIndex - 1);
    }
  }

  /// Go to next tooltip.
  Future<void> nextTooltip() async {
    await dismissCurrentTooltip();
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  /// Enable or disable tooltips globally.
  Future<void> setTooltipsEnabled(bool enabled) async {
    _tooltipsEnabled = enabled;
    await _tooltipService.setTooltipsEnabled(enabled);

    if (!enabled && _isActive) {
      await _endTooltipSequence();
    }

    notifyListeners();
  }

  /// Reset all tooltip states (for "replay tutorials" feature).
  Future<void> resetAllTooltips() async {
    await _tooltipService.resetAllTooltips();
    debugPrint('TooltipViewModel: All tooltips reset');
  }

  // ============================================================
  // HELPERS
  // ============================================================

  /// Calculate the optimal position for the tooltip bubble.
  TooltipPosition calculateOptimalPosition(
    Rect targetRect,
    Size screenSize, {
    double tooltipHeight = 100,
    double tooltipWidth = 280,
    double padding = 16,
  }) {
    final spaceAbove = targetRect.top - padding;
    final spaceBelow = screenSize.height - targetRect.bottom - padding;
    final spaceLeft = targetRect.left - padding;
    final spaceRight = screenSize.width - targetRect.right - padding;

    // Prefer bottom, then top, then sides
    if (spaceBelow >= tooltipHeight) {
      return TooltipPosition.bottom;
    } else if (spaceAbove >= tooltipHeight) {
      return TooltipPosition.top;
    } else if (spaceRight >= tooltipWidth) {
      return TooltipPosition.right;
    } else if (spaceLeft >= tooltipWidth) {
      return TooltipPosition.left;
    }

    // Default to bottom if no good position
    return TooltipPosition.bottom;
  }

  @override
  void dispose() {
    _tooltipQueue.clear();
    super.dispose();
  }
}
