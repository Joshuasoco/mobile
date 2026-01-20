/// MSME Pathways - Transaction History Screen
/// 
/// Display blockchain-verified transaction history.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/blockchain_model.dart';
import '../../viewmodels/blockchain_viewmodel.dart';

/// Transaction history screen with blockchain verification.
class TransactionHistoryScreen extends StatelessWidget {
  /// Creates the transaction history screen.
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlockchainViewModel(),
      child: const _TransactionHistoryContent(),
    );
  }
}

class _TransactionHistoryContent extends StatefulWidget {
  const _TransactionHistoryContent();

  @override
  State<_TransactionHistoryContent> createState() => _TransactionHistoryContentState();
}

class _TransactionHistoryContentState extends State<_TransactionHistoryContent> {
  final _searchController = TextEditingController();

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlockchainViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Transaction History',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2D3748)),
                onPressed: viewModel.refresh,
              ),
            ],
          ),
          body: Column(
            children: [
              // Stats and search
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  children: [
                    // Stats row
                    Row(
                      children: [
                        _buildStatBadge(
                          '${viewModel.confirmedCount}',
                          'Verified',
                          AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        _buildStatBadge(
                          '${viewModel.pendingCount}',
                          'Pending',
                          AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Search
                    TextField(
                      controller: _searchController,
                      onChanged: viewModel.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by hash or loan ID...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFFA0AEC0),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF718096),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    _buildFilterChip(
                      'All',
                      viewModel.filterType == null,
                      () => viewModel.setFilter(null),
                    ),
                    const SizedBox(width: 10),
                    ...TransactionType.values.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildFilterChip(
                          type.label,
                          viewModel.filterType == type,
                          () => viewModel.setFilter(type),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              
              // Transaction list
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.filteredTransactions.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: viewModel.filteredTransactions.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final transaction = viewModel.filteredTransactions[index];
                              return _TransactionTile(
                                transaction: transaction,
                                onTap: () => _showTransactionDetail(context, transaction),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '$value $label',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF718096),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: const Color(0xFFA0AEC0),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history will appear here',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, BlockchainTransaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TransactionDetailSheet(transaction: transaction),
    );
  }
}

/// Transaction tile widget.
class _TransactionTile extends StatelessWidget {
  final BlockchainTransaction transaction;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _getTypeColor(transaction.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(transaction.type),
                color: _getTypeColor(transaction.type),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 14),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        transaction.type.label,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      if (transaction.isVerified) ...[
                        const SizedBox(width: 6),
                        const _VerificationBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.description ?? transaction.shortHash,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.dateFormatted,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFFA0AEC0),
                    ),
                  ),
                ],
              ),
            ),
            
            // Amount
            if (transaction.amount > 0)
              Text(
                transaction.amountFormatted,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: transaction.type == TransactionType.repayment
                      ? AppColors.error
                      : AppColors.success,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.disbursement:
        return AppColors.success;
      case TransactionType.repayment:
        return AppColors.primary;
      case TransactionType.verification:
        return const Color(0xFF5C6BC0);
    }
  }

  IconData _getTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.disbursement:
        return Icons.arrow_downward_rounded;
      case TransactionType.repayment:
        return Icons.arrow_upward_rounded;
      case TransactionType.verification:
        return Icons.verified_outlined;
    }
  }
}

/// Small verification badge.
class _VerificationBadge extends StatelessWidget {
  const _VerificationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 3),
          Text(
            'Verified',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

/// Transaction detail bottom sheet.
class _TransactionDetailSheet extends StatelessWidget {
  final BlockchainTransaction transaction;

  const _TransactionDetailSheet({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              8,
              24,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Transaction Details',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const Spacer(),
                    if (transaction.isVerified) const _VerificationBadge(),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Details
                _buildDetailRow('Type', transaction.type.label),
                if (transaction.amount > 0)
                  _buildDetailRow('Amount', transaction.amountFormatted),
                _buildDetailRow('Date', transaction.dateFormatted),
                _buildDetailRow('Status', transaction.status.label),
                if (transaction.loanId != null)
                  _buildDetailRow('Loan ID', transaction.loanId!),
                if (transaction.description != null)
                  _buildDetailRow('Description', transaction.description!),
                
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                
                // Blockchain details
                Text(
                  'Blockchain Verification',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 12),
                
                _buildDetailRow('Transaction Hash', transaction.shortHash),
                if (transaction.blockNumber != null)
                  _buildDetailRow('Block Number', '${transaction.blockNumber}'),
                _buildDetailRow('Confirmations', '${transaction.confirmations}'),
                _buildDetailRow('Network', 'Polygon Mainnet'),
                
                const SizedBox(height: 20),
                
                // Copy hash button
                OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: transaction.hash));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hash copied!', style: GoogleFonts.inter()),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copy Full Hash'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF718096),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
