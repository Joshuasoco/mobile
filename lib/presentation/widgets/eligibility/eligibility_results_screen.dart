// MSME Pathways - Eligibility Results Screen
// 
// Displays the eligibility check results with qualification status,
// max loan amount, and recommendations.


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/eligibility_model.dart';

/// Results screen showing eligibility status.
class EligibilityResultsScreen extends StatelessWidget {
  /// Creates the results screen.
  const EligibilityResultsScreen({
    super.key,
    required this.result,
    required this.onCreateAccount,
    required this.onTryAgain,
  });

  /// The calculated result.
  final EligibilityResult result;
  
  /// Callback to create account.
  final VoidCallback onCreateAccount;
  
  /// Callback to retry.
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Result icon
              _buildResultIcon()
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 24),
              
              // Qualification status
              Text(
                result.isQualified ? 'Congratulations!' : 'Almost There!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 12),
              
              // Tagalog message
              Text(
                result.messageTl,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.5,
                  color: const Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              
              const SizedBox(height: 32),
              
              // Score and max loan card
              _buildScoreCard()
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: 24),
              
              // Recommendations
              if (result.recommendations.isNotEmpty) ...[
                _buildRecommendations()
                    .animate()
                    .fadeIn(delay: 500.ms),
                const SizedBox(height: 32),
              ],
              
              // Trust badges
              _buildTrustBadges()
                  .animate()
                  .fadeIn(delay: 600.ms),
              
              const SizedBox(height: 32),
              
              // Action buttons
              _buildActionButtons(context)
                  .animate()
                  .fadeIn(delay: 700.ms),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    final isQualified = result.isQualified;
    final confidence = result.confidence;
    
    Color iconColor;
    IconData iconData;
    
    if (confidence == QualificationConfidence.high) {
      iconColor = const Color(0xFF4CAF50);
      iconData = Icons.check_circle;
    } else if (confidence == QualificationConfidence.medium) {
      iconColor = const Color(0xFF2196F3);
      iconData = Icons.thumb_up;
    } else if (isQualified) {
      iconColor = const Color(0xFFFFA726);
      iconData = Icons.star;
    } else {
      iconColor = const Color(0xFF78909C);
      iconData = Icons.hourglass_bottom;
    }
    
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 56,
        color: iconColor,
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: result.isQualified
              ? [const Color(0xFF1565C0), const Color(0xFF0D47A1)]
              : [const Color(0xFF546E7A), const Color(0xFF37474F)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (result.isQualified 
                ? const Color(0xFF1565C0) 
                : const Color(0xFF546E7A)).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Confidence badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${result.confidence.labelEn} Chance',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Max loan amount
          Text(
            'Max Loan Amount',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.maxLoanFormatted,
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Score bar
          Row(
            children: [
              Text(
                'Eligibility Score:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: result.score / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${result.score}/100',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFFF9A825),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Para mas tumaas ang chance mo:',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...result.recommendations.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Color(0xFF5D4037))),
                Expanded(
                  child: Text(
                    rec,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF5D4037),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge(Icons.lock_outline, 'Secure'),
        const SizedBox(width: 24),
        _buildBadge(Icons.verified_user_outlined, 'BSP Compliant'),
        const SizedBox(width: 24),
        _buildBadge(Icons.shield_outlined, 'Data Protected'),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF718096)),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary CTA
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: result.isQualified ? onCreateAccount : onTryAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF1565C0).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              result.isQualified ? 'Create Account' : 'Try Again',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Secondary action
        TextButton(
          onPressed: () {
            if (result.isQualified) {
              context.go('/home');
            } else {
              context.push('/learn-to-qualify', extra: {
                'score': result.score,
              });
            }
          },
          child: Text(
            result.isQualified ? 'Skip for now' : 'Learn how to qualify',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF1565C0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
