/// Smart Loan Support Screen - Body Widget
///
/// Contains the main content: user header, active loan card,
/// payment progress section, action buttons, and eligibility checklist.
library;

import 'package:flutter/material.dart';

import '../../widgets/loan/active_loan_card.dart';
import '../../widgets/loan/animated_progress_bar.dart';
import '../../widgets/loan/eligibility_checklist.dart';
import '../../widgets/loan/user_header.dart';

/// Body content for the Smart Loan Support screen.
///
/// Manages the layout of all major sections with proper spacing
/// and scrolling behavior.
class SmartLoanSupportBody extends StatelessWidget {
  /// Creates the Smart Loan Support body.
  const SmartLoanSupportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // User header with avatar and name
          const UserHeader(
            name: 'Joshua S. Co',
            subtitle: 'Microentrepreneur',
          ),
          const SizedBox(height: 32),

          // Active Loan Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const ActiveLoanCard(
              loanType: 'Business Capital',
              amount: '₱25,000',
              interestRate: '8% per year',
              repaymentStatus: '4 of 12 months paid',
              status: 'In Progress',
            ),
          ),
          const SizedBox(height: 32),

          // Payment Progress Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Progress',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                ),
                const SizedBox(height: 16),
                AnimatedProgressBar(
                  progress: 0.33,
                  label: '₱8,333 Paid',
                  nextPaymentDue: 'Jan 1, 2026',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Repay Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle repay now action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Repay Now clicked')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Repay Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // View Loan Details Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle view loan details action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('View Loan Details clicked')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF22C55E),
                      side: const BorderSide(
                        color: Color(0xFF22C55E),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Loan Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Eligibility Requirements Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eligibility Requirements',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                ),
                const SizedBox(height: 16),
                const EligibilityChecklist(
                  items: [
                    'Valid Government ID',
                    'Barangay Certificate',
                    'Active Mobile Number',
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Help Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDCFCE7),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: const Color(0xFF16A34A),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Need help? Learn more about loans',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
