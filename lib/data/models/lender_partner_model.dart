// MSME Pathways - Fictional Lender Partners
// 
// Fictional lender partner data for trust-building UI elements.
// These are placeholder partners for demonstration purposes.


import 'package:flutter/material.dart';

/// Fictional lender partner model.
class LenderPartner {
  /// Creates a lender partner.
  const LenderPartner({
    required this.id,
    required this.name,
    required this.logoIcon,
    required this.logoColor,
    required this.tagline,
    required this.minLoan,
    required this.maxLoan,
    required this.interestRate,
    required this.features,
  });

  /// Unique identifier.
  final String id;
  
  /// Partner name.
  final String name;
  
  /// Logo icon (using Material icons as placeholder).
  final IconData logoIcon;
  
  /// Brand color.
  final Color logoColor;
  
  /// Short tagline.
  final String tagline;
  
  /// Minimum loan amount.
  final int minLoan;
  
  /// Maximum loan amount.
  final int maxLoan;
  
  /// Interest rate display.
  final String interestRate;
  
  /// Key features.
  final List<String> features;

  /// Formats loan range for display.
  String get loanRangeFormatted {
    return '₱${_formatNumber(minLoan)} - ₱${_formatNumber(maxLoan)}';
  }

  static String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }
}

/// Fictional lending partners for the app.
abstract final class LenderPartners {
  /// BayaniLend - Community-focused microfinance.
  static const bayaniLend = LenderPartner(
    id: 'bayani_lend',
    name: 'BayaniLend',
    logoIcon: Icons.handshake,
    logoColor: Color(0xFF2E7D32),
    tagline: 'Para sa Bayani ng Komunidad',
    minLoan: 5000,
    maxLoan: 50000,
    interestRate: '2.5% monthly',
    features: [
      'No collateral needed',
      'Weekly payments allowed',
      'Fast 24-hour approval',
    ],
  );

  /// PinoyPera - Digital-first lending.
  static const pinoyPera = LenderPartner(
    id: 'pinoy_pera',
    name: 'PinoyPera',
    logoIcon: Icons.phone_android,
    logoColor: Color(0xFF1565C0),
    tagline: 'Digital na Pautang',
    minLoan: 3000,
    maxLoan: 30000,
    interestRate: '2.8% monthly',
    features: [
      '100% online application',
      'No paperwork required',
      'Instant disbursement',
    ],
  );

  /// Sari-Sari Grow - Specialized for sari-sari stores.
  static const sariSariGrow = LenderPartner(
    id: 'sari_sari_grow',
    name: 'Sari-Sari Grow',
    logoIcon: Icons.store,
    logoColor: Color(0xFFE65100),
    tagline: 'Partner ng Mga Tindahan',
    minLoan: 5000,
    maxLoan: 100000,
    interestRate: '2.2% monthly',
    features: [
      'Inventory financing',
      'Flexible payment terms',
      'Business mentoring included',
    ],
  );

  /// TindahanFirst - Market vendor focused.
  static const tindahanFirst = LenderPartner(
    id: 'tindahan_first',
    name: 'TindahanFirst',
    logoIcon: Icons.shopping_basket,
    logoColor: Color(0xFF7B1FA2),
    tagline: 'Suporta sa mga Magtitinda',
    minLoan: 10000,
    maxLoan: 75000,
    interestRate: '2.0% monthly',
    features: [
      'Daily payment option',
      'Rainy day grace period',
      'Business permit assistance',
    ],
  );

  /// KababayanCredit - Community trust-based.
  static const kababayanCredit = LenderPartner(
    id: 'kababayan_credit',
    name: 'KababayanCredit',
    logoIcon: Icons.people,
    logoColor: Color(0xFF00838F),
    tagline: 'Tiwala ng Komunidad',
    minLoan: 2000,
    maxLoan: 25000,
    interestRate: '3.0% monthly',
    features: [
      'Group lending available',
      'Financial literacy training',
      'Savings program included',
    ],
  );

  /// All available partners.
  static const List<LenderPartner> all = [
    bayaniLend,
    pinoyPera,
    sariSariGrow,
    tindahanFirst,
    kababayanCredit,
  ];

  /// Gets partners matching a max loan amount.
  static List<LenderPartner> getMatchingPartners(int maxLoanEligible) {
    return all.where((p) => p.minLoan <= maxLoanEligible).toList();
  }
}
