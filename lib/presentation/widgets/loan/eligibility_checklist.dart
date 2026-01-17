/// Eligibility Checklist Widget
///
/// Displays a checklist of eligibility requirements with green check icons.
library;

import 'package:flutter/material.dart';

/// Checklist widget showing eligibility requirements with green checks.
///
/// Features:
/// - List of eligibility items
/// - Green checkmark icons for each item
/// - Clean typography and spacing
class EligibilityChecklist extends StatelessWidget {
  /// List of eligibility requirement strings.
  final List<String> items;

  /// Creates an eligibility checklist widget.
  const EligibilityChecklist({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          items.length,
          (index) {
            final isLast = index == items.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Green checkmark icon
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF0FDF4),
                          border: Border.all(
                            color: const Color(0xFF22C55E),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: Color(0xFF22C55E),
                            weight: 700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Item text
                      Expanded(
                        child: Text(
                          items[index],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider between items (except for the last one)
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 1,
                      color: const Color(0xFFF3F4F6),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
