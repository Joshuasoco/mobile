/// MSME Pathways - Business Info Form Screen
/// 
/// Multi-step wizard for collecting business profile data.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/alternative_data_model.dart';
import '../../viewmodels/alternative_data_viewmodel.dart';
import '../../widgets/forms/form_widgets.dart';

/// Business info form screen with 4-step wizard.
class BusinessInfoFormScreen extends StatelessWidget {
  /// Creates the business info form screen.
  const BusinessInfoFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlternativeDataViewModel(),
      child: const _BusinessInfoContent(),
    );
  }
}

class _BusinessInfoContent extends StatefulWidget {
  const _BusinessInfoContent();

  @override
  State<_BusinessInfoContent> createState() => _BusinessInfoContentState();
}

class _BusinessInfoContentState extends State<_BusinessInfoContent> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlternativeDataViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              onPressed: () {
                if (viewModel.isFirstStep) {
                  Navigator.of(context).pop();
                } else {
                  viewModel.previousStep();
                }
              },
            ),
            title: Column(
              children: [
                Text(
                  'Business Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Step ${viewModel.currentStep + 1} of ${AlternativeDataViewModel.businessInfoTotalSteps}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Exit',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF718096),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: FormStepIndicator(
                  currentStep: viewModel.currentStep,
                  totalSteps: AlternativeDataViewModel.businessInfoTotalSteps,
                ),
              ),
              
              // Form content
              Expanded(
                child: PageView(
                  controller: viewModel.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _BasicInfoStep(viewModel: viewModel),
                    _RegistrationStep(viewModel: viewModel),
                    _LocationStep(viewModel: viewModel),
                    _OperationsStep(viewModel: viewModel),
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

  Widget _buildBottomNav(BuildContext context, AlternativeDataViewModel viewModel) {
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
          if (!viewModel.isFirstStep)
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            )
          else
            const Spacer(),
          
          const SizedBox(width: 12),
          
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: viewModel.isSubmitting
                  ? null
                  : () => _handleNext(context, viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
              ),
              child: viewModel.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      viewModel.isLastBusinessStep() ? 'Save Profile' : 'Continue',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext(BuildContext context, AlternativeDataViewModel viewModel) async {
    if (viewModel.isLastBusinessStep()) {
      final success = await viewModel.submitBusinessProfile();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Business profile saved! ✓',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      viewModel.nextStep(
        AlternativeDataViewModel.businessInfoTotalSteps,
        viewModel.businessFormKeys,
      );
    }
  }
}

/// Step 1: Basic business info.
class _BasicInfoStep extends StatelessWidget {
  const _BasicInfoStep({required this.viewModel});

  final AlternativeDataViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: viewModel.businessFormKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              'Basic Info',
              'Ilagay ang basic details ng iyong negosyo',
            ),
            const SizedBox(height: 24),
            
            // Business name
            FormTextField(
              controller: viewModel.businessNameController,
              label: 'Business Name',
              hint: 'e.g., Maria\'s Sari-Sari Store',
              prefixIcon: Icons.store_outlined,
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kailangan ng business name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            
            // Business type
            Text(
              'Uri ng Negosyo',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            _buildBusinessTypeOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessTypeOptions() {
    final types = [
      ('Sari-Sari Store', Icons.store_outlined),
      ('Food/Carenderia', Icons.restaurant_outlined),
      ('Market Vendor', Icons.shopping_bag_outlined),
      ('Online Seller', Icons.shopping_cart_outlined),
      ('Services', Icons.build_outlined),
      ('Other', Icons.more_horiz_outlined),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: types.map((type) {
        final isSelected = viewModel.businessProfile.businessType == type.$1;
        return GestureDetector(
          onTap: () => viewModel.setBusinessType(type.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.$2,
                  size: 18,
                  color: isSelected ? AppColors.primary : const Color(0xFF718096),
                ),
                const SizedBox(width: 8),
                Text(
                  type.$1,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primary : const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Step 2: Registration status.
class _RegistrationStep extends StatelessWidget {
  const _RegistrationStep({required this.viewModel});

  final AlternativeDataViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: viewModel.businessFormKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              'Registration Status',
              'Ano ang registration ng iyong negosyo?',
            ),
            const SizedBox(height: 24),
            
            // Registration options
            ...RegistrationType.values.map((type) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FormOptionCard<RegistrationType>(
                  value: type,
                  label: type.label,
                  description: type.description,
                  icon: _getRegistrationIcon(type),
                  isSelected: viewModel.businessProfile.registrationType == type,
                  onTap: () => viewModel.setRegistrationType(type),
                ),
              );
            }),
            
            const SizedBox(height: 20),
            
            // Info banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hindi pa registered? Okay lang! May alternative data scoring para sa\'yo.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF1565C0),
                        height: 1.4,
                      ),
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

  IconData _getRegistrationIcon(RegistrationType type) {
    switch (type) {
      case RegistrationType.dti:
        return Icons.verified_outlined;
      case RegistrationType.barangay:
        return Icons.home_work_outlined;
      case RegistrationType.unregistered:
        return Icons.pending_outlined;
    }
  }
}

/// Step 3: Location info.
class _LocationStep extends StatelessWidget {
  const _LocationStep({required this.viewModel});

  final AlternativeDataViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: viewModel.businessFormKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              'Business Location',
              'Saan ang lokasyon ng iyong negosyo?',
            ),
            const SizedBox(height: 24),
            
            // Location type
            Text(
              'Uri ng Location',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            
            ...LocationType.values.map((type) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FormOptionCard<LocationType>(
                  value: type,
                  label: type.label,
                  description: type.description,
                  icon: type.iconName,
                  isSelected: viewModel.businessProfile.locationType == type,
                  onTap: () => viewModel.setLocationType(type),
                ),
              );
            }),
            
            const SizedBox(height: 20),
            
            // Province
            FormTextField(
              controller: viewModel.provinceController,
              label: 'Province / City',
              hint: 'e.g., Quezon City',
              prefixIcon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 16),
            
            // Barangay
            FormTextField(
              controller: viewModel.barangayController,
              label: 'Barangay',
              hint: 'e.g., Brgy. San Antonio',
              prefixIcon: Icons.location_on_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 4: Operations info.
class _OperationsStep extends StatelessWidget {
  const _OperationsStep({required this.viewModel});

  final AlternativeDataViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: viewModel.businessFormKeys[3],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              'Business Operations',
              'Tell us more about your business',
            ),
            const SizedBox(height: 24),
            
            // Years in operation
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    controller: viewModel.yearsController,
                    label: 'Years in Business',
                    hint: '0',
                    suffixText: 'years',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormTextField(
                    controller: viewModel.monthsController,
                    label: 'Additional Months',
                    hint: '0',
                    suffixText: 'months',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Employees
            FormTextField(
              controller: viewModel.employeeController,
              label: 'Number of Employees (including you)',
              hint: '1',
              prefixIcon: Icons.people_outline,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            
            // Daily customers
            FormTextField(
              controller: viewModel.dailyCustomersController,
              label: 'Average Customers per Day',
              hint: 'e.g., 20',
              prefixIcon: Icons.groups_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            
            // Repeat customers
            Text(
              'Regular/Repeat Customers',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            _buildRepeatCustomerOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatCustomerOptions() {
    final options = [
      ('< 20%', 0.15),
      ('20-40%', 0.3),
      ('40-60%', 0.5),
      ('60-80%', 0.7),
      ('> 80%', 0.9),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = viewModel.businessProfile.repeatCustomerRate == opt.$2;
        return GestureDetector(
          onTap: () => viewModel.setRepeatCustomerRate(opt.$2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              opt.$1,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : const Color(0xFF2D3748),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

Widget _buildHeader(String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2D3748),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF718096),
        ),
      ),
    ],
  );
}
