class ApplicationInfo {
  final String leaveType;
  final String leaveStartDate;
  final String leaveEndDate;
  final String leaveDuration;

  ApplicationInfo({
    required this.leaveType,
    required this.leaveStartDate,
    required this.leaveEndDate,
    required this.leaveDuration,
  });

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) {
    return ApplicationInfo(
      leaveType: json['LEAVE_TYPE'],
      leaveStartDate: json['LEAVE_START_DATE'],
      leaveEndDate: json['LEAVE_END_DATE'],
      leaveDuration: json['LEAVE_DURATION'],
    );
  }

  @override
  String toString() {
    return 'ApplicationInfo{leaveType: $leaveType, leaveStartDate: $leaveStartDate, leaveEndDate: $leaveEndDate, leaveDuration: $leaveDuration}';
  }
}
