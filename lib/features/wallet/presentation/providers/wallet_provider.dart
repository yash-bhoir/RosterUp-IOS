import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../../domain/entities/wallet.dart';

final walletBalanceProvider =
    AsyncNotifierProvider<WalletBalanceNotifier, WalletBalance>(
  WalletBalanceNotifier.new,
);

class WalletBalanceNotifier extends AsyncNotifier<WalletBalance> {
  @override
  Future<WalletBalance> build() async {
    final ds = ref.read(walletRemoteDatasourceProvider);
    final json = await ds.getBalance();
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return WalletBalance(
      totalBalance: (data['total_balance'] ?? 0).toDouble(),
      depositBalance: (data['deposit_balance'] ?? 0).toDouble(),
      winningBalance: (data['winning_balance'] ?? 0).toDouble(),
      bonusBalance: (data['bonus_balance'] ?? 0).toDouble(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final contestTransactionsProvider =
    AsyncNotifierProvider<ContestTransactionsNotifier, List<Transaction>>(
  ContestTransactionsNotifier.new,
);

class ContestTransactionsNotifier extends AsyncNotifier<List<Transaction>> {
  @override
  Future<List<Transaction>> build() async {
    final ds = ref.read(walletRemoteDatasourceProvider);
    final json = await ds.getContestTransactions();
    return _parseTransactions(json);
  }
}

final otherTransactionsProvider =
    AsyncNotifierProvider<OtherTransactionsNotifier, List<Transaction>>(
  OtherTransactionsNotifier.new,
);

class OtherTransactionsNotifier extends AsyncNotifier<List<Transaction>> {
  @override
  Future<List<Transaction>> build() async {
    final ds = ref.read(walletRemoteDatasourceProvider);
    final json = await ds.getOtherTransactions();
    return _parseTransactions(json);
  }
}

List<Transaction> _parseTransactions(Map<String, dynamic> json) {
  final data = json['data'];
  List<dynamic> items = [];
  if (data is Map<String, dynamic>) {
    items = data['data'] as List<dynamic>? ?? [];
  } else if (data is List) {
    items = data;
  }
  return items.map((e) {
    final m = e as Map<String, dynamic>;
    return Transaction(
      transactionId: m['transaction_id'] ?? m['id'] ?? 0,
      type: m['type'] ?? '',
      description: m['description'] ?? '',
      amount: (m['amount'] ?? 0).toDouble(),
      createdAt: m['created_at'] ?? '',
      status: m['status'] ?? '',
    );
  }).toList();
}
