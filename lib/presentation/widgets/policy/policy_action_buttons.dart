/// MSME Pathways - Policy Action Buttons Widget
/// 
/// Accept and Decline buttons for policy screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Action buttons for accepting or declining policies.
class PolicyActionButtons extends StatelessWidget {
  /// Creates the policy action buttons.
  const PolicyActionButtons({
    super.key,
    required this.canAccept,
    required this.onAccept,
    required this.onDecline,
    this.isLoading = false,
  });

  /// Whether the accept button should be enabled.
  final bool canAccept;

  /// Callback when accept button is pressed.
  final VoidCallback onAccept;

  /// Callback when decline is pressed.
  final VoidCallback onDecline;

  /// Whether an action is in progress.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Accept button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Semantics(
            label: canAccept 
                ? 'Accept and continue' 
                : 'Please check the agreement box first',
            button: true,
            enabled: canAccept && !isLoading,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: canAccept 
                    ? AppColors.primaryGradient 
                    : null,
                color: canAccept ? null : AppColors.backgroundSubtle,
                borderRadius: BorderRadius.circular(16),
                boxShadow: canAccept
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canAccept && !isLoading ? onAccept : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                canAccept 
                                    ? AppColors.textLight 
                                    : AppColors.textTertiary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: canAccept 
                                    ? AppColors.textLight 
                                    : AppColors.textTertiary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Accept & Continue',
                                style: AppTextStyles.button.copyWith(
                                  color: canAccept 
                                      ? AppColors.textLight 
                                      : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 200.ms),
        
        const SizedBox(height: 12),
        
        // Decline text button
        Semantics(
          label: 'Decline and go back',
          button: true,
          child: TextButton(
            onPressed: isLoading ? null : onDecline,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Decline',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isLoading 
                    ? AppColors.textTertiary 
                    : AppColors.textSecondary,
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms, delay: 300.ms),
      ],
    );
  }
}
