class VaBankListModel {
  final String customer_name;
  final String va_bank_list;
  final String cust_account_number;


  VaBankListModel({
    required this.customer_name,
    required this.va_bank_list,
    required this.cust_account_number
  });

  factory VaBankListModel.fromJson(Map<String, dynamic> json) {
    return VaBankListModel(
        customer_name: json['CUSTOMER_NAME'],
        va_bank_list: json['BANK_VA_LIST'],
        cust_account_number: json['ACCOUNT_NUMBER']
    );
  }
}
