/// MSME Pathways - Calculator Widgets
///
/// Reusable UI components for the financial calculator.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/calculator_model.dart';
import '../../viewmodels/calculator_viewmodel.dart';

/// Input card for calculator parameters.
class CalculatorInputCard extends StatelessWidget {
  const CalculatorInputCard({
    super.key,
    required this.viewModel,
  });

  final CalculatorViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
                'Loan Details',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF00897B)),
                onPressed: viewModel.reset,
                tooltip: 'Reset',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Loan Amount
          _InputField(
            label: 'Loan Amount',
            value: viewModel.loanAmountFormatted,
            icon: Icons.attach_money,
            color: const Color(0xFF00897B),
          ),
          Slider(
            value: viewModel.loanAmount,
            min: 5000,
            max: 500000,
            divisions: 99,
            activeColor: const Color(0xFF00897B),
            label: viewModel.loanAmountFormatted,
            onChanged: viewModel.setLoanAmount,
          ),
          const SizedBox(height: 16),

          // Interest Rate
          _InputField(
            label: 'Annual Interest Rate',
            value: viewModel.interestRateFormatted,
            icon: Icons.percent,
            color: const Color(0xFFFF7043),
          ),
          Slider(
            value: viewModel.interestRate,
            min: 1.0,
            max: 36.0,
            divisions: 350,
            activeColor: const Color(0xFFFF7043),
            label: viewModel.interestRateFormatted,
            onChanged: viewModel.setInterestRate,
          ),
          const SizedBox(height: 16),

          // Term
          _InputField(
            label: 'Loan Term',
            value: viewModel.termFormatted,
            icon: Icons.calendar_today,
            color: const Color(0xFF7E57C2),
          ),
          Slider(
            value: viewModel.termMonths.toDouble(),
            min: 3,
            max: 60,
            divisions: 57,
            activeColor: const Color(0xFF7E57C2),
            label: viewModel.termFormatted,
            onChanged: (value) => viewModel.setTermMonths(value.toInt()),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF718096),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Summary card showing calculation results.
class CalculationSummaryCard extends StatelessWidget {
  const CalculationSummaryCard({
    super.key,
    required this.result,
  });

  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00897B),
            Color(0xFF00695C),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00897B).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Monthly Payment',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.monthlyPaymentFormatted,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Total Payment',
                  value: result.totalPaymentFormatted,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white24,
              ),
              Expanded(
                child: _SummaryItem(
                  label: 'Total Interest',
                  value: result.totalInterestFormatted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Amortization schedule table card.
class AmortizationTableCard extends StatelessWidget {
  const AmortizationTableCard({
    super.key,
    required this.result,
  });

  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Schedule',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                Text(
                  '${result.amortizationSchedule.length} payments',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xFFF7FAFC),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _HeaderCell('Month'),
                ),
                Expanded(
                  flex: 2,
                  child: _HeaderCell('Payment'),
                ),
                Expanded(
                  flex: 2,
                  child: _HeaderCell('Principal'),
                ),
                Expanded(
                  flex: 2,
                  child: _HeaderCell('Interest'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Table Rows (show first 12 months, then last month if longer)
          SizedBox(
            height: 300,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: result.amortizationSchedule.length > 12
                  ? 13 // First 12 + last
                  : result.amortizationSchedule.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final entry = index == 12 && result.amortizationSchedule.length > 12
                    ? result.amortizationSchedule.last
                    : result.amortizationSchedule[index];
                
                return _AmortizationRow(entry: entry);
              },
            ),
          ),
          
          if (result.amortizationSchedule.length > 13)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '+ ${result.amortizationSchedule.length - 13} more payments',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF4A5568),
      ),
    );
  }
}

class _AmortizationRow extends StatelessWidget {
  const _AmortizationRow({required this.entry});

  final AmortizationScheduleEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _CellText('${entry.month}'),
          ),
          Expanded(
            flex: 2,
            child: _CellText(entry.paymentFormatted, isHighlight: true),
          ),
          Expanded(
            flex: 2,
            child: _CellText(entry.principalPaymentFormatted),
          ),
          Expanded(
            flex: 2,
            child: _CellText(entry.interestPaymentFormatted),
          ),
        ],
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  const _CellText(this.text, {this.isHighlight = false});

  final String text;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
        color: isHighlight ? const Color(0xFF2D3748) : const Color(0xFF718096),
      ),
    );
  }
}
