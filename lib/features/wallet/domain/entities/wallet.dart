class WalletBalance {
  final double totalBalance;
  final double depositBalance;
  final double winningBalance;
  final double bonusBalance;

  const WalletBalance({
    this.totalBalance = 0,
    this.depositBalance = 0,
    this.winningBalance = 0,
    this.bonusBalance = 0,
  });
}

class Transaction {
  final int transactionId;
  final String type;
  final String description;
  final double amount;
  final String createdAt;
  final String status;

  const Transaction({
    required this.transactionId,
    required this.type,
    required this.description,
    required this.amount,
    required this.createdAt,
    this.status = '',
  });

  bool get isCredit => type.toLowerCase() == 'credit';
}
