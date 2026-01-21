/// MSME Pathways - Dashboard Stats Card Widget
///
/// Displays business readiness overview with progress bar
/// and monthly improvement indicator.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary accent color.
const Color _kPrimaryColor = Color(0xFF00897B);

/// Dashboard welcome/stats card with business readiness.
///
/// Displays:
/// - Business readiness percentage
/// - Progress bar
/// - Monthly improvement badge
/// - Call to action text
class DashboardStatsCard extends StatelessWidget {
  const DashboardStatsCard({
    super.key,
    required this.businessReadiness,
    required this.businessReadinessFormatted,
    required this.monthlyImprovementFormatted,
    this.onTap,
  });

  /// Business readiness as decimal (0.0 - 1.0).
  final double businessReadiness;

  /// Formatted readiness percentage (e.g., "68%").
  final String businessReadinessFormatted;

  /// Formatted monthly improvement (e.g., "+12%").
  final String monthlyImprovementFormatted;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00897B),
              Color(0xFF26A69A),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _kPrimaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildProgressBar(),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Readiness',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              businessReadinessFormatted,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        _buildImprovementBadge(),
      ],
    );
  }

  Widget _buildImprovementBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '$monthlyImprovementFormatted this month',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: businessReadiness,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        minHeight: 8,
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      'Complete your profile to improve loan eligibility',
      style: GoogleFonts.inter(
        fontSize: 13,
        color: Colors.white.withValues(alpha: 0.9),
      ),
    );
  }
}
