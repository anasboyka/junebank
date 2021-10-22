class Transaction {
  final double amount;
  final DateTime transactionDate;
  final bool isReceive;
  final String transactionTitle;

  Transaction(
      {this.amount,
      this.transactionDate,
      this.isReceive,
      this.transactionTitle});
}
