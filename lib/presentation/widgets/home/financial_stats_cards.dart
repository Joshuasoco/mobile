/// MSME Pathways - Financial Stats Cards Widget
///
/// Row of financial overview stat cards for the home dashboard.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Financial overview cards row.
///
/// Displays loan eligibility and courses completed stats.
class FinancialStatsCards extends StatelessWidget {
  const FinancialStatsCards({
    super.key,
    required this.maxLoanEligibleFormatted,
    required this.completedCourses,
    this.onLoanTap,
    this.onCoursesTap,
  });

  /// Formatted maximum loan eligible amount.
  final String maxLoanEligibleFormatted;

  /// Number of completed courses.
  final int completedCourses;

  /// Optional callback when loan card is tapped.
  final VoidCallback? onLoanTap;

  /// Optional callback when courses card is tapped.
  final VoidCallback? onCoursesTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF4CAF50),
            iconBgColor: const Color(0xFFE8F5E9),
            title: 'Loan Ready',
            value: maxLoanEligibleFormatted,
            subtitle: 'Max eligible',
            onTap: onLoanTap,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            icon: Icons.school_rounded,
            iconColor: const Color(0xFF2196F3),
            iconBgColor: const Color(0xFFE3F2FD),
            title: 'Courses',
            value: '$completedCourses',
            subtitle: 'Completed',
            onTap: onCoursesTap,
          ),
        ),
      ],
    );
  }
}

/// Individual stat card widget.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3748),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
