// MSME Pathways - Eligibility Checker Widgets
// 
// Reusable step widgets for the eligibility checker flow.


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/eligibility_model.dart';

/// Selection option card widget.
/// 
/// Used for business type, business age, and loan amount steps.
class SelectionOptionCard extends StatelessWidget {
  /// Creates a selection option card.
  const SelectionOptionCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.subtitle,
  });

  /// Option label text.
  final String label;
  
  /// Whether this option is selected.
  final bool isSelected;
  
  /// Callback when tapped.
  final VoidCallback onTap;
  
  /// Optional icon.
  final IconData? icon;
  
  /// Optional subtitle.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFF1565C0).withValues(alpha: 0.1),
        highlightColor: const Color(0xFF1565C0).withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1565C0).withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1565C0).withValues(alpha: 0.1)
                      : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF718096),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF2D3748),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

/// Checkbox option for documents step.
class DocumentCheckbox extends StatelessWidget {
  /// Creates a document checkbox.
  const DocumentCheckbox({
    super.key,
    required this.document,
    required this.isChecked,
    required this.onChanged,
  });

  /// The document type.
  final AvailableDocument document;
  
  /// Whether checked.
  final bool isChecked;
  
  /// Callback when changed.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isChecked ? const Color(0xFF4CAF50).withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChecked ? const Color(0xFF4CAF50) : const Color(0xFFE2E8F0),
            width: isChecked ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF4CAF50) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isChecked ? const Color(0xFF4CAF50) : const Color(0xFFCBD5E0),
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                document.label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: isChecked ? FontWeight.w500 : FontWeight.w400,
                  color: isChecked ? const Color(0xFF2D3748) : const Color(0xFF4A5568),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Income slider with formatted labels.
class IncomeSlider extends StatelessWidget {
  /// Creates an income slider.
  const IncomeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.formatLabel,
  });

  /// Current value.
  final double value;
  
  /// Callback when value changes.
  final ValueChanged<double> onChanged;
  
  /// Minimum value.
  final double min;
  
  /// Maximum value.
  final double max;
  
  /// Label formatter function.
  final String Function(double) formatLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Current value display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            formatLabel(value),
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1565C0),
            ),
          ),
        ),
        const SizedBox(height: 32),
        
        // Slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF1565C0),
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: const Color(0xFF1565C0),
            overlayColor: const Color(0xFF1565C0).withValues(alpha: 0.1),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
        
        // Min/Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatLabel(min),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),
              ),
              Text(
                formatLabel(max),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Step progress indicator.
class StepProgressIndicator extends StatelessWidget {
  /// Creates a step progress indicator.
  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  /// Current step (0-indexed).
  final int currentStep;
  
  /// Total number of steps.
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 6 : 0),
            height: isCurrent ? 6 : 4,
            decoration: BoxDecoration(
              gradient: isCompleted || isCurrent
                  ? const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isCompleted || isCurrent ? null : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(3),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

/// Action button for eligibility flow.
class EligibilityActionButton extends StatelessWidget {
  /// Creates an action button.
  const EligibilityActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isPrimary = true,
  });

  /// Button label.
  final String label;
  
  /// Callback when pressed.
  final VoidCallback? onPressed;
  
  /// Whether button is enabled.
  final bool isEnabled;
  
  /// Whether this is a primary button.
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary && isEnabled
            ? const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: isPrimary && isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: !isPrimary
                  ? Colors.white
                  : (!isEnabled ? const Color(0xFFE2E8F0) : null),
              border: !isPrimary
                  ? const Border.fromBorderSide(
                      BorderSide(color: Color(0xFF1565C0), width: 2),
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: !isEnabled
                    ? const Color(0xFF718096)
                    : (isPrimary ? Colors.white : const Color(0xFF1565C0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
