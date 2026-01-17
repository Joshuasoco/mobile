/// User Header Widget
///
/// Displays centered title, circular avatar with green outline,
/// user name, and subtitle for the Smart Loan Support screen.
library;

import 'package:flutter/material.dart';

/// User header section with avatar, name, and subtitle.
///
/// Features:
/// - Centered "Smart Loan Support" title
/// - Circular avatar with thin green outline
/// - User name below avatar
/// - Subtitle (e.g., "Microentrepreneur")
class UserHeader extends StatelessWidget {
  /// The user's name to display.
  final String name;

  /// Subtitle to display below name (e.g., occupation).
  final String subtitle;

  /// Creates a user header widget.
  const UserHeader({
    required this.name,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Title
        Text(
          'Smart Loan Support',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
                fontSize: 28,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Avatar with green outline
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF22C55E),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0FDF4),
            ),
            child: Center(
              child: Icon(
                Icons.account_circle,
                size: 56,
                color: const Color(0xFF22C55E),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // User name
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                fontSize: 18,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),

        // Subtitle
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
