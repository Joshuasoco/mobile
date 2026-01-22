/// MSME Pathways -Loan Application Widgets
///
/// Reusable UI components for loan application multi-step form.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/loan_application_model.dart';
import '../../viewmodels/loan_application_viewmodel.dart';

/// Progress bar showing steps.
class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.steps,
  });

  final int currentStep;
  final int totalSteps;
  final List<LoanApplicationStep> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < totalSteps - 1) const SizedBox(width: 4),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Step 1: Personal Information.
class PersonalInfoStep extends StatelessWidget {
  const PersonalInfoStep({super.key, required this.viewModel});

  final LoanApplicationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        
        FormTextField(
          label: 'Full Name',
          hint: 'Juan dela Cruz',
          icon: Icons.person,
          initialValue: viewModel.data.fullName,
          onChanged: viewModel.updateFullName,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        
        FormTextField(
          label: 'Email Address',
          hint: 'juan@example.com',
          icon: Icons.email,
          initialValue: viewModel.data.email,
          onChanged: viewModel.updateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        
        FormTextField(
          label: 'Phone Number',
          hint: '09XX XXX XXXX',
          icon: Icons.phone,
          initialValue: viewModel.data.phone,
          onChanged: viewModel.updatePhone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        
        FormTextField(
          label: 'Address',
          hint: 'Street, Barangay, City',
          icon: Icons.location_on,
          initialValue: viewModel.data.address,
          onChanged: viewModel.updateAddress,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tell us about yourself',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

/// Step 2: Loan Details.
class LoanDetailsStep extends StatelessWidget {
  const LoanDetailsStep({super.key, required this.viewModel});

  final LoanApplicationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        
        // Loan Amount
        Text(
          'Loan Amount',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF00897B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF00897B)),
          ),
          child: Column(
            children: [
              Text(
                '₱${viewModel.data.loanAmount.toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (m) => '${m[1]},',
                )}',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00897B),
                ),
              ),
              Slider(
                value: viewModel.data.loanAmount,
                min: 5000,
                max: 100000,
                divisions: 19,
                activeColor: const Color(0xFF00897B),
                onChanged: viewModel.updateLoanAmount,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Loan Purpose
        Text(
          'Loan Purpose',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        
        ...LoanPurpose.values.map((purpose) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PurposeOption(
              purpose: purpose,
              isSelected: viewModel.data.loanPurpose == purpose,
              onTap: () => viewModel.updateLoanPurpose(purpose),
            ),
          );
        }),
        
        if (viewModel.data.loanPurpose == LoanPurpose.other) ...[
          const SizedBox(height: 8),
          FormTextField(
            label: 'Specify Purpose',
            hint: 'Please describe...',
            icon: Icons.edit,
            initialValue: viewModel.data.loanPurposeOther,
            onChanged: viewModel.updateLoanPurposeOther,
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Details',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How much do you need?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

class _PurposeOption extends StatelessWidget {
  const _PurposeOption({
    required this.purpose,
    required this.isSelected,
    required this.onTap,
  });

  final LoanPurpose purpose;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00897B).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00897B) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF00897B) : Colors.grey[400],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purpose.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    purpose.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 3: Business Information.
class BusinessInfoStep extends StatelessWidget {
  const BusinessInfoStep({super.key, required this.viewModel});

  final LoanApplicationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        
        FormTextField(
          label: 'Business Name',
          hint: 'Sari-sari Store ni Juan',
          icon: Icons.store,
          initialValue: viewModel.data.businessName,
          onChanged: viewModel.updateBusinessName,
        ),
        const SizedBox(height: 16),
        
        FormTextField(
          label: 'Business Type',
          hint: 'e.g., Sari-sari Store, Online Seller',
          icon: Icons.business,
          initialValue: viewModel.data.businessType,
          onChanged: viewModel.updateBusinessType,
        ),
        const SizedBox(height: 16),
        
        FormTextField(
          label: 'Years in Business',
          hint: 'e.g., 2 years, 6 months',
          icon: Icons.calendar_today,
          initialValue: viewModel.data.businessAge,
          onChanged: viewModel.updateBusinessAge,
        ),
        const SizedBox(height: 16),
        
        Text(
          'Average Monthly Income',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Text(
                '₱${viewModel.data.monthlyIncome.toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (m) => '${m[1]},',
                )}',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3748),
                ),
              ),
              Slider(
                value: viewModel.data.monthlyIncome.clamp(1000, 200000),
                min: 1000,
                max: 200000,
                divisions: 199,
                activeColor: const Color(0xFF00897B),
                onChanged: viewModel.updateMonthlyIncome,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Information',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tell us about your business',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

/// Step 4: Documents.
class DocumentsStep extends StatelessWidget {
  const DocumentsStep({super.key, required this.viewModel});

  final LoanApplicationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        
        _DocumentCheckbox(
          label: 'Valid Government ID',
          description: 'Required: National ID, Driver\'s License, Passport, etc.',
          isChecked: viewModel.data.hasValidId,
          isRequired: true,
          onChanged: viewModel.updateHasValidId,
        ),
        const SizedBox(height: 12),
        
        _DocumentCheckbox(
          label: 'Sales Records',
          description: 'Optional: Receipts, notebook records, digital records',
          isChecked: viewModel.data.hasSalesRecords,
          isRequired: false,
          onChanged: viewModel.updateHasSalesRecords,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Documents',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Confirm document availability',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Color(0xFF1565C0), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You\'ll upload these documents after approval',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF1565C0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentCheckbox extends StatelessWidget {
  const _DocumentCheckbox({
    required this.label,
    required this.description,
    required this.isChecked,
    required this.isRequired,
    required this.onChanged,
  });

  final String label;
  final String description;
  final bool isChecked;
  final bool isRequired;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChecked ? const Color(0xFF00897B) : Colors.grey[300]!,
            width: isChecked ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: isChecked ? const Color(0xFF00897B) : Colors.grey[400],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'REQUIRED',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable form text field.
class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.initialValue = '',
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF00897B)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }
}
