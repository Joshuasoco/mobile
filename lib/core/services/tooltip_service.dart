/// MSME Pathways - Tooltip Service
///
/// Manages persistence and state for the Feature Tooltips
/// and Contextual Tutorials system.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../data/models/tooltip_model.dart';
import 'storage_service.dart';

/// Storage keys for tooltip/tutorial persistence.
abstract final class TooltipStorageKeys {
  static const String tooltipStates = 'tooltip_states';
  static const String tutorialStates = 'tutorial_states';
  static const String tooltipsEnabled = 'tooltips_enabled';
  static const String tutorialsEnabled = 'tutorials_enabled';
  static const String lastResetTimestamp = 'tutorials_last_reset';
}

/// Abstract interface for tooltip/tutorial state management.
abstract class ITooltipService {
  /// Initialize the service.
  Future<void> init();

  /// Get the state of a specific tooltip.
  Future<TutorialState> getTooltipState(String tooltipId);

  /// Get the state of a specific tutorial.
  Future<TutorialState> getTutorialState(String tutorialId);

  /// Mark a tooltip as shown.
  Future<void> markTooltipShown(String tooltipId);

  /// Mark a tooltip as dismissed.
  Future<void> markTooltipDismissed(String tooltipId);

  /// Mark a tooltip as permanently dismissed ("Don't show again").
  Future<void> markTooltipPermanentlyDismissed(String tooltipId);

  /// Mark a tutorial as started.
  Future<void> markTutorialStarted(String tutorialId);

  /// Update tutorial progress.
  Future<void> updateTutorialProgress(String tutorialId, int currentStep);

  /// Mark a tutorial as completed.
  Future<void> markTutorialCompleted(String tutorialId);

  /// Mark a tutorial as skipped.
  Future<void> markTutorialSkipped(String tutorialId);

  /// Check if tooltips are enabled globally.
  Future<bool> areTooltipsEnabled();

  /// Enable or disable tooltips globally.
  Future<void> setTooltipsEnabled(bool enabled);

  /// Check if tutorials are enabled globally.
  Future<bool> areTutorialsEnabled();

  /// Enable or disable tutorials globally.
  Future<void> setTutorialsEnabled(bool enabled);

  /// Reset all tooltip states.
  Future<void> resetAllTooltips();

  /// Reset all tutorial states.
  Future<void> resetAllTutorials();

  /// Reset everything (tooltips + tutorials).
  Future<void> resetAll();

  /// Get all tooltip IDs that have been shown.
  Future<List<String>> getShownTooltipIds();

  /// Get all completed tutorial IDs.
  Future<List<String>> getCompletedTutorialIds();

  /// Check if a specific tooltip should be shown.
  Future<bool> shouldShowTooltip(String tooltipId);

  /// Check if a specific tutorial should be shown.
  Future<bool> shouldShowTutorial(String tutorialId);
}

/// Implementation of [ITooltipService] using [IStorageService].
class TooltipService implements ITooltipService {
  TooltipService({required IStorageService storageService})
      : _storageService = storageService;

  final IStorageService _storageService;

  /// In-memory cache of tooltip states.
  Map<String, TutorialState> _tooltipStates = {};

