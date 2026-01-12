/// MSME Pathways - Acceptance Checkbox Widget
/// 
/// Custom checkbox for policy acceptance with proper tap target size.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Custom checkbox widget for accepting terms and privacy policy.
/// 
/// Features:
/// - 48x48dp minimum tap target for accessibility
/// - Haptic feedback on tap
/// - Custom styling matching app theme
class AcceptanceCheckbox extends StatelessWidget {
  /// Creates the acceptance checkbox.
  const AcceptanceCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Callback when checkbox is toggled.
  final ValueChanged<bool> onChanged;

  /// Optional custom label widget.
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'I agree to the Terms of Service and Privacy Policy',
      checked: value,
      child: InkWell(
        onTap: () {
          // Haptic feedback
          HapticFeedback.selectionClick();
          onChanged(!value);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox container with 48x48 tap target
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: value ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: value ? AppColors.primary : AppColors.textTertiary,
                        width: 2,
                      ),
                      boxShadow: value
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedScale(
                      scale: value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Label
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: label ?? _buildDefaultLabel(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultLabel() {
    return Text.rich(
      TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        children: const [
          TextSpan(text: 'I have read and agree to the '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
