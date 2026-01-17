/// Active Loan Card Widget
///
/// Displays active loan details in a rounded white card with soft shadow.
/// Includes status badge, loan type, amount, interest rate, and repayment status.
library;

import 'package:flutter/material.dart';

/// Card displaying active loan details with status badge.
///
/// Features:
/// - Rounded white card with subtle shadow (iOS-style)
/// - Status badge ("In Progress") on the right
/// - Two-column layout for loan details
/// - Clean typography and spacing
class ActiveLoanCard extends StatelessWidget {
  /// The type of loan (e.g., "Business Capital").
  final String loanType;

  /// The loan amount in formatted currency.
  final String amount;

  /// The annual interest rate.
  final String interestRate;

  /// The repayment progress description.
  final String repaymentStatus;

  /// The status badge text.
  final String status;

  /// Creates an active loan card widget.
  const ActiveLoanCard({
    required this.loanType,
    required this.amount,
    required this.interestRate,
    required this.repaymentStatus,
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Loan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        fontSize: 16,
                      ),
                ),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFBEF264),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Loan details grid - two columns
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        context,
                        label: 'Loan Type',
                        value: loanType,
                      ),
                      const SizedBox(height: 20),
                      _buildDetailItem(
                        context,
                        label: 'Interest Rate',
                        value: interestRate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Right column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        context,
                        label: 'Amount',
                        value: amount,
                        isHighlight: true,
                      ),
                      const SizedBox(height: 20),
                      _buildDetailItem(
                        context,
                        label: 'Repayment Status',
                        value: repaymentStatus,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a detail item with label and value.
  Widget _buildDetailItem(
    BuildContext context, {
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9CA3AF),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 18 : 15,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: isHighlight ? const Color(0xFF22C55E) : const Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
