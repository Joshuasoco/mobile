/// MSME Pathways - Bottom Navigation Bar Widget
///
/// Custom bottom navigation bar for the home screen tabs.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary green color for active state.
const Color _kActiveColor = Color(0xFF3DBA6F);

/// Bottom navigation bar for home screen.
///
/// Displays 4 tabs: Home, Loan, Chat, Profile
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback when a tab is selected.
  final void Function(int index) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: selectedIndex == 0,
                onTap: () => onTabSelected(0),
              ),
              _NavItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Loan',
                isActive: selectedIndex == 1,
                onTap: () => onTabSelected(1),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                isActive: selectedIndex == 2,
                onTap: () => onTabSelected(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isActive: selectedIndex == 3,
                onTap: () => onTabSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: _kActiveColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? _kActiveColor : Colors.grey[500],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isActive ? _kActiveColor : Colors.grey[500],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
