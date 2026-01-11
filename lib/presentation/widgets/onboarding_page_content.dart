/// MSME Pathways - Onboarding Page Content Widget
/// 
/// Reusable widget for individual onboarding page content
/// with staggered entrance animations.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/onboarding_model.dart';

/// Content widget for a single onboarding page.
/// 
/// Features:
/// - Staggered entrance animations using flutter_animate
/// - Network image loading with caching and error handling
/// - Optional feature grid for the features overview page
/// - Responsive layout with safe area support
class OnboardingPageContent extends StatelessWidget {
  /// Creates an onboarding page content widget.
  const OnboardingPageContent({
    super.key,
    required this.model,
    required this.isActive,
  });

  /// The onboarding page data model
  final OnboardingModel model;

  /// Whether this page is currently active (visible)
  /// Used to trigger entrance animations
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.height < 700;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isSmallScreen ? 16 : 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration - takes up ~40% of available height
          Expanded(
            flex: 4,
            child: _buildIllustration(isSmallScreen),
          ),
          
          SizedBox(height: isSmallScreen ? 24 : 40),
          
          // Text content and optional features
          Expanded(
            flex: model.features != null ? 5 : 3,
            child: Column(
              children: [
                // Title
                _buildTitle()
                    .animate(target: isActive ? 1 : 0)
                    .fadeIn(
                      duration: 500.ms,
                      delay: 200.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 500.ms,
                      delay: 200.ms,
                      curve: Curves.easeOutCubic,
                    ),
                
                SizedBox(height: isSmallScreen ? 12 : 16),
                
                // Subtitle
                _buildSubtitle()
                    .animate(target: isActive ? 1 : 0)
                    .fadeIn(
                      duration: 500.ms,
                      delay: 300.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 500.ms,
                      delay: 300.ms,
                      curve: Curves.easeOutCubic,
                    ),
                
                // Features grid (if available)
                if (model.features != null) ...[
                  SizedBox(height: isSmallScreen ? 20 : 32),
                  Expanded(
                    child: _buildFeaturesGrid()
                        .animate(target: isActive ? 1 : 0)
                        .fadeIn(
                          duration: 500.ms,
                          delay: 400.ms,
                          curve: Curves.easeOut,
                        )
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 500.ms,
                          delay: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the illustration with network image handling.
  Widget _buildIllustration(bool isSmallScreen) {
    final imageUrl = model.imageUrl;
    final isSvg = imageUrl.toLowerCase().endsWith('.svg');
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: isSvg
          ? SvgPicture.network(
              imageUrl,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => _buildLoadingPlaceholder(),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => _buildLoadingPlaceholder(),
              errorWidget: (context, url, error) => _buildErrorPlaceholder(),
            ),
    )
        .animate(target: isActive ? 1 : 0)
        .fadeIn(
          duration: 600.ms,
          curve: Curves.easeOut,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// Builds a loading placeholder for images.
  /// Builds a loading placeholder for images.
  Widget _buildLoadingPlaceholder() {
    return Center(
      child: Image.asset(
        AppAssets.msmeLogo,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Builds an error placeholder for failed image loads.
  Widget _buildErrorPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Image unavailable',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  /// Builds the title text.
  Widget _buildTitle() {
    return Text(
      model.title,
      textAlign: TextAlign.center,
      style: AppTextStyles.headlineLarge,
    );
  }

  /// Builds the subtitle text.
  Widget _buildSubtitle() {
    return Text(
      model.subtitle,
      textAlign: TextAlign.center,
      style: AppTextStyles.onboardingSubtitle,
    );
  }

  /// Builds the features grid for the features overview page.
  Widget _buildFeaturesGrid() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: model.features!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final feature = model.features![index];
        return _FeatureItem(
          icon: feature.icon,
          title: feature.title,
          description: feature.description,
          delay: Duration(milliseconds: 450 + (index * 100)),
          isActive: isActive,
        );
      },
    );
  }
}

/// A single feature item widget.
class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    required this.isActive,
  });

  final IconData icon;
  final String title;
  final String description;
  final Duration delay;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.backgroundSubtle,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.textLight,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .fadeIn(
          duration: 400.ms,
          delay: delay,
          curve: Curves.easeOut,
        )
        .slideX(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
          delay: delay,
          curve: Curves.easeOutCubic,
        );
  }
}
