/// MSME Pathways - Profile Footer Widget
///
/// Footer with legal links and version info.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary color.
const Color _kPrimaryColor = Color(0xFF00897B);

/// Profile footer with links and version.
class ProfileFooter extends StatelessWidget {
  const ProfileFooter({
    super.key,
    this.version = '1.0.0',
    this.onPrivacyTap,
    this.onTermsTap,
    this.offsetY = -40,
  });

  /// App version string.
  final String version;

  /// Privacy policy tap callback.
  final VoidCallback? onPrivacyTap;

  /// Terms of service tap callback.
  final VoidCallback? onTermsTap;

  /// Vertical offset for floating effect.
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Column(
        children: [
          // Legal links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLink('Privacy Policy', onPrivacyTap),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              _buildLink('Terms of Service', onTermsTap),
            ],
          ),
          const SizedBox(height: 12),
          // Version
          Text(
            'MSME Pathways v$version',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          // Copyright
          Text(
            '© 2026 MSME Pathways. All rights reserved.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLink(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: _kPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
