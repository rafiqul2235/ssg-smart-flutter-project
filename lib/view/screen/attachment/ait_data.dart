class AitData {
  final String headerId;
  final String customerId;
  final String notificationId;
  final String customerName;
  final String challanNo;
  final String invoiceAmount;
  final String aitAmount;
  final String challanDate;
  final List<String> filePaths;

 AitData({
   required this.headerId,
   required this.customerId,
   required this.notificationId,
   required this.customerName,
   required this.challanNo,
   required this.challanDate,
   required this.invoiceAmount,
   required this.aitAmount,
   required this.filePaths
});
  factory AitData.fromJson(Map<String, dynamic> json) {
    return AitData(
      headerId: json['headerId'] ?? '',
      customerId: json['customerId'],
      notificationId: json['notificationId'],
      customerName: json['customerName'] ?? '',
      challanNo: json['challanNo'] ?? '',
      challanDate: json['challanDate'] ?? '',
      invoiceAmount: json['invoiceAmount'] ?? '',
      aitAmount: json['aitAmount'] ?? '',
      filePaths: List<String>.from(json['file_paths'] ?? []),
    );
  }

  @override
  String toString() {
    return 'AitData{headerId: $headerId, customerId: $customerId,notificationId: $notificationId, customerName: $customerName, challanNo: $challanNo, invoiceAmount: $invoiceAmount, aitAmount: $aitAmount, challanDate: $challanDate, filePaths: $filePaths}';
  }
}