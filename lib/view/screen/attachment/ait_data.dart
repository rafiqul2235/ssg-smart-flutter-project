class AitData {
  final String aitAutomationId;
  final String customerName;
  final String challanNo;
  final String invoiceAmount;
  final String aitAmount;
  final String challanDate;
  final List<String> filePaths;

  AitData({
    required this.aitAutomationId,
    required this.customerName,
    required this.challanNo,
    required this.invoiceAmount,
    required this.aitAmount,
    required this.challanDate,
    required this.filePaths,
  });

  factory AitData.fromJson(Map<String, dynamic> json) {
    return AitData(
      aitAutomationId: json['ait_automation_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      challanNo: json['challan_no'] ?? '',
      invoiceAmount: json['invoice_amount'] ?? '',
      aitAmount: json['ait_amount'] ?? '',
      challanDate: json['challan_date'] ?? '',
      filePaths: List<String>.from(json['file_paths'] ?? []),
    );
  }
}