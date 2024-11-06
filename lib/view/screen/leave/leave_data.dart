class AttachmentData {
  final String customerId;
  final String customerName;
  final String challanNo;
  final String date;
  final String imageUrl;

  AttachmentData({
    required this.customerId,
    required this.customerName,
    required this.challanNo,
    required this.date,
    required this.imageUrl,
  });

  factory AttachmentData.fromJson(Map<String, dynamic> json) {
    return AttachmentData(
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      challanNo: json['leave_type'],
      date: json['start_date'],
      imageUrl: json['url'],
    );
  }

  @override
  String toString() {
    return 'AttachmentData{empId: $customerId, empName: $customerName, leaveType: $challanNo, startDate: $date,imageUrl: $imageUrl}';
  }
}