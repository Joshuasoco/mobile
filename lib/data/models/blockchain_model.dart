/// MSME Pathways - Blockchain Models
/// 
/// Data models for blockchain-verified transaction history.
library;

/// Transaction status.
enum TransactionStatus {
  /// Pending confirmation
  pending('Pending', 'Naghihintay ng verification'),
  /// Confirmed on blockchain
  confirmed('Confirmed', 'Na-verify na sa blockchain'),
  /// Failed/rejected
  failed('Failed', 'Hindi na-verify');

  final String label;
  final String description;
  const TransactionStatus(this.label, this.description);
}

/// Type of transaction.
enum TransactionType {
  /// Loan disbursement
  disbursement('Disbursement', 'Loan release'),
  /// Repayment
  repayment('Repayment', 'Loan payment'),
  /// Record verification
  verification('Verification', 'Document verified');

  final String label;
  final String description;
  const TransactionType(this.label, this.description);
}

/// Represents a blockchain-verified transaction.
class BlockchainTransaction {
  /// Unique transaction ID.
  final String id;

  /// Blockchain hash.
  final String hash;

  /// Transaction type.
  final TransactionType type;

  /// Amount in PHP.
  final double amount;

  /// Transaction date.
  final DateTime date;

  /// Verification status.
  final TransactionStatus status;

  /// Block number on blockchain.
  final int? blockNumber;

  /// Number of confirmations.
  final int confirmations;

  /// Related loan ID.
  final String? loanId;

  /// Description/memo.
  final String? description;

  /// Creates a blockchain transaction.
  const BlockchainTransaction({
    required this.id,
    required this.hash,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    this.blockNumber,
    this.confirmations = 0,
    this.loanId,
    this.description,
  });

  /// Whether the transaction is verified.
  bool get isVerified => status == TransactionStatus.confirmed;

  /// Short hash for display.
  String get shortHash {
    if (hash.length <= 16) return hash;
    return '${hash.substring(0, 8)}...${hash.substring(hash.length - 6)}';
  }

  /// Format amount.
  String get amountFormatted {
    final prefix = type == TransactionType.repayment ? '-' : '+';
    return '$prefix₱${amount.toStringAsFixed(2)}';
  }

  /// Format date.
  String get dateFormatted {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Verification details for a transaction.
class VerificationDetails {
  /// Block number.
  final int blockNumber;

  /// Block hash.
  final String blockHash;

  /// Timestamp on chain.
  final DateTime timestamp;

  /// Network name.
  final String network;

  /// Number of confirmations.
  final int confirmations;

  /// Gas used (if applicable).
  final int? gasUsed;

  /// Creates verification details.
  const VerificationDetails({
    required this.blockNumber,
    required this.blockHash,
    required this.timestamp,
    required this.network,
    required this.confirmations,
    this.gasUsed,
  });
}

/// Mock transaction data for demo.
class MockTransactions {
  MockTransactions._();

  /// Get sample transactions.
  static List<BlockchainTransaction> getSample() => [
    BlockchainTransaction(
      id: 'txn-001',
      hash: '0x7a92f5c8d3e1b4a09876543210fedcba9876543210',
      type: TransactionType.disbursement,
      amount: 25000,
      date: DateTime.now().subtract(const Duration(days: 30)),
      status: TransactionStatus.confirmed,
      blockNumber: 18234567,
      confirmations: 12045,
      loanId: 'LOAN-2024-001',
      description: 'Working capital loan release',
    ),
    BlockchainTransaction(
      id: 'txn-002',
      hash: '0x3b84e7f9a2c6d1e5087654321cba9876fedcba98',
      type: TransactionType.repayment,
      amount: 2500,
      date: DateTime.now().subtract(const Duration(days: 23)),
      status: TransactionStatus.confirmed,
      blockNumber: 18289012,
      confirmations: 8923,
      loanId: 'LOAN-2024-001',
      description: 'Weekly payment - Week 1',
    ),
    BlockchainTransaction(
      id: 'txn-003',
      hash: '0x9c71d2e8f0a3b4c5d6e7f8901234567890abcdef',
      type: TransactionType.repayment,
      amount: 2500,
      date: DateTime.now().subtract(const Duration(days: 16)),
      status: TransactionStatus.confirmed,
      blockNumber: 18345678,
      confirmations: 5891,
      loanId: 'LOAN-2024-001',
      description: 'Weekly payment - Week 2',
    ),
    BlockchainTransaction(
      id: 'txn-004',
      hash: '0x5d82e3f4a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6',
      type: TransactionType.repayment,
      amount: 2500,
      date: DateTime.now().subtract(const Duration(days: 9)),
      status: TransactionStatus.confirmed,
      blockNumber: 18401234,
      confirmations: 2345,
      loanId: 'LOAN-2024-001',
      description: 'Weekly payment - Week 3',
    ),
    BlockchainTransaction(
      id: 'txn-005',
      hash: '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b',
      type: TransactionType.repayment,
      amount: 2500,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: TransactionStatus.pending,
      confirmations: 3,
      loanId: 'LOAN-2024-001',
      description: 'Weekly payment - Week 4',
    ),
    BlockchainTransaction(
      id: 'txn-006',
      hash: '0xf1e2d3c4b5a697887654321fedcba0987654321f',
      type: TransactionType.verification,
      amount: 0,
      date: DateTime.now().subtract(const Duration(days: 35)),
      status: TransactionStatus.confirmed,
      blockNumber: 18189012,
      confirmations: 15234,
      description: 'DTI registration verified',
    ),
  ];
}
