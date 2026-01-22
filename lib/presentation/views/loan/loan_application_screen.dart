/// MSME Pathways - Loan Application Screen
///
/// Multi-step loan application form with progress tracking and draft saving.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/form_draft_service.dart';
import '../../../data/models/loan_application_model.dart';
import '../../viewmodels/loan_application_viewmodel.dart';
import '../../widgets/loan/loan_application_widgets.dart';

/// Loan application screen with multi-step wizard.
class LoanApplicationScreen extends StatelessWidget {
  const LoanApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoanApplicationViewModel(
        formDraftService: context.read<FormDraftService>(),
      ),
      child: const _LoanApplicationContent(),
    );
  }
}

class _LoanApplicationContent extends StatefulWidget {
  const _LoanApplicationContent();

  @override
  State<_LoanApplicationContent> createState() => _LoanApplicationContentState();
}

class _LoanApplicationContentState extends State<_LoanApplicationContent> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanApplicationViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Header with progress
              _buildHeader(context, viewModel),

              // Step content
              Expanded(
                child: IndexedStack(
                  index: viewModel.currentStepIndex,
                  children: [
                    PersonalInfoStep(viewModel: viewModel),
                    LoanDetailsStep(viewModel: viewModel),
                    BusinessInfoStep(viewModel: viewModel),
                    DocumentsStep(viewModel: viewModel),
                  ],
                ),
              ),

              // Bottom navigation
              _buildBottomNav(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, LoanApplicationViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00897B),
            Color(0xFF00695C),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00897B).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => _handleBack(context, viewModel),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Apply for Loan',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '₱50,000 Loan Application',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => viewModel.saveDraft(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.save, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Save',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress indicator
            StepProgressBar(
              currentStep: viewModel.currentStepIndex,
              totalSteps: viewModel.totalSteps,
              steps: LoanApplicationStep.values,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, LoanApplicationViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          if (!viewModel.isFirstStep)
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF00897B)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00897B),
                  ),
                ),
              ),
            ),
          
          if (!viewModel.isFirstStep) const SizedBox(width: 12),
          
          // Next/Submit button
          Expanded(
            flex: viewModel.isFirstStep ? 1 : 2,
            child: ElevatedButton(
              onPressed: viewModel.canProceed
                  ? () => _handleNext(context, viewModel)
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF00897B),
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: viewModel.canProceed ? 2 : 0,
              ),
              child: viewModel.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      viewModel.isLastStep ? 'Submit Application' : 'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBack(BuildContext context, LoanApplicationViewModel viewModel) {
    if (viewModel.isFirstStep) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Exit Application?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Your progress will be saved as a draft.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viewModel.saveDraft();
                Navigator.pop(context);
                context.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      );
    } else {
      viewModel.previousStep();
    }
  }

  Future<void> _handleNext(BuildContext context, LoanApplicationViewModel viewModel) async {
    if (viewModel.isLastStep) {
      final success = await viewModel.submit();
      if (success && context.mounted) {
        _showSuccessDialog(context);
      }
    } else {
      viewModel.nextStep();
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF4CAF50),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Application Submitted!',
               style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll review your application and get back to you within 24-48 hours.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
