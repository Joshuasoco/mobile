/// MSME Pathways - Blockchain ViewModel
/// 
/// Business logic for blockchain transaction history.
library;

import 'package:flutter/material.dart';

import '../../data/models/blockchain_model.dart';

/// ViewModel for blockchain transaction history.
class BlockchainViewModel extends ChangeNotifier {
  /// All transactions.
  List<BlockchainTransaction> _transactions = [];

  /// Current filter type.
  TransactionType? _filterType;

  /// Search query.
  String _searchQuery = '';

  /// Whether loading.
  bool _isLoading = false;

  /// Gets all transactions.
  List<BlockchainTransaction> get transactions => _transactions;

  /// Gets filtered transactions.
  List<BlockchainTransaction> get filteredTransactions {
    var result = List<BlockchainTransaction>.from(_transactions);

    // Apply type filter
    if (_filterType != null) {
      result = result.where((t) => t.type == _filterType).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((t) {
        return t.hash.toLowerCase().contains(query) ||
            t.description?.toLowerCase().contains(query) == true ||
            t.loanId?.toLowerCase().contains(query) == true;
      }).toList();
    }

    return result;
  }

  /// Current filter type.
  TransactionType? get filterType => _filterType;

  /// Search query.
  String get searchQuery => _searchQuery;

  /// Whether loading.
  bool get isLoading => _isLoading;

  /// Total confirmed transactions.
  int get confirmedCount =>
      _transactions.where((t) => t.isVerified).length;

  /// Total pending transactions.
  int get pendingCount =>
      _transactions.where((t) => t.status == TransactionStatus.pending).length;

  /// Creates the viewmodel.
  BlockchainViewModel() {
    _loadTransactions();
  }

  /// Loads transactions.
  Future<void> _loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Backend - Fetch transactions from blockchain API
    // Example:
    // _transactions = await blockchainService.getTransactions(userId);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions = MockTransactions.getSample();

    // Sort by date (newest first)
    _transactions.sort((a, b) => b.date.compareTo(a.date));

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh transactions.
  Future<void> refresh() async {
    await _loadTransactions();
  }

  /// Set filter type.
  void setFilter(TransactionType? type) {
    _filterType = type;
    notifyListeners();
  }

  /// Set search query.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear filters.
  void clearFilters() {
    _filterType = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Get verification details for a transaction.
  Future<VerificationDetails?> getVerificationDetails(String transactionId) async {
    // TODO: Backend - Fetch verification details from blockchain
    
    final transaction = _transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

    if (!transaction.isVerified) return null;

    // Return mock verification details
    return VerificationDetails(
      blockNumber: transaction.blockNumber ?? 0,
      blockHash: '0x${transaction.hash.substring(2, 18)}block',
      timestamp: transaction.date,
      network: 'Polygon Mainnet',
      confirmations: transaction.confirmations,
      gasUsed: 21000,
    );
  }
}
