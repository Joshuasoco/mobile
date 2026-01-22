/// MSME Pathways - Calculator Screen
///
/// Financial calculator for loan payments, interest, and amortization schedules.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/calculator_viewmodel.dart';
import '../../widgets/calculator/calculator_widgets.dart';

/// Financial calculator screen.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorViewModel(),
      child: const _CalculatorContent(),
    );
  }
}

class _CalculatorContent extends StatefulWidget {
  const _CalculatorContent();

  @override
  State<_CalculatorContent> createState() => _CalculatorContentState();
}

class _CalculatorContentState extends State<_CalculatorContent> {
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
    return Consumer<CalculatorViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF00897B),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Loan Calculator',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF00897B),
                          const Color(0xFF00897B).withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Quick Presets
                    _buildPresetsSection(viewModel),
                    const SizedBox(height: 20),

                    // Input Card
                    CalculatorInputCard(viewModel: viewModel),
                    const SizedBox(height: 20),

                    // Results Summary
                    if (viewModel.result != null) ...[
                      CalculationSummaryCard(result: viewModel.result!),
                      const SizedBox(height: 20),

                      // Amortization Schedule
                      AmortizationTableCard(result: viewModel.result!),
                      const SizedBox(height: 20),
                    ],

                    // Error Message
                    if (viewModel.errorMessage != null)
                      _buildErrorCard(viewModel.errorMessage!),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPresetsSection(CalculatorViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Presets',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: CalculatorViewModel.presets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final preset = CalculatorViewModel.presets[index];
              return _PresetCard(
                preset: preset,
                onTap: () => viewModel.applyPreset(
                  loanAmount: preset.loanAmount,
                  interestRate: preset.interestRate,
                  termMonths: preset.termMonths,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF9800)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9800)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFE65100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.onTap,
  });

  final LoanPreset preset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF00897B).withValues(alpha: 0.1),
              const Color(0xFF00897B).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00897B).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              preset.name,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00897B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              preset.description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
