/// MSME Pathways - Main Screen Shell
///
/// This screen acts as the application shell, containing the bottom navigation
/// bar and managing the effective content area. It persists navigation state
/// across tab switches.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../loan/loan_details_screen.dart';
import '../profile/profile_screen.dart';
import '../support/support_chat_screen.dart';

/// Main screen shell with persistent bottom navigation.
class MainScreen extends StatefulWidget {
  /// Creates the main screen.
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens to be displayed for each tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const LoanDetailsScreen(),
    const ProfileScreen(),
    const SupportChatScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
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
                _buildNavItem(Icons.home_rounded, 'Home', 0),
                _buildNavItem(Icons.account_balance_wallet_rounded, 'Loan', 1),
                _buildNavItem(Icons.person_outline_rounded, 'Profile', 2),
                _buildNavItem(Icons.chat_bubble_outline_rounded, 'Chat', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a single navigation item.
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : Colors.grey[500],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isActive ? AppColors.primary : Colors.grey[500],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
