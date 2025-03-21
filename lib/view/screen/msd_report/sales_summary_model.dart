class SalesSummaryModel {
  final String cust_account;
  final String cust_name;
  final String sales_qty;
  final String collection_qty;
  final String delivery_qty;


  SalesSummaryModel({
    required this.cust_account,
    required this.cust_name,
    required this.sales_qty,
    required this.collection_qty,
    required this.delivery_qty,
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      cust_account: json['CUSTOMER_ACC'],
      cust_name: json['CUSTOMER_NAME'],
      sales_qty: json['SALES_QTY'],
      collection_qty: json['COLLECTION_AMNT'],
      delivery_qty: json['DELV_REQ_QTY'],
    );
  }
}
