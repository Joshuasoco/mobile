/// MSME Pathways - User Type Selector Screen
/// 
/// Post-onboarding screen for selecting user type (Individual or Business).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_type_model.dart';
import '../../viewmodels/user_type_viewmodel.dart';
import '../../widgets/onboarding/user_type_card.dart';

/// User type selector screen.
/// 
/// Allows users to identify as Individual or Business/MSME
/// for personalized loan journeys.
class UserTypeSelectorScreen extends StatelessWidget {
  /// Creates the user type selector screen.
  const UserTypeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserTypeViewModel(),
      child: const _UserTypeSelectorContent(),
    );
  }
}

/// Internal content widget with access to ViewModel.
class _UserTypeSelectorContent extends StatefulWidget {
  const _UserTypeSelectorContent();

  @override
  State<_UserTypeSelectorContent> createState() => _UserTypeSelectorContentState();
}

class _UserTypeSelectorContentState extends State<_UserTypeSelectorContent> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Set system UI for light background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<UserTypeViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const _LoadingState();
            }

            return Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Logo
                        _buildLogo(),
                        
                        const SizedBox(height: 32),
                        
                        // Headline
                        _buildHeadline(),
                        
                        const SizedBox(height: 32),
                        
                        // User type cards
                        _buildUserTypeCards(viewModel),
                        
                        const SizedBox(height: 24),
                        
                        // Security note
                        _buildSecurityNote(),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                
                // Bottom CTA
                _buildBottomCTA(viewModel),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/msmeLogo.png',
          fit: BoxFit.cover,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildHeadline() {
    return Text(
      AppStrings.userTypeHeadline,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 100.ms);
  }

  Widget _buildUserTypeCards(UserTypeViewModel viewModel) {
    return Column(
      children: [
        // Individual card
        UserTypeCard(
          model: viewModel.options[0],
          isSelected: viewModel.selectedType == UserType.individual,
          onTap: () => viewModel.selectType(UserType.individual),
          animationDelay: 200.ms,
        ),
        
        const SizedBox(height: 16),
        
        // Business card
        UserTypeCard(
          model: viewModel.options[1],
          isSelected: viewModel.selectedType == UserType.business,
          onTap: () => viewModel.selectType(UserType.business),
          animationDelay: 300.ms,
        ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 8),
        Text(
          AppStrings.userTypeSecurityNote,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 400.ms);
  }

  Widget _buildBottomCTA(UserTypeViewModel viewModel) {
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
          // Error message
          if (viewModel.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 20,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.error!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Continue button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: viewModel.canContinue && !_isProcessing
                  ? () => _handleContinue(viewModel)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.textTertiary.withValues(alpha: 0.3),
                disabledForegroundColor: AppColors.textTertiary,
                elevation: viewModel.canContinue ? 4 : 0,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppStrings.userTypeContinue,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: 500.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 500.ms);
  }

  Future<void> _handleContinue(UserTypeViewModel viewModel) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final success = await viewModel.saveAndContinue();

      if (success && mounted) {
        // Navigate to login screen
        context.go('/login');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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
            'Loading...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
