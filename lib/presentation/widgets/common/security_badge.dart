// MSME Pathways - Security Badge Widget
//
// A trust-building element displayed on forms and sensitive screens.
// Indicates that user data is encrypted and secure.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityBadge extends StatelessWidget {
  const SecurityBadge({super.key, this.isLight = false});

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final color = isLight ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF64748B);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.gpp_good_outlined,
          size: 16,
          color: isLight ? Colors.white : const Color(0xFF00897B),
        ),
        const SizedBox(width: 6),
        Text(
          'Bank-level Security & Encryption',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
