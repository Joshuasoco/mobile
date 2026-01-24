/// MSME Pathways - Tooltip Overlay Widget
///
/// A top-level overlay widget that manages tooltip and tutorial display
/// across the entire application.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/tooltip_model.dart';
import '../../viewmodels/contextual_tutorial_viewmodel.dart';
import '../../viewmodels/tooltip_viewmodel.dart';
import 'contextual_tutorial_sheet.dart';
import 'tooltip_bubble.dart';
import 'tooltip_highlight.dart';

/// A widget that provides tooltip and tutorial overlay functionality.
///
/// Wrap your app's main content with this widget to enable tooltips.
/// Uses the TooltipViewModel and ContextualTutorialViewModel from Provider.
class TooltipOverlayManager extends StatelessWidget {
  const TooltipOverlayManager({
    super.key,
    required this.child,
  });

  /// The main app content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        child,

        // Tooltip overlay
        Consumer<TooltipViewModel>(
          builder: (context, viewModel, _) {
            if (!viewModel.isActive || viewModel.currentTooltip == null) {
              return const SizedBox.shrink();
            }

            return _TooltipOverlayContent(
              viewModel: viewModel,
            );
          },
        ),

        // Tutorial overlay
        Consumer<ContextualTutorialViewModel>(
          builder: (context, viewModel, _) {
            if (!viewModel.isShowingTutorial ||
                viewModel.currentTutorial == null) {
              return const SizedBox.shrink();
            }

            return _TutorialOverlayContent(
              viewModel: viewModel,
            );
          },
        ),
      ],
    );
  }
}

/// Content for the tooltip overlay.
class _TooltipOverlayContent extends StatelessWidget {
  const _TooltipOverlayContent({
    required this.viewModel,
  });

  final TooltipViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final tooltip = viewModel.currentTooltip!;
    final targetRect = viewModel.targetRect;

    if (targetRect == null) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    
    // Account for bottom navigation bar and safe areas
    // Typical bottom nav height is ~60-80, plus safe area
    final bottomNavHeight = 80.0;
    final bottomSafeArea = mediaQuery.padding.bottom;
    final topSafeArea = mediaQuery.padding.top;
    
    // Usable screen area (excluding nav bars and safe areas)
    final usableHeight = screenSize.height - bottomNavHeight - bottomSafeArea - topSafeArea;

    // Calculate optimal position with bottom nav consideration
    final position = TooltipPositionCalculator.calculateBestPosition(
      targetRect: targetRect,
      screenSize: screenSize,
      bottomInset: bottomNavHeight + bottomSafeArea,
      topInset: topSafeArea,
    );

    // Calculate tooltip offset
    const tooltipSize = Size(280, 180);
    final offset = TooltipPositionCalculator.calculateOffset(
      targetRect: targetRect,
      tooltipSize: tooltipSize,
      screenSize: screenSize,
      position: position,
      bottomInset: bottomNavHeight + bottomSafeArea,
      topInset: topSafeArea,
    );

    return TooltipHighlight(
      targetRect: targetRect,
      onBackdropTap:
          tooltip.dismissible ? () => viewModel.dismissCurrentTooltip() : null,
      child: Positioned(
        left: offset.dx,
        top: offset.dy,
        child: TooltipBubble(
          config: tooltip,
          position: position,
          onDismiss: () => viewModel.dismissCurrentTooltip(),
          onDontShowAgain: tooltip.showDontShowAgain
              ? () => viewModel.dismissPermanently()
              : null,
          onSkipAll: viewModel.totalTooltips > 1
              ? () => viewModel.skipAllTooltips()
              : null,
          showProgress: viewModel.totalTooltips > 1,
          currentIndex: viewModel.currentIndex,
          totalCount: viewModel.totalTooltips,
        ),
      ),
    );
  }
}

/// Content for the tutorial overlay.
class _TutorialOverlayContent extends StatelessWidget {
  const _TutorialOverlayContent({
    required this.viewModel,
  });

