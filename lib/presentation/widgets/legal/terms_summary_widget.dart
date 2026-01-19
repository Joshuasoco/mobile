// MSME Pathways - Terms Summary Widget
// 
// An inline widget that provides a plain-language summary of terms and privacy policy.
// Features an expandable "Ano 'to?" section for better user understanding.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Interactive terms summary widget for inline use in forms.
class TermsSummaryWidget extends StatefulWidget {
  /// Creates a terms summary widget.
  const TermsSummaryWidget({
    super.key,
    this.onViewFullTerms,
    this.onViewFullPrivacy,
  });

  /// Callback when full Terms of Service is clicked.
  final VoidCallback? onViewFullTerms;
  
  /// Callback when full Privacy Policy is clicked.
  final VoidCallback? onViewFullPrivacy;

  @override
  State<TermsSummaryWidget> createState() => _TermsSummaryWidgetState();
}

class _TermsSummaryWidgetState extends State<TermsSummaryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "What's this?" Toggle
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
                  size: 20,
                  color: const Color(0xFF1565C0),
                ),
                const SizedBox(width: 4),
                Text(
                  "Ano 'to? (What's this?)",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable Content
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildSummaryCard(),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          sizeCurve: Curves.easeOutCubic,
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint(
            icon: Icons.shield_outlined,
            title: 'Ligtas ang data mo',
            subtitle: 'We keep your data safe and encrypted.',
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(
            icon: Icons.lock_outline,
            title: 'Walang sharean',
            subtitle: 'We never share info without your permission.',
          ),
          const SizedBox(height: 12),
          _buildBulletPoint(
            icon: Icons.delete_outline,
            title: 'Delete anytime',
            subtitle: 'You can request to delete your data whenever you want.',
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          
          // Links to full documents
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkButton('📄 Full Terms', widget.onViewFullTerms),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              _buildLinkButton('📄 Full Privacy', widget.onViewFullPrivacy),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0, duration: 300.ms),
    );
  }

  Widget _buildBulletPoint({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF1565C0)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton(String label, VoidCallback? onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF64748B),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}
