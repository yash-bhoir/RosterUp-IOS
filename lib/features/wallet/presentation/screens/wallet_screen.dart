import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/wallet.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Wallet', style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Balance card
          balanceAsync.when(
            loading: () => const Padding(
              padding: AppSpacing.paddingLg,
              child: LoadingIndicator(),
            ),
            error: (e, _) => AppErrorWidget(
              message: e.toString(),
              onRetry: () =>
                  ref.read(walletBalanceProvider.notifier).refresh(),
            ),
            data: (balance) => _BalanceCard(balance: balance),
          ),
          // Transaction tabs
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: AppColors.darkText,
                    child: TabBar(
                      labelStyle: AppTypography.tab,
                      indicatorColor: AppColors.primaryDark,
                      labelColor: AppColors.primaryDark,
                      unselectedLabelColor: AppColors.themeText,
                      tabs: const [
                        Tab(text: 'Contest'),
                        Tab(text: 'Other'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _TransactionList(
                          provider: contestTransactionsProvider,
                        ),
                        _TransactionList(
                          provider: otherTransactionsProvider,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final WalletBalance balance;

  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.paddingMd,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.statusBar, Color(0xFF2A1800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Column(
        children: [
          Text('Total Balance', style: AppTypography.caption),
          AppSpacing.gapVSm,
          Text(
            '₹${balance.totalBalance.toStringAsFixed(2)}',
            style: AppTypography.heading1.copyWith(
              color: AppColors.primaryDark,
              fontSize: 28,
            ),
          ),
          AppSpacing.gapVLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniStat('Deposit', balance.depositBalance),
              _divider(),
              _miniStat('Winnings', balance.winningBalance),
              _divider(),
              _miniStat('Bonus', balance.bonusBalance),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, double value) {
    return Column(
      children: [
        Text(label, style: AppTypography.captionSmall),
        AppSpacing.gapVXs,
        Text(
          '₹${value.toStringAsFixed(2)}',
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30,
      color: AppColors.matchBar,
    );
  }
}

class _TransactionList extends ConsumerWidget {
  final AsyncNotifierProvider<AsyncNotifier<List<Transaction>>,
      List<Transaction>> provider;

  const _TransactionList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    return state.when(
      loading: () => const LoadingIndicator(),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.invalidate(provider),
      ),
      data: (transactions) {
        if (transactions.isEmpty) {
          return const EmptyWidget(
            message: 'No transactions yet',
            icon: Icons.receipt_long_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColors.matchBar,
          ),
          itemBuilder: (context, index) {
            final txn = transactions[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: txn.isCredit
                    ? AppColors.green.withOpacity(0.2)
                    : AppColors.red.withOpacity(0.2),
                child: Icon(
                  txn.isCredit
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 18,
                  color: txn.isCredit ? AppColors.green : AppColors.red,
                ),
              ),
              title: Text(
                txn.description,
                style: AppTypography.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(txn.createdAt, style: AppTypography.captionSmall),
              trailing: Text(
                '${txn.isCredit ? '+' : '-'}₹${txn.amount.toStringAsFixed(2)}',
                style: AppTypography.labelSmall.copyWith(
                  color: txn.isCredit ? AppColors.green : AppColors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
