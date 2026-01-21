/// MSME Pathways - Feature Card Widget
///
/// Reusable card component for feature navigation.
/// Used in the feature navigation grid on the home screen.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/home_dashboard_model.dart';

/// A clickable feature navigation card.
///
/// Displays:
/// - Feature icon
/// - Title and subtitle
/// - Optional badge count
/// - Tap animation
class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isFullWidth = false,
  });

  /// Feature card data.
  final FeatureCardItem item;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  /// Whether the card should take full width.
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: item.color.withValues(alpha: 0.15), width: 1),
            boxShadow: [
              BoxShadow(
                color: item.color.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isFullWidth ? _buildFullWidthContent() : _buildCompactContent(),
        ),
      ),
    );
  }

  Widget _buildCompactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            if (item.isNew)
              _buildNewTag()
            else if (item.badge != null) 
              _buildBadge(),
          ],
        ),
        const Spacer(),
        Text(
          item.title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A202C),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          item.subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.grey[500],
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFullWidthContent() {
    return Row(
      children: [
        _buildIcon(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (item.badge != null) ...[
          const SizedBox(width: 12),
          _buildBadge(),
        ],
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            item.color.withValues(alpha: 0.15),
            item.color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: item.color.withValues(alpha: 0.2), width: 1),
      ),
      child: Icon(
        item.icon,
        color: item.color,
        size: 24,
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${item.badge}',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: item.color,
        ),
      ),
    );
  }

  Widget _buildNewTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'NEW',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
