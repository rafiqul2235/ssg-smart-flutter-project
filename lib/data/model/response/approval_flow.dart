class ApprovalFlow {
  final String notificationId;
  final String reportHeaderId;
  final String statusFlg;
  final String employeeNumber;
  final String employeeName;
  final String designation;
  final String leaveType;
  final String leaveStartDate;
  final String leaveEndDate;
  final String leaveDuration;
  final String reason;

  ApprovalFlow({
    required this.notificationId,
    required this.reportHeaderId,
    required this.statusFlg,
    required this.employeeNumber,
    required this.employeeName,
    required this.designation,
    required this.leaveType,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.leaveDuration,
    required this.reason,
  });

  factory ApprovalFlow.fromJson(Map<String, dynamic> json) {
    return ApprovalFlow(
      notificationId: json['NOTIFICATION_ID'],
      reportHeaderId: json['REPORT_HEADER_ID'],
      statusFlg: json['STATUS_FLG'],
      employeeNumber: json['EMPLOYEE_NUMBER'],
      employeeName: json['EMPLOYEE_NAME'],
      designation: json['DESIGNATION'],
      leaveType: json['LEAVE_TYPE'],
      leaveStartDate: json['LEAVE_START_DATE'],
      leaveEndDate: json['LEAVE_END_DATE'],
      leaveDuration: json['LEAVE_DURATION'],
      reason: json['REASON'],
    );
  }

  @override
  String toString() {
    return 'ApprovalFlow{notificationId: $notificationId, reportHeaderId: $reportHeaderId, statusFlg: $statusFlg, employeeNumber: $employeeNumber, employeeName: $employeeName, designation: $designation, leaveStartDate: $leaveStartDate, leaveEndDate: $leaveEndDate, leaveDuration: $leaveDuration, reason: $reason}';
  }
}