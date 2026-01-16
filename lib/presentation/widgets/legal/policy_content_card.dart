/// MSME Pathways - Policy Content Card Widget
/// 
/// Scrollable container for policy sections.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/policy_section_model.dart';
import 'policy_section.dart';

/// Scrollable card container for policy content sections.
class PolicyContentCard extends StatelessWidget {
  /// Creates the policy content card.
  const PolicyContentCard({
    super.key,
    required this.sections,
    required this.onSectionToggle,
    required this.scrollController,
    this.onExpandAll,
    this.onCollapseAll,
  });

  /// List of policy sections to display.
  final List<PolicySectionModel> sections;

  /// Callback when a section is toggled.
  final void Function(String sectionId) onSectionToggle;

  /// Scroll controller for the content.
  final ScrollController scrollController;

  /// Callback to expand all sections.
  final VoidCallback? onExpandAll;

  /// Callback to collapse all sections.
  final VoidCallback? onCollapseAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundSubtle,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.backgroundSubtle,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Quick actions bar
            _buildQuickActions(),
            
            // Sections list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return PolicySection(
                    section: section,
                    onToggle: () => onSectionToggle(section.id),
                    animationDelay: Duration(milliseconds: 50 * index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final hasExpanded = sections.any((s) => s.isExpanded);
    final allExpanded = sections.every((s) => s.isExpanded);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.backgroundSubtle,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Section count
          Text(
            '${sections.length} sections',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const Spacer(),
          
          // Expand/Collapse buttons
          if (onExpandAll != null && onCollapseAll != null) ...[
            TextButton.icon(
              onPressed: allExpanded ? null : onExpandAll,
              icon: Icon(
                Icons.unfold_more_rounded,
                size: 16,
                color: allExpanded 
                    ? AppColors.textTertiary 
                    : AppColors.primary,
              ),
              label: Text(
                'Expand',
                style: AppTextStyles.labelSmall.copyWith(
                  color: allExpanded 
                      ? AppColors.textTertiary 
                      : AppColors.primary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
              ),
            ),
            Container(
              width: 1,
              height: 16,
              color: AppColors.backgroundSubtle,
            ),
            TextButton.icon(
              onPressed: hasExpanded ? onCollapseAll : null,
              icon: Icon(
                Icons.unfold_less_rounded,
                size: 16,
                color: hasExpanded 
                    ? AppColors.primary 
                    : AppColors.textTertiary,
              ),
              label: Text(
                'Collapse',
                style: AppTextStyles.labelSmall.copyWith(
                  color: hasExpanded 
                      ? AppColors.primary 
                      : AppColors.textTertiary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
