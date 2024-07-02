class AttendanceSheet {
  final String srlNum;
  final String wHour;
  final String actInTime;
  final String actOutTime;
  final String employeeNumber;
  final String employmentCategory;
  final String dept;
  final String groupName;
  final String workingDate;
  final String workingDay;
  final String status;
  final String leaveType;
  final String locationCode;
  final String payrollName;
  final String val;

  AttendanceSheet({
    required this.srlNum,
    required this.wHour,
    required this.actInTime,
    required this.actOutTime,
    required this.employeeNumber,
    required this.employmentCategory,
    required this.dept,
    required this.groupName,
    required this.workingDate,
    required this.workingDay,
    required this.status,
    required this.leaveType,
    required this.locationCode,
    required this.payrollName,
    required this.val,
  });

  factory AttendanceSheet.fromJson(Map<String, dynamic> json) {
    return AttendanceSheet(
      srlNum: json['SRL_NUM'],
      wHour: json['W_HOUR'],
      actInTime: json['ACT_IN_TIME'],
      actOutTime: json['ACT_OUT_TIME'],
      employeeNumber: json['EMPLOYEE_NUMBER'],
      employmentCategory: json['EMPLOYMENT_CATEGORY'],
      dept: json['DEPT'],
      groupName: json['GROUP_NAME'],
      workingDate: json['WORKING_DATE'],
      workingDay: json['WORKING_DAY'],
      status: json['STATUS'],
      leaveType: json['LEAVE_TYPE'],
      locationCode: json['LOCATION_CODE'],
      payrollName: json['PAYROLL_NAME'],
      val: json['VAL'],
    );
  }
}
