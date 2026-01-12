/// MSME Pathways - Policy Tab View Widget
/// 
/// TabBar navigation for Terms of Service and Privacy Policy.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// TabBar widget for switching between Terms and Privacy sections.
class PolicyTabView extends StatelessWidget {
  /// Creates the policy tab view.
  const PolicyTabView({
    super.key,
    required this.tabController,
    required this.onTabChanged,
  });

  /// Controller for tab navigation.
  final TabController tabController;

  /// Callback when tab changes.
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundSubtle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        // Indicator styling
        indicator: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        // Tab styling
        dividerColor: Colors.transparent,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.titleSmall,
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        // Splash effect
        splashBorderRadius: BorderRadius.circular(10),
        overlayColor: WidgetStatePropertyAll(
          AppColors.primary.withValues(alpha: 0.1),
        ),
        // Tab content
        tabs: [
          _buildTab(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            semanticLabel: 'Terms of Service tab',
          ),
          _buildTab(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            semanticLabel: 'Privacy Policy tab',
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required String semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      child: Tab(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
