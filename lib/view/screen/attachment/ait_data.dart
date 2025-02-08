class AitData {
  final String headerId;
  final String customerId;
  final String customerAccount;
  final String customerName;
  final String invoiceAmount;
  final String aitAmount;
  final String challanNo;
  final String challanDate;
  final String statusFlg;
  final String remarks;
  final String status;

 AitData({
   required this.headerId,
   required this.customerId,
   required this.customerAccount,
   required this.customerName,
   required this.challanNo,
   required this.challanDate,
   required this.statusFlg,
   required this.invoiceAmount,
   required this.aitAmount,
   required this.remarks,
   required this.status,
});
  factory AitData.fromJson(Map<String, dynamic> json) {
    return AitData(
      headerId: json['headerId'] ?? '',
      customerId: json['customerId'] ?? '',
      customerAccount: json['customerAccount'] ?? '',
      statusFlg: json['statusflag'] ?? '',
      customerName: json['customerName'] ?? '',
      challanNo: json['challanNo'] ?? '',
      challanDate: json['challanDate'] ?? '',
      invoiceAmount: json['invoiceAmount'] ?? '',
      aitAmount: json['aitAmount'] ?? '',
      remarks: json['remarks'] ?? '',
      status: json['status'] ?? ''
    );
  }


}
