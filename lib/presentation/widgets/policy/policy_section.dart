/// MSME Pathways - Policy Section Widget
/// 
/// Expandable section for displaying policy content.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/policy_section_model.dart';

/// Expandable section widget for policy content.
class PolicySection extends StatelessWidget {
  /// Creates a policy section.
  const PolicySection({
    super.key,
    required this.section,
    required this.onToggle,
    this.animationDelay = Duration.zero,
  });

  /// The section model containing title and content.
  final PolicySectionModel section;

  /// Callback when section is toggled.
  final VoidCallback onToggle;

  /// Animation delay for staggered entrance.
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${section.title}, ${section.isExpanded ? "expanded" : "collapsed"}',
      button: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: section.isExpanded 
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.backgroundSubtle,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (always visible)
            _buildHeader(context),
            
            // Content (animated expand/collapse)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: section.isExpanded 
                  ? CrossFadeState.showSecond 
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: _buildContent(context),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: animationDelay)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: animationDelay);
  }

  Widget _buildHeader(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Section number indicator
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: section.isExpanded 
                    ? AppColors.primary 
                    : AppColors.backgroundSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  section.id.split('_').last,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: section.isExpanded 
                        ? AppColors.textLight 
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Title
            Expanded(
              child: Text(
                section.title.replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                style: AppTextStyles.titleSmall.copyWith(
                  color: section.isExpanded 
                      ? AppColors.primary 
                      : AppColors.textPrimary,
                ),
              ),
            ),
            
            // Expand/collapse icon
            AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: section.isExpanded ? 0.5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: section.isExpanded 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(
            height: 1,
            color: AppColors.backgroundSubtle,
            margin: const EdgeInsets.only(bottom: 12),
          ),
          
          // Main content
          SelectableText(
            section.content,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          
          // Subsections (if any)
          if (section.subsections.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...section.subsections.map((subsection) => _buildSubsection(subsection)),
          ],
        ],
      ),
    );
  }

  Widget _buildSubsection(PolicySubsection subsection) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subsection.title,
            style: AppTextStyles.titleSmall.copyWith(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subsection.content,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
