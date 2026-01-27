/// MSME Pathways - Home App Bar Widget
///
/// Modern custom sliver app bar with:
/// - Curved bottom edge
/// - Decorative background patterns
/// - Glassmorphic action buttons
/// - Enhanced gradient with depth
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary accent color for the app bar.
const Color _kPrimaryColor = Color(0xFF00897B);

/// Modern sliver app bar for the home screen with curved edge and decorative elements.
///
/// Features:
/// - Curved bottom edge for contemporary look
/// - Subtle decorative financial patterns
/// - Glassmorphic notification and profile buttons
/// - Enhanced gradient with layered depth
/// - Improved spacing and hierarchy
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.greeting,
    required this.userName,
    required this.onNotificationsTap,
    required this.onProfileTap,
    this.hasUnreadNotifications = false,
  });

  /// Time-based greeting (e.g., "Good morning").
  final String greeting;

  /// User's display name.
  final String userName;

  /// Callback when notifications icon is tapped.
  final VoidCallback onNotificationsTap;

  /// Callback when profile avatar is tapped.
  final VoidCallback onProfileTap;

  /// Whether there are unread notifications.
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200, // Increased from 160 for better proportions
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: _kPrimaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipPath(
          clipper: _HeaderCurveClipper(),
          child: Stack(
            children: [
              // Base gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00897B),
                      Color(0xFF00695C),
                    ],
                  ),
                ),
              ),
              // Decorative pattern overlay
              _buildDecorativePattern(),
              // Content layer
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User greeting
                      Expanded(child: _buildGreetingSection()),
                      const SizedBox(width: 12),
                      // Profile avatar and notification
                      _buildActionsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName! 👋',
          style: GoogleFonts.poppins(
            fontSize: 26, // Increased from 24
            fontWeight: FontWeight.w700, // Bolder
            color: Colors.white,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6), // Increased spacing
        Text(
          'Welcome to MSME Pathways',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.85), // More visible
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        // Glassmorphic notification button
        _buildGlassmorphicButton(
          onTap: onNotificationsTap,
          child: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 22,
              ),
              if (hasUnreadNotifications)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5252),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Glassmorphic profile button
        _buildGlassmorphicButton(
          onTap: onProfileTap,
          isProfile: true,
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassmorphicButton({
    required VoidCallback onTap,
    required Widget child,
    bool isProfile = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativePattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _FinancialPatternPainter(),
      ),
    );
  }
}

/// Custom clipper for curved bottom edge
class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    
    // Create smooth curve at bottom
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height - 40,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Custom painter for subtle financial-themed decorative patterns
class _FinancialPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw subtle growth chart lines
    _drawGrowthLines(canvas, size, paint);
    
    // Draw geometric shapes
    _drawGeometricShapes(canvas, size, paint);
  }

  void _drawGrowthLines(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    
    // Bottom right area - subtle upward trend line
    final startX = size.width * 0.6;
    final startY = size.height * 0.7;
    
    path.moveTo(startX, startY);
    path.lineTo(startX + 60, startY - 30);
    path.lineTo(startX + 120, startY - 50);
    
    canvas.drawPath(path, paint);
    
    // Add small circles at data points
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(startX, startY), 3, circlePaint);
    canvas.drawCircle(Offset(startX + 60, startY - 30), 3, circlePaint);
    canvas.drawCircle(Offset(startX + 120, startY - 50), 3, circlePaint);
  }

  void _drawGeometricShapes(Canvas canvas, Size size, Paint paint) {
    // Top left corner - subtle circles
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25),
      15,
      paint..color = Colors.white.withValues(alpha: 0.06),
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.25),
      25,
      paint..color = Colors.white.withValues(alpha: 0.04),
    );
    
    // Bottom right - subtle bars representing growth
    final barPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    
    final barWidth = 8.0;
    final barGap = 12.0;
    final barStartX = size.width * 0.7;
    final barBaseY = size.height * 0.85;
    
    for (int i = 0; i < 3; i++) {
      final height = 20.0 + (i * 15.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            barStartX + (i * (barWidth + barGap)),
            barBaseY - height,
            barWidth,
            height,
          ),
          const Radius.circular(4),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
