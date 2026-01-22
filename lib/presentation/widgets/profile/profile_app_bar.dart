/// MSME Pathways - Profile App Bar Widget
///
/// Simple, clean sliver app bar for the profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary colors.
const Color _kPrimaryColor = Color(0xFF00897B);
const Color _kPrimaryDark = Color(0xFF00695C);

/// Simple profile sliver app bar with clean design.
class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    super.key,
    this.onSettingsTap,
  });

  /// Callback when settings button is tapped.
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: _kPrimaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_kPrimaryColor, _kPrimaryDark],
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onSettingsTap,
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
