class CashPaymentModel {
  final String transactionId;
  final String employeeNumber;
  final String employeeName;
  final String reportType;
  final String periodName;
  final String amount;
  final String invoice_num;
  final String sentTime;
  final String acceptedTime;
  final String status;



  CashPaymentModel({
    required this.transactionId,
    required this.reportType,
    required this.periodName,
    required this.employeeNumber,
    required this.employeeName,
    required this.amount,
    required this.invoice_num,
    required this.sentTime,
    required this.acceptedTime,
    required this.status
  });

  factory CashPaymentModel.fromJson(Map<String, dynamic> json) {
    return CashPaymentModel(
        transactionId: json['TRANSACTION_ID'],
        reportType: json['REPORT_TYPE'],
        periodName: json['DATEE'],
        employeeNumber: json['EMPLOYEE_ID'],
        employeeName: json['EMPLOYEE_NAME'],
        amount: json['AMOUNT'],
        invoice_num: json['INVOICE_NUM'],
        sentTime: json['SEND_TIME'],
        acceptedTime: json['ACCEPTED_TIME'],
        status: json['STATUS'],
    );
  }

  @override
  String toString() {
    return 'CashPaymentModel{transactionId: $transactionId, employeeNumber: $employeeNumber, employeeName: $employeeName, reportType: $reportType, periodName: $periodName, amount: $amount,invoice_num: $invoice_num, sentTime: $sentTime, acceptedTime: $acceptedTime, status: $status}';
  }
}