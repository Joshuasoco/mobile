import 'package:flutter/material.dart';

/// Smart Loan Support – Loan Details
/// Material 3, green theme, clean and responsive UI (UI-only).
class LoanScreen extends StatelessWidget {
  const LoanScreen({super.key});

  // Theme colors
  static const Color bg = Color(0xFFF9F9F9);
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color greenLight = Color(0xFFE8F5E9);
  static const Color textDark = Colors.black;
  static const Color textMuted = Colors.black54;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar / Header
              Padding(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Smart Loan Support',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: greenLight,
                          child: Icon(Icons.person, color: primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Joshua S. Co',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textDark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Microentrepreneur',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Active Loan Card
              Padding(
                padding: padding,
                child: _RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Active Loan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textDark,
                            ),
                          ),
                          const _StatusBadge(label: 'In Progress'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _LoanDetailRow(label: 'Loan Type', value: 'Business Capital'),
                      const _LoanDetailRow(label: 'Amount', value: '₱25,000'),
                      const _LoanDetailRow(label: 'Interest Rate', value: '8% per year'),
                      const _LoanDetailRow(label: 'Repayment Status', value: '4 of 12 months paid'),
                      const SizedBox(height: 16),

                      // Repayment Progress Section
                      const Text(
                        'Repayment progress',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.33, // 33%
                          minHeight: 10,
                          color: primaryGreen,
                          backgroundColor: greenLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.payments_outlined, size: 18, color: textMuted),
                          SizedBox(width: 6),
                          Text('₱8,333 Paid', style: TextStyle(color: textDark)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.calendar_month_outlined, size: 18, color: textMuted),
                          SizedBox(width: 6),
                          Text('Next payment due: Jan 1, 2026', style: TextStyle(color: textDark)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Repay Now',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: primaryGreen),
                            foregroundColor: primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'View Loan Details',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Eligibility Requirements Section
              Padding(
                padding: padding,
                child: _RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Eligibility Requirements',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      SizedBox(height: 10),
                      _CheckItem(icon: Icons.badge_outlined, label: 'Valid Government ID'),
                      SizedBox(height: 8),
                      _CheckItem(icon: Icons.sticky_note_2_outlined, label: 'Barangay Certificate'),
                      SizedBox(height: 8),
                      _CheckItem(icon: Icons.phone_iphone, label: 'Active Mobile Number'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Footer help text
              Padding(
                padding: padding,
                child: Row(
                  children: const [
                    Icon(Icons.help_outline, color: textMuted),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Need help? Learn more about loans',
                        style: TextStyle(color: textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Reusable widgets --------------------

/// Rounded card with soft shadow
class _RoundedCard extends StatelessWidget {
  final Widget child;
  const _RoundedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

/// Status badge (top-right)
class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: LoanScreen.greenLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LoanScreen.primaryGreen),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: LoanScreen.primaryGreen),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: LoanScreen.primaryGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// One line of loan detail with label and value
class _LoanDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _LoanDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: LoanScreen.textMuted),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: LoanScreen.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Eligibility item with icon and green check
class _CheckItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CheckItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: LoanScreen.greenLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: LoanScreen.primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: LoanScreen.textDark),
          ),
        ),
        const Icon(Icons.check_circle, color: LoanScreen.primaryGreen),
      ],
    );
  }
}

  