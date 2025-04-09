class BalanceConfirmationModel {
  final String customer;
  final String month;
  final String opennig_bal;
  final String rec_amount;
  final String adj_amount;
  final String so_issue;
  final String delivered;
  final String undelivered;
  final String closing_bal;


  BalanceConfirmationModel({
    required this.customer,
    required this.month,
    required this.opennig_bal,
    required this.rec_amount,
    required this.adj_amount,
    required this.so_issue,
    required this.delivered,
    required this.undelivered,
    required this.closing_bal,
  });

  factory BalanceConfirmationModel.fromJson(Map<String, dynamic> json) {
    return BalanceConfirmationModel(
      customer: json['PARTY_NAME_CUSTOMER_NUMBER'],
      month: json['PERIOD_NAME'],
      opennig_bal: json['OPENING_BALANCE'],
      rec_amount: json['RCV_AMT'],
      adj_amount: json['ADJUSTMENT'],
      so_issue: json['SO_ISSUED'],
      delivered: json['DELIVERED_QTY'],
      undelivered: json['UNDELIVERED_QTY'],
      closing_bal: json['CLOSING_BALANCE'],
    );
  }
}
