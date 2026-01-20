/// MSME Pathways - Form Widgets
/// 
/// Reusable form components for alternative data input.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/alternative_data_model.dart';

/// Step progress indicator for multi-step forms.
class FormStepIndicator extends StatelessWidget {
  /// Current step (0-indexed).
  final int currentStep;
  
  /// Total number of steps.
  final int totalSteps;
  
  /// Optional step labels.
  final List<String>? labels;

  /// Creates a form step indicator.
  const FormStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        
        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primary
                      : isCurrent
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCurrent
                                ? AppColors.primary
                                : const Color(0xFF718096),
                          ),
                        ),
                ),
              ),
              
              // Connecting line
              if (index < totalSteps - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: isCompleted
                        ? AppColors.primary
                        : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// Styled text form field.
class FormTextField extends StatelessWidget {
  /// Controller for the field.
  final TextEditingController controller;
  
  /// Field label.
  final String label;
  
  /// Hint text.
  final String? hint;
  
  /// Prefix icon.
  final IconData? prefixIcon;
  
  /// Suffix text (e.g., "years", "PHP").
  final String? suffixText;
  
  /// Keyboard type.
  final TextInputType? keyboardType;
  
  /// Validator function.
  final String? Function(String?)? validator;
  
  /// Whether this is required.
  final bool isRequired;
  
  /// Maximum lines.
  final int maxLines;

  /// Creates a form text field.
  const FormTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixText,
    this.keyboardType,
    this.validator,
    this.isRequired = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        
        // Text field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: const Color(0xFF2D3748),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFFA0AEC0),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: const Color(0xFF718096), size: 22)
                : null,
            suffixText: suffixText,
            suffixStyle: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF718096),
            ),
            filled: true,
            fillColor: const Color(0xFFF7FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

/// Selection option card for single-choice options.
class FormOptionCard<T> extends StatelessWidget {
  /// Option value.
  final T value;
  
  /// Option label.
  final String label;
  
  /// Option description.
  final String? description;
  
  /// Icon name or IconData.
  final dynamic icon;
  
  /// Whether this is selected.
  final bool isSelected;
  
  /// Callback when tapped.
  final VoidCallback onTap;

  /// Creates a form option card.
  const FormOptionCard({
    super.key,
    required this.value,
    required this.label,
    this.description,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon is IconData ? icon : _getIconData(icon.toString()),
                  color: isSelected ? AppColors.primary : const Color(0xFF718096),
                  size: 22,
                ),
              ),
            
            if (icon != null) const SizedBox(width: 14),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF2D3748),
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Check indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF5F7FA),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'home':
        return Icons.home_rounded;
      case 'storefront':
        return Icons.storefront_rounded;
      case 'store':
        return Icons.store_rounded;
      case 'directions_walk':
        return Icons.directions_walk_rounded;
      default:
        return Icons.business_rounded;
    }
  }
}

/// Month selector widget.
class MonthSelector extends StatelessWidget {
  /// Selected months (1-12).
  final List<int> selectedMonths;
  
  /// Label for the section.
  final String label;
  
  /// Color for selected months.
  final Color selectedColor;
  
  /// Callback when a month is toggled.
  final void Function(int) onToggle;
  
  /// Months to disable (already selected elsewhere).
  final List<int>? disabledMonths;

  /// Creates a month selector.
  const MonthSelector({
    super.key,
    required this.selectedMonths,
    required this.label,
    required this.selectedColor,
    required this.onToggle,
    this.disabledMonths,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(12, (index) {
            final month = index + 1;
            final isSelected = selectedMonths.contains(month);
            final isDisabled = disabledMonths?.contains(month) ?? false;
            
            return GestureDetector(
              onTap: isDisabled ? null : () => onToggle(month),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor
                      : isDisabled
                          ? const Color(0xFFE2E8F0)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? selectedColor
                        : isDisabled
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  MonthNames.short[index],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isDisabled
                            ? const Color(0xFFA0AEC0)
                            : const Color(0xFF2D3748),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Income slider field with formatted display.
class IncomeSliderField extends StatelessWidget {
  /// Current value.
  final double value;
  
  /// Minimum value.
  final double min;
  
  /// Maximum value.
  final double max;
  
  /// Label for the field.
  final String label;
  
  /// Callback when value changes.
  final void Function(double) onChanged;

  /// Creates an income slider field.
  const IncomeSliderField({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatCurrency(value),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / 1000).round(),
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatCurrency(min),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF718096),
              ),
            ),
            Text(
              _formatCurrency(max),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '₱${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '₱${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₱${amount.toStringAsFixed(0)}';
  }
}

/// Score display gauge.
class ScoreGauge extends StatelessWidget {
  /// Score value (0-100).
  final int score;
  
  /// Size of the gauge.
  final double size;
  
  /// Label text.
  final String? label;

  /// Creates a score gauge.
  const ScoreGauge({
    super.key,
    required this.score,
    this.size = 150,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    if (score >= 80) {
      scoreColor = AppColors.success;
    } else if (score >= 60) {
      scoreColor = AppColors.primary;
    } else if (score >= 40) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                strokeWidth: size * 0.08,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: GoogleFonts.poppins(
                        fontSize: size * 0.28,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                      ),
                    ),
                    Text(
                      'out of 100',
                      style: GoogleFonts.inter(
                        fontSize: size * 0.09,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 12),
          Text(
            label!,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: scoreColor,
            ),
          ),
        ],
      ],
    );
  }
}
