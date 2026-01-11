/// MSME Pathways - Support Assistant Screen
///
/// Features AI-powered chat support, quick help topics, and contact options.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Support chat and help center screen.
class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Assistant'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundSubtle,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Online 24/7',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // AI Assistant Card
                  _buildAICard(),
                  const SizedBox(height: 24),

                  // Quick Help Topics
                  Text(
                    'Quick Help Topics',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTopicItem(Icons.how_to_reg_outlined, 'How to apply for a loan?'),
                  _buildTopicItem(Icons.assignment_outlined, 'What are the requirements?'),
                  _buildTopicItem(Icons.percent_rounded, 'How is interest calculated?'),
                  _buildTopicItem(Icons.security_rounded, 'Is my data safe?'),
                  
                  const SizedBox(height: 24),

                  // Contact Support Card
                  _buildContactSupportCard(),
                ],
              ),
            ),
          ),
          
          // Chat Input Area
          _buildChatInputArea(),
        ],
      ),
    );
  }

  Widget _buildAICard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, Color(0xFF64B5F6)], // Blue gradient matching accent
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
             color: AppColors.accent.withValues(alpha: 0.3),
             blurRadius: 12,
             offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
           Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: Colors.white.withValues(alpha: 0.2),
               shape: BoxShape.circle,
             ),
             child: const Icon(
               Icons.auto_awesome_rounded,
               color: Colors.white,
               size: 32,
             ),
           ),
           const SizedBox(height: 16),
           Text(
             'AI-powered support available instantly. Ask anything!',
             textAlign: TextAlign.center,
             style: GoogleFonts.poppins(
               fontSize: 16,
               fontWeight: FontWeight.w600,
               color: Colors.white,
               height: 1.4,
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                 Icon(icon, color: AppColors.primary, size: 24),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Text(
                     title,
                     style: GoogleFonts.inter(
                       fontSize: 14,
                       fontWeight: FontWeight.w500,
                       color: AppColors.textPrimary,
                     ),
                   ),
                 ),
                 Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupportCard() {
    return Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(20),
         border: Border.all(color: Colors.grey[200]!),
       ),
       child: Column(
         children: [
           Text(
             'Need to speak with someone?',
             style: GoogleFonts.inter(
               fontSize: 14,
               color: AppColors.textSecondary,
             ),
           ),
           const SizedBox(height: 12),
           OutlinedButton.icon(
             onPressed: () {},
             icon: const Icon(Icons.headset_mic_rounded, size: 18),
             label: const Text('Contact Support'),
             style: OutlinedButton.styleFrom(
               foregroundColor: AppColors.textPrimary,
               side: BorderSide(color: Colors.grey[300]!),
               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(30),
               ),
             ),
           ),
         ],
       ),
    );
  }

  Widget _buildChatInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), // Extra bottom padding for safe area
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
      child: Row(
        children: [
           Expanded(
             child: TextField(
               decoration: InputDecoration(
                 hintText: 'Type your question...',
                 hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                 filled: true,
                 fillColor: AppColors.backgroundSubtle,
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(24),
                   borderSide: BorderSide.none,
                 ),
                 contentPadding: const EdgeInsets.symmetric(
                   horizontal: 20,
                   vertical: 12,
                 ),
               ),
             ),
           ),
           const SizedBox(width: 12),
           Container(
             decoration: const BoxDecoration(
               color: AppColors.primary,
               shape: BoxShape.circle,
             ),
             child: IconButton(
               icon: const Icon(Icons.send_rounded, color: Colors.white),
               onPressed: () {},
             ),
           ),
        ],
      ),
    );
  }
}
