/// MSME Pathways - Smart Loan Support Screen
///
/// Displays current loan details, repayment progress, and eligibility checklist.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Loan details and support screen.
class LoanDetailsScreen extends StatelessWidget {
  const LoanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Loan Support'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundSubtle,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Summary Card
              _buildUserSummaryCard(),
              const SizedBox(height: 20),

              // Loan Details Card
              _buildLoanDetailsCard(),
              const SizedBox(height: 24),

              // Action Buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Repay Now',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Loan Details',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Eligibility Checklist
              Text(
                'Eligibility Checklist',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildEligibilityItem('Valid Government ID', true),
              _buildEligibilityItem('Barangay Certificate', true),
              _buildEligibilityItem('Active Mobile Number', true),
              _buildEligibilityItem('Business Permit', false),

               const SizedBox(height: 24),
               
               Center(
                 child: TextButton(
                   onPressed: () {},
                   child: Text(
                     'Need help? Learn more about loans',
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                   ),
                 ),
               ),
               const SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
             padding: const EdgeInsets.all(2),
             decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
             ),
             child: const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.backgroundSubtle,
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Juan Dela Cruz',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Microentrepreneur',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Business Expansion Loan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                 padding: const EdgeInsets.all(6),
                 decoration: BoxDecoration(
                   color: AppColors.primary.withValues(alpha: 0.1),
                   shape: BoxShape.circle,
                 ),
                 child: Icon(
                   Icons.trending_up,
                   size: 20,
                   color: AppColors.primary,
                 ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₱25,000.00',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
           Text(
            '8% Interest per year',
             style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          
          // Repayment Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repayment Status',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '4 of 12 months',
                 style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 4/12, // 33%
              minHeight: 10,
              backgroundColor: AppColors.backgroundSubtle,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 'Paid: ₱8,600',
                 style: GoogleFonts.inter(
                   fontSize: 12,
                   color: AppColors.textSecondary,
                 ),
               ),
                Text(
                 'Next: Oct 15',
                 style: GoogleFonts.inter(
                   fontSize: 12,
                   fontWeight: FontWeight.w600,
                   color: AppColors.textPrimary,
                 ),
               ),
             ],
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityItem(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
           Container(
             padding: const EdgeInsets.all(4),
             decoration: BoxDecoration(
               color: isCompleted ? AppColors.primary : Colors.grey[300],
               shape: BoxShape.circle,
             ),
             child: const Icon(
               Icons.check,
               size: 14,
               color: Colors.white,
             ),
           ),
           const SizedBox(width: 12),
           Text(
             title,
             style: GoogleFonts.inter(
               fontSize: 15,
               color: isCompleted ? AppColors.textPrimary : Colors.grey[500],
               fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w400,
             ),
           ),
        ],
      ),
    );
  }
}
