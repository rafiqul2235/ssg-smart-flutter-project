class CustBalSupervisorModel {
  final String customer_name;
  final String cust_account;
  final String balance;


  CustBalSupervisorModel({
    required this.customer_name,
    required this.cust_account,
    required this.balance
  });

  factory CustBalSupervisorModel.fromJson(Map<String, dynamic> json) {
    return CustBalSupervisorModel(
        customer_name: json['CUSTOMER_NAME'],
        cust_account: json['CUST_ACC'],
        balance: json['CREDIT_AVAILABLE']
    );
  }
}