  /// In-memory cache of tutorial states.
  Map<String, TutorialState> _tutorialStates = {};

  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    try {
      await _loadTooltipStates();
      await _loadTutorialStates();
      _initialized = true;
      debugPrint('TooltipService: Initialized successfully');
    } catch (e) {
      debugPrint('TooltipService: Initialization failed - $e');
      // Initialize with empty states on error
      _tooltipStates = {};
      _tutorialStates = {};
      _initialized = true;
    }
  }

  Future<void> _loadTooltipStates() async {
    final jsonString =
        await _storageService.getString(TooltipStorageKeys.tooltipStates);
    if (jsonString == null || jsonString.isEmpty) {
      _tooltipStates = {};
      return;
    }

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _tooltipStates = jsonMap.map(
        (key, value) => MapEntry(
          key,
          TutorialState.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      debugPrint('TooltipService: Failed to parse tooltip states - $e');
      _tooltipStates = {};
    }
  }

  Future<void> _loadTutorialStates() async {
    final jsonString =
        await _storageService.getString(TooltipStorageKeys.tutorialStates);
    if (jsonString == null || jsonString.isEmpty) {
      _tutorialStates = {};
      return;
    }

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _tutorialStates = jsonMap.map(
        (key, value) => MapEntry(
          key,
          TutorialState.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      debugPrint('TooltipService: Failed to parse tutorial states - $e');
      _tutorialStates = {};
    }
  }

  Future<void> _saveTooltipStates() async {
    final jsonMap = _tooltipStates.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await _storageService.saveString(
      TooltipStorageKeys.tooltipStates,
      json.encode(jsonMap),
    );
  }

  Future<void> _saveTutorialStates() async {
    final jsonMap = _tutorialStates.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await _storageService.saveString(
      TooltipStorageKeys.tutorialStates,
      json.encode(jsonMap),
    );
  }

  @override
  Future<TutorialState> getTooltipState(String tooltipId) async {
    await _ensureInitialized();
    return _tooltipStates[tooltipId] ?? TutorialState.initial(tooltipId);
  }

  @override
  Future<TutorialState> getTutorialState(String tutorialId) async {
    await _ensureInitialized();
    return _tutorialStates[tutorialId] ?? TutorialState.initial(tutorialId);
  }

  @override
  Future<void> markTooltipShown(String tooltipId) async {
    await _ensureInitialized();
    final currentState =
        _tooltipStates[tooltipId] ?? TutorialState.initial(tooltipId);

    _tooltipStates[tooltipId] = currentState.copyWith(
      status: TutorialStateStatus.showing,
      lastShownAt: DateTime.now(),
      showCount: currentState.showCount + 1,
    );

    await _saveTooltipStates();
  }

  @override
  Future<void> markTooltipDismissed(String tooltipId) async {
    await _ensureInitialized();
    final currentState =
        _tooltipStates[tooltipId] ?? TutorialState.initial(tooltipId);

    _tooltipStates[tooltipId] = currentState.copyWith(
      status: TutorialStateStatus.dismissed,
    );

    await _saveTooltipStates();
  }

  @override
  Future<void> markTooltipPermanentlyDismissed(String tooltipId) async {
    await _ensureInitialized();
    final currentState =
        _tooltipStates[tooltipId] ?? TutorialState.initial(tooltipId);

    _tooltipStates[tooltipId] = currentState.copyWith(
      status: TutorialStateStatus.permanentlyDismissed,
      completedAt: DateTime.now(),
    );

    await _saveTooltipStates();
  }

  @override
  Future<void> markTutorialStarted(String tutorialId) async {
    await _ensureInitialized();
    final currentState =
        _tutorialStates[tutorialId] ?? TutorialState.initial(tutorialId);

    _tutorialStates[tutorialId] = currentState.copyWith(
      status: TutorialStateStatus.showing,
      lastShownAt: DateTime.now(),
      showCount: currentState.showCount + 1,
      currentStep: 0,
    );

    await _saveTutorialStates();
  }

  @override
  Future<void> updateTutorialProgress(
      String tutorialId, int currentStep) async {
    await _ensureInitialized();
    final currentState =
        _tutorialStates[tutorialId] ?? TutorialState.initial(tutorialId);

    _tutorialStates[tutorialId] = currentState.copyWith(
      currentStep: currentStep,
    );

    await _saveTutorialStates();
  }

  @override
  Future<void> markTutorialCompleted(String tutorialId) async {
    await _ensureInitialized();
    final currentState =
        _tutorialStates[tutorialId] ?? TutorialState.initial(tutorialId);

    _tutorialStates[tutorialId] = currentState.copyWith(
      status: TutorialStateStatus.completed,
      completedAt: DateTime.now(),
    );

    await _saveTutorialStates();
  }

  @override
  Future<void> markTutorialSkipped(String tutorialId) async {
    await _ensureInitialized();
    final currentState =
        _tutorialStates[tutorialId] ?? TutorialState.initial(tutorialId);

    _tutorialStates[tutorialId] = currentState.copyWith(
      status: TutorialStateStatus.skipped,
    );

    await _saveTutorialStates();
  }

  @override
  Future<bool> areTooltipsEnabled() async {
    final enabled =
        await _storageService.getBool(TooltipStorageKeys.tooltipsEnabled);
    return enabled ?? true; // Enabled by default
  }

  @override
  Future<void> setTooltipsEnabled(bool enabled) async {
    await _storageService.saveBool(TooltipStorageKeys.tooltipsEnabled, enabled);
  }

  @override
  Future<bool> areTutorialsEnabled() async {
    final enabled =
        await _storageService.getBool(TooltipStorageKeys.tutorialsEnabled);
    return enabled ?? true; // Enabled by default
  }

  @override
  Future<void> setTutorialsEnabled(bool enabled) async {
    await _storageService.saveBool(
        TooltipStorageKeys.tutorialsEnabled, enabled);
  }

  @override
  Future<void> resetAllTooltips() async {
    _tooltipStates = {};
    await _storageService.remove(TooltipStorageKeys.tooltipStates);
    await _storageService.saveString(
      TooltipStorageKeys.lastResetTimestamp,
      DateTime.now().toIso8601String(),
    );
    debugPrint('TooltipService: All tooltips reset');
  }

  @override
  Future<void> resetAllTutorials() async {
    _tutorialStates = {};
    await _storageService.remove(TooltipStorageKeys.tutorialStates);
    await _storageService.saveString(
      TooltipStorageKeys.lastResetTimestamp,
      DateTime.now().toIso8601String(),
    );
    debugPrint('TooltipService: All tutorials reset');
  }

  @override
  Future<void> resetAll() async {
    await resetAllTooltips();
    await resetAllTutorials();
    debugPrint('TooltipService: All tooltips and tutorials reset');
  }

  @override
  Future<List<String>> getShownTooltipIds() async {
    await _ensureInitialized();
    return _tooltipStates.entries
        .where((e) =>
            e.value.status != TutorialStateStatus.notShown &&
            e.value.showCount > 0)
        .map((e) => e.key)
        .toList();
  }

  @override
  Future<List<String>> getCompletedTutorialIds() async {
    await _ensureInitialized();
    return _tutorialStates.entries
        .where((e) => e.value.status == TutorialStateStatus.completed)
        .map((e) => e.key)
        .toList();
  }

  @override
  Future<bool> shouldShowTooltip(String tooltipId) async {
    final enabled = await areTooltipsEnabled();
    if (!enabled) return false;

    final state = await getTooltipState(tooltipId);
    return state.shouldShow;
  }

  @override
  Future<bool> shouldShowTutorial(String tutorialId) async {
    final enabled = await areTutorialsEnabled();
    if (!enabled) return false;

    final state = await getTutorialState(tutorialId);
    return state.shouldShow;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }
}
