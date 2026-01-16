/// MSME Pathways - Terms & Privacy Screen
/// 
/// Main screen for displaying Terms of Service and Privacy Policy.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../viewmodels/terms_privacy_viewmodel.dart';
import '../../widgets/legal/acceptance_checkbox.dart';
import '../../widgets/legal/policy_action_buttons.dart';
import '../../widgets/legal/policy_content_card.dart';
import '../../widgets/legal/policy_tab_view.dart';

/// Terms & Privacy Policy screen.
/// 
/// Displays Terms of Service and Privacy Policy with tab navigation.
/// Users must accept before proceeding to registration/login.
class TermsPrivacyScreen extends StatelessWidget {
  /// Creates the terms and privacy screen.
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TermsPrivacyViewModel(),
      child: const _TermsPrivacyContent(),
    );
  }
}

/// Internal content widget with access to ViewModel.
class _TermsPrivacyContent extends StatefulWidget {
  const _TermsPrivacyContent();

  @override
  State<_TermsPrivacyContent> createState() => _TermsPrivacyContentState();
}

class _TermsPrivacyContentState extends State<_TermsPrivacyContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    
    // Set system UI for light background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      context.read<TermsPrivacyViewModel>().changeTab(_tabController.index);
      // Reset scroll position when switching tabs
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<TermsPrivacyViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const _LoadingState();
            }

            if (viewModel.error != null) {
              return _ErrorState(
                error: viewModel.error!,
                onRetry: () {
                  // Recreate ViewModel to retry loading
                  context.read<TermsPrivacyViewModel>();
                },
              );
            }

            return Column(
              children: [
                // Header
                _buildHeader(viewModel),
                
                const SizedBox(height: 16),
                
                // Tab navigation
                PolicyTabView(
                  tabController: _tabController,
                  onTabChanged: (index) {
                    _tabController.animateTo(index);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Content area
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Terms of Service
                      PolicyContentCard(
                        sections: viewModel.termsSections,
                        onSectionToggle: viewModel.toggleSection,
                        scrollController: _scrollController,
                        onExpandAll: viewModel.expandAll,
                        onCollapseAll: viewModel.collapseAll,
                      ),
                      // Privacy Policy
                      PolicyContentCard(
                        sections: viewModel.privacySections,
                        onSectionToggle: viewModel.toggleSection,
                        scrollController: _scrollController,
                        onExpandAll: viewModel.expandAll,
                        onCollapseAll: viewModel.collapseAll,
                      ),
                    ],
                  ),
                ),
                
                // Bottom action section
                _buildBottomSection(viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(TermsPrivacyViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          // App logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/msmeLogo.png',
                fit: BoxFit.cover,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms),
          
          const SizedBox(width: 16),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Privacy Policy',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 18,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideX(begin: 0.1, end: 0, duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 2),
                Text(
                  'Please review before continuing',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideX(begin: 0.1, end: 0, duration: 400.ms, delay: 200.ms),
              ],
            ),
          ),
          
          // Version badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundSubtle,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'v${viewModel.policyVersion}',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildBottomSection(TermsPrivacyViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Acceptance checkbox
          AcceptanceCheckbox(
            value: viewModel.hasAccepted,
            onChanged: (_) => viewModel.toggleAcceptance(),
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          PolicyActionButtons(
            canAccept: viewModel.canProceed,
            isLoading: _isProcessing,
            onAccept: () => _handleAccept(viewModel),
            onDecline: _handleDecline,
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept(TermsPrivacyViewModel viewModel) async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    try {
      final success = await viewModel.acceptAndContinue();
      
      if (success && mounted) {
        // Navigate to user type selector screen
        context.go('/user-type');
      } else if (mounted) {
        _showErrorSnackbar('Failed to save acceptance. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('An error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handleDecline() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Decline Terms?',
          style: AppTextStyles.headlineSmall,
        ),
        content: Text(
          'You must accept the Terms of Service and Privacy Policy to use MSME Pathways. Would you like to go back?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Stay',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/onboarding');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/msmeLogo.png',
            width: 80,
            height: 80,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeIn(duration: 600.ms)
              .then()
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 24),
          Text(
            'Loading policies...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Policies',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
