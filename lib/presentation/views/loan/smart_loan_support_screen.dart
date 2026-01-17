/// MSME Pathways - Smart Loan Support Screen
///
/// A modern mobile fintech app screen displaying active loan status,
/// repayment progress with animation, and eligibility requirements.
/// Features iOS-style design with clean cards, green accent color,
/// and smooth animations for financial indicators.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/loan/animated_progress_bar.dart';
import '../../widgets/loan/eligibility_checklist.dart';
import 'smart_loan_support_body.dart';

/// Smart Loan Support screen with active loan details and repayment tracking.
///
/// Features:
/// - Clean white background with soft shadows
/// - Circular user avatar with green outline
/// - Active loan card with status badge
/// - Animated payment progress bar (0-33% with ease-in-out)
/// - Eligibility requirements checklist
/// - Primary and secondary action buttons
/// - Bottom navigation bar
class SmartLoanSupportScreen extends StatefulWidget {
  /// Creates the Smart Loan Support screen.
  const SmartLoanSupportScreen({super.key});

  @override
  State<SmartLoanSupportScreen> createState() => _SmartLoanSupportScreenState();
}

class _SmartLoanSupportScreenState extends State<SmartLoanSupportScreen>
    with WidgetsBindingObserver {
  int _selectedNavIndex = 1; // Loan tab is selected by default
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setLightSystemUI();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setLightSystemUI();
    }
  }

  /// Sets light system UI overlay style for this screen.
  void _setLightSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Handle bottom navigation tap.
  void _onNavBarTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      case 0:
        // Navigate to Home
        context.go('/home');
      case 1:
        // Already on Loan screen
        break;
      case 2:
        // Navigate to Profile
        context.go('/profile');
      case 3:
        // Navigate to Chat
        context.go('/chat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        automaticallyImplyLeading: false,
        title: const Text(
          'Smart Loan Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          // Notification button
          GestureDetector(
            onTap: () {
              // Navigate to notification screen
              context.push('/notifications');
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF22C55E),
                    size: 24,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SmartLoanSupportBody(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Builds the bottom navigation bar with four tabs.
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(
                index: 0,
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              _buildNavBarItem(
                index: 1,
                icon: Icons.wallet_outlined,
                label: 'Loan',
                isSelected: true,
              ),
              _buildNavBarItem(
                index: 2,
                icon: Icons.person_outline,
                label: 'Profile',
              ),
              _buildNavBarItem(
                index: 3,
                icon: Icons.chat_outlined,
                label: 'Chat',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single navigation bar item.
  Widget _buildNavBarItem({
    required int index,
    required IconData icon,
    required String label,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => _onNavBarTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected
                ? const Color(0xFF22C55E)
                : const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
