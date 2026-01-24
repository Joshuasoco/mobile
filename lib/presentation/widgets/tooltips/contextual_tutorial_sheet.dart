/// MSME Pathways - Contextual Tutorial Sheet
///
/// A bottom sheet component for step-by-step contextual tutorials
/// with progress indicators and navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/tooltip_model.dart';

/// A bottom sheet for displaying contextual tutorials.
class ContextualTutorialSheet extends StatelessWidget {
  const ContextualTutorialSheet({
    super.key,
    required this.tutorial,
    required this.currentStepIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onComplete,
    this.onStepTap,
  });

  /// The tutorial configuration.
  final TutorialConfig tutorial;

  /// Current step index (0-based).
  final int currentStepIndex;

  /// Callback for next step.
  final VoidCallback onNext;

  /// Callback for previous step.
  final VoidCallback onPrevious;

  /// Callback to skip tutorial.
  final VoidCallback onSkip;

  /// Callback when tutorial is completed.
  final VoidCallback onComplete;

  /// Callback when a progress dot is tapped.
  final ValueChanged<int>? onStepTap;

  bool get isFirstStep => currentStepIndex == 0;
  bool get isLastStep => currentStepIndex == tutorial.steps.length - 1;
  TutorialStep get currentStep => tutorial.steps[currentStepIndex];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header with title and skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tutorial.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Step ${currentStepIndex + 1} of ${tutorial.steps.length}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (tutorial.canSkip)
                    TextButton(
                      onPressed: onSkip,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: _buildProgressDots(),
            ),

            // Step content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStepContent()
                  .animate(key: ValueKey(currentStepIndex))
                  .fadeIn(duration: 200.ms)
                  .slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 200.ms,
                    curve: Curves.easeOut,
                  ),
            ),

            const SizedBox(height: 24),

            // Navigation buttons
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
              child: Row(
                children: [
                  // Previous button
                  if (!isFirstStep)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPrevious,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Previous',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  if (!isFirstStep) const SizedBox(width: 12),

                  // Next/Complete button
                  Expanded(
                    flex: isFirstStep ? 2 : 1,
                    child: ElevatedButton(
                      onPressed: isLastStep ? onComplete : onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastStep ? 'Get Started' : 'Next',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isLastStep ? Icons.check : Icons.arrow_forward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildProgressDots() {
    // Using explicit teal color to ensure correct theming
    const Color activeDotColor = Color(0xFF0D7377); // Teal primary
    const Color completedDotColor = Color(0xFF14919B); // Teal light
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tutorial.steps.length, (index) {
        final isActive = index == currentStepIndex;
        final isCompleted = index < currentStepIndex;

        return GestureDetector(
          onTap: onStepTap != null ? () => onStepTap!(index) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? activeDotColor
                  : isCompleted
                      ? completedDotColor
                      : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step icon
        if (currentStep.iconData != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              currentStep.iconData,
              size: 32,
              color: AppColors.primary,
            ),
          ),

        // Step image
        if (currentStep.imagePath != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                currentStep.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Step title
        Text(
          currentStep.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        // Step description
        Text(
          currentStep.description,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// A modal presentation wrapper for the tutorial sheet.
class TutorialModal extends StatelessWidget {
  const TutorialModal({
    super.key,
    required this.tutorial,
    required this.currentStepIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onComplete,
    this.highlightRect,
    this.onBackdropTap,
  });

  final TutorialConfig tutorial;
  final int currentStepIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final VoidCallback onComplete;
  final Rect? highlightRect;
  final VoidCallback? onBackdropTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dimmed backdrop with optional highlight
        Positioned.fill(
          child: GestureDetector(
            onTap: onBackdropTap,
            behavior: HitTestBehavior.opaque,
            child: highlightRect != null
                ? CustomPaint(
                    painter: _SpotlightBackdropPainter(
                      highlightRect: highlightRect!,
                    ),
                  )
                : Container(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
          ),
        ),

        // Tutorial sheet at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ContextualTutorialSheet(
            tutorial: tutorial,
            currentStepIndex: currentStepIndex,
            onNext: onNext,
            onPrevious: onPrevious,
            onSkip: onSkip,
            onComplete: onComplete,
          ),
        ),
      ],
    );
  }
}

/// Painter for spotlight backdrop in tutorial modal.
class _SpotlightBackdropPainter extends CustomPainter {
  _SpotlightBackdropPainter({required this.highlightRect});

  final Rect highlightRect;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final innerRect = RRect.fromRectAndRadius(
      highlightRect.inflate(8),
      const Radius.circular(12),
    );

    final path = Path()
      ..addRect(outerRect)
      ..addRRect(innerRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightBackdropPainter oldDelegate) {
    return oldDelegate.highlightRect != highlightRect;
  }
}
