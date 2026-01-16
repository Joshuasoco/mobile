/// MSME Pathways - Onboarding Page Widget
/// 
/// A page with financial-themed decorations and a smooth bottom fade effect.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/onboarding_model.dart';

/// Onboarding page with financial decorations and image fade effect.
/// 
/// Features:
/// - Image with bottom gradient fade (no hard cuts)
/// - Financial-themed floating icons
/// - Title positioned below image
/// - Smooth animations
class FullscreenOnboardingPage extends StatelessWidget {
  /// Creates an onboarding page.
  const FullscreenOnboardingPage({
    super.key,
    required this.model,
    required this.isActive,
  });

  /// The onboarding page data
  final OnboardingModel model;

  /// Whether this page is currently active (visible)
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.height < 700;
    
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: isSmallScreen ? 16 : 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer for top
              const Spacer(flex: 1),
              
              // Image area with fade and decorations
              Expanded(
                flex: 6,
                child: _buildImageWithFade(context),
              ),
              
              SizedBox(height: isSmallScreen ? 20 : 32),
              
              // Title below image
              _buildTitle(),
              
              // Spacer for bottom (space for dots and button)
              SizedBox(height: isSmallScreen ? 120 : 160),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the image with a gradient fade at the bottom and decorations.
  Widget _buildImageWithFade(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Main Image with Gradient Mask (Fades bottom to transparent)
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black, Colors.transparent],
              stops: [0.0, 0.7, 1.0], // Fade out the bottom 30%
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            model.imagePath,
            fit: BoxFit.contain,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[100],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              );
            },
          ),
        )
            .animate(target: isActive ? 1 : 0)
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            ),
        
        // Floating financial icon - top left (wallet)
        Positioned(
          top: 20,
          left: 10,
          child: _buildFloatingIcon(
            Icons.account_balance_wallet_rounded,
            const Color(0xFFFFC107), // Golden yellow
            delay: 400.ms,
          ),
        ),
        
        // Floating financial icon - middle right (growth)
        Positioned(
          top: 100,
          right: 0,
          child: _buildFloatingIcon(
            Icons.trending_up_rounded,
            const Color(0xFF4CAF50), // Success green
            delay: 600.ms,
          ),
        ),
        
        // Floating financial icon - bottom left (books/education)
        Positioned(
          bottom: 40,
          left: 0,
          child: _buildFloatingIcon(
            Icons.menu_book_rounded,
            const Color(0xFF9C27B0), // Purple for education
            delay: 800.ms,
          ),
        ),
      ],
    );
  }

  /// Builds a floating decorative icon with shadow/glow.
  Widget _buildFloatingIcon(IconData icon, Color color, {required Duration delay}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .fadeIn(duration: 400.ms, delay: delay, curve: Curves.easeOut)
        .moveY(
          begin: 10,
          end: 0,
          duration: 1500.ms,
          curve: Curves.easeInOut,
        )
        // Add a gentle floating animation
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -6,
          duration: 2000.ms,
          curve: Curves.easeInOut,
          delay: delay + 400.ms, 
        );
  }

  /// Builds the title text with animation.
  Widget _buildTitle() {
    return Text(
      model.title,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF212121),
        height: 1.3,
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .fadeIn(
          duration: 500.ms,
          delay: 300.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 500.ms,
          delay: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