  final ContextualTutorialViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TutorialModal(
      tutorial: viewModel.currentTutorial!,
      currentStepIndex: viewModel.currentStepIndex,
      highlightRect: viewModel.highlightRect,
      onNext: () => viewModel.nextStep(),
      onPrevious: () => viewModel.previousStep(),
      onSkip: () => viewModel.skipTutorial(),
      onComplete: () => viewModel.completeTutorial(),
    );
  }
}

/// A mixin that provides tooltip functionality to screens.
///
/// Use this mixin in your StatefulWidget state classes to easily
/// trigger tooltips when the screen is first shown.
mixin TooltipScreenMixin<T extends StatefulWidget> on State<T> {
  /// Override this to define the tooltips for this screen.
  List<TooltipConfig> get screenTooltips => [];

  /// Override this to define the tutorial for this screen.
  TutorialConfig? get screenTutorial => null;

  /// Whether to auto-show tooltips when screen loads.
  bool get autoShowTooltips => true;

  /// Whether to auto-show tutorial when screen loads.
  bool get autoShowTutorial => true;

  /// Delay before showing tooltips (in milliseconds).
  int get tooltipDelay => 500;

  bool _tooltipsTriggered = false;

  @override
  void initState() {
    super.initState();
    if (autoShowTooltips || autoShowTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerTooltipsAndTutorials();
      });
    }
  }

  Future<void> _triggerTooltipsAndTutorials() async {
    if (_tooltipsTriggered) return;
    _tooltipsTriggered = true;

    // Capture ViewModels before async gap
    final tutorialViewModel = autoShowTutorial && screenTutorial != null
        ? context.read<ContextualTutorialViewModel>()
        : null;
    final tooltipViewModel = autoShowTooltips && screenTooltips.isNotEmpty
        ? context.read<TooltipViewModel>()
        : null;

    // Wait for initial delay
    await Future.delayed(Duration(milliseconds: tooltipDelay));

    if (!mounted) return;

    // Try to show tutorial first
    if (tutorialViewModel != null && screenTutorial != null) {
      final started = await tutorialViewModel.startTutorial(screenTutorial!);
      if (started) return; // Don't show tooltips if tutorial is showing
    }

    // Then show tooltips
    if (tooltipViewModel != null && screenTooltips.isNotEmpty) {
      await tooltipViewModel.startTooltipSequence(screenTooltips);
    }
  }

  /// Manually trigger tooltips (can be called from subclass).
  Future<void> triggerTooltips() async {
    if (screenTooltips.isEmpty || !mounted) return;
    final viewModel = context.read<TooltipViewModel>();
    await viewModel.startTooltipSequence(screenTooltips);
  }

  /// Manually trigger tutorial (can be called from subclass).
  Future<void> triggerTutorial() async {
    if (screenTutorial == null || !mounted) return;
    final viewModel = context.read<ContextualTutorialViewModel>();
    await viewModel.forceStartTutorial(screenTutorial!);
  }
}

/// Extension to show tutorials via BuildContext.
extension TooltipContextExtension on BuildContext {
  /// Show a single tooltip.
  Future<void> showTooltip(TooltipConfig tooltip) async {
    final viewModel = read<TooltipViewModel>();
    await viewModel.showTooltip(tooltip);
  }

  /// Show a sequence of tooltips.
  Future<void> showTooltipSequence(List<TooltipConfig> tooltips) async {
    final viewModel = read<TooltipViewModel>();
    await viewModel.startTooltipSequence(tooltips);
  }

  /// Start a contextual tutorial.
  Future<bool> startTutorial(TutorialConfig tutorial) async {
    final viewModel = read<ContextualTutorialViewModel>();
    return viewModel.startTutorial(tutorial);
  }

  /// Force start a tutorial (ignores completion status).
  Future<void> replayTutorial(TutorialConfig tutorial) async {
    final viewModel = read<ContextualTutorialViewModel>();
    await viewModel.forceStartTutorial(tutorial);
  }

  /// Dismiss current tooltip.
  void dismissTooltip() {
    read<TooltipViewModel>().dismissCurrentTooltip();
  }

  /// Skip all remaining tooltips.
  void skipAllTooltips() {
    read<TooltipViewModel>().skipAllTooltips();
  }

  /// End current tutorial.
  void endTutorial() {
    read<ContextualTutorialViewModel>().endTutorial();
  }
}
