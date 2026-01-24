/// Models for the Feature Tooltips & Contextual Tutorials system.
///
/// These models define the structure for tooltips, tutorials, and their states
/// following the MSME Pathways MVVM architecture.
library;

import 'package:flutter/material.dart';

/// Position of the tooltip relative to the target element.
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Represents a single tooltip configuration.
@immutable
class TooltipConfig {
  const TooltipConfig({
    required this.id,
    required this.targetKey,
    required this.message,
    this.title,
    this.position = TooltipPosition.bottom,
    this.showArrow = true,
    this.dismissible = true,
    this.showDontShowAgain = true,
    this.delayMs = 0,
    this.feature,
  });

  /// Unique identifier for this tooltip (e.g., 'home_calculator_button').
  final String id;

  /// GlobalKey of the target widget to highlight.
  final GlobalKey targetKey;

  /// Main tooltip message (max 10-12 words recommended).
  final String message;

  /// Optional title for the tooltip.
  final String? title;

  /// Position relative to the target element.
  final TooltipPosition position;

  /// Whether to show the arrow pointer.
  final bool showArrow;

  /// Whether the tooltip can be dismissed by tapping outside.
  final bool dismissible;

  /// Whether to show "Don't show again" checkbox.
  final bool showDontShowAgain;

  /// Delay before showing this tooltip (in milliseconds).
  final int delayMs;

  /// Feature category this tooltip belongs to (for grouping).
  final String? feature;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TooltipConfig &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Represents a target element that can receive a tooltip.
@immutable
class TooltipTarget {
  const TooltipTarget({
    required this.key,
    required this.featureId,
    this.screenId,
  });

  /// GlobalKey attached to the target widget.
  final GlobalKey key;

  /// Feature identifier (e.g., 'calculator', 'loan_application').
  final String featureId;

  /// Screen where this target is located.
  final String? screenId;

  /// Gets the render box for position calculation.
  RenderBox? get renderBox {
    final context = key.currentContext;
    if (context == null) return null;
    return context.findRenderObject() as RenderBox?;
  }

  /// Gets the global position of the target.
  Rect? getTargetRect() {
    final box = renderBox;
    if (box == null || !box.hasSize) return null;

    final position = box.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
      position.dx,
      position.dy,
      box.size.width,
      box.size.height,
    );
  }
}

/// Represents a single step in a contextual tutorial.
@immutable
class TutorialStep {
  const TutorialStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.iconData,
    this.imagePath,
    this.targetKey,
    this.highlightTarget = false,
  });

  /// Step number (1-based index).
  final int stepNumber;

  /// Step title (e.g., "Review your eligibility").
  final String title;

  /// Detailed description of what to do in this step.
  final String description;

  /// Optional icon to display.
  final IconData? iconData;

  /// Optional image path to display.
  final String? imagePath;

  /// Optional target element to highlight during this step.
  final GlobalKey? targetKey;

  /// Whether to highlight the target element.
  final bool highlightTarget;
}

/// Configuration for a contextual tutorial.
@immutable
class TutorialConfig {
  const TutorialConfig({
    required this.id,
    required this.featureId,
    required this.title,
    required this.steps,
    this.showOnFirstAccess = true,
    this.canSkip = true,
    this.completionMessage,
  });

  /// Unique identifier for this tutorial.
  final String id;

  /// Feature this tutorial is for (e.g., 'loan_application', 'calculator').
  final String featureId;

  /// Tutorial title shown in header.
  final String title;

  /// List of tutorial steps.
  final List<TutorialStep> steps;

  /// Whether to show automatically on first feature access.
  final bool showOnFirstAccess;

  /// Whether users can skip the tutorial.
  final bool canSkip;

  /// Optional message shown on completion.
  final String? completionMessage;

  int get totalSteps => steps.length;
}

/// State of a tooltip or tutorial.
enum TutorialStateStatus {
  /// Never shown to the user.
  notShown,

  /// Currently being displayed.
  showing,

  /// User dismissed it (may show again).
  dismissed,

  /// User completed all steps.
  completed,

  /// User explicitly skipped.
  skipped,

  /// User selected "Don't show again".
  permanentlyDismissed,
}

/// Tracks the state of a tooltip or tutorial.
@immutable
class TutorialState {
  const TutorialState({
    required this.id,
    required this.status,
    this.lastShownAt,
    this.completedAt,
    this.currentStep = 0,
    this.showCount = 0,
  });

  factory TutorialState.initial(String id) {
    return TutorialState(
      id: id,
      status: TutorialStateStatus.notShown,
    );
  }

  factory TutorialState.fromJson(Map<String, dynamic> json) {
    return TutorialState(
      id: json['id'] as String,
      status: TutorialStateStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TutorialStateStatus.notShown,
      ),
      lastShownAt: json['lastShownAt'] != null
          ? DateTime.parse(json['lastShownAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      currentStep: json['currentStep'] as int? ?? 0,
      showCount: json['showCount'] as int? ?? 0,
    );
  }

  /// Tooltip/tutorial identifier.
  final String id;

  /// Current state status.
  final TutorialStateStatus status;

  /// When the tooltip/tutorial was last shown.
  final DateTime? lastShownAt;

  /// When the tutorial was completed.
  final DateTime? completedAt;

  /// Current step for multi-step tutorials.
  final int currentStep;

  /// Number of times shown to user.
  final int showCount;

  /// Whether this should be shown to the user.
  bool get shouldShow =>
      status == TutorialStateStatus.notShown ||
      status == TutorialStateStatus.dismissed;

  /// Whether user has permanently dismissed this.
  bool get isPermanentlyDismissed =>
      status == TutorialStateStatus.permanentlyDismissed ||
      status == TutorialStateStatus.completed;

  TutorialState copyWith({
    String? id,
    TutorialStateStatus? status,
    DateTime? lastShownAt,
    DateTime? completedAt,
    int? currentStep,
    int? showCount,
  }) {
    return TutorialState(
      id: id ?? this.id,
      status: status ?? this.status,
      lastShownAt: lastShownAt ?? this.lastShownAt,
      completedAt: completedAt ?? this.completedAt,
      currentStep: currentStep ?? this.currentStep,
      showCount: showCount ?? this.showCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name,
      'lastShownAt': lastShownAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'currentStep': currentStep,
      'showCount': showCount,
    };
  }
}

/// Groups tooltips by screen for sequential display.
@immutable
class ScreenTooltipGroup {
  const ScreenTooltipGroup({
    required this.screenId,
    required this.tooltips,
    this.showSequentially = true,
    this.delayBetweenMs = 500,
  });

  /// Screen identifier.
  final String screenId;

  /// Ordered list of tooltips to show on this screen.
  final List<TooltipConfig> tooltips;

  /// Whether to show tooltips one at a time.
  final bool showSequentially;

  /// Delay between sequential tooltips in milliseconds.
  final int delayBetweenMs;
}
