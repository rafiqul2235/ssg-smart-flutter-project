class LeaveData{
  String? empName;
  String? empNumber;
  String? department;
  String? designation;
  String? orgId;
  String? orgName;
  String? personId;
  String? workLocation;
  String? leaveType;
  String? leaveId;
  String? startDate;
  String? endDate;
  String? duration;
  String? comment;

  LeaveData({
    required this.empName,
    required this.empNumber,
    required this.department,
    required this.designation,
    required this.orgId,
    required this.orgName,
    required this.personId,
    required this.workLocation,
    required this.leaveType,
    required this.leaveId,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.comment
});

  Map<String, dynamic> toJson(){
    return{
      'emp_name': empName,
      'emp_number': empNumber,
      'department': department,
      'designation': designation,
      'org_id': orgId,
      'org_name': orgName,
      'person_id': personId,
      'work_location': workLocation,
      'leave_type': leaveType,
      'leave_id': leaveId,
      'leave_start_date': startDate,
      'leave_end_date': endDate,
      'leave_duration': duration,
      'comment': comment
    };
  }

  @override
  String toString() {
    return 'LeaveData{empName: $empName, empNumber: $empNumber, department: $department, designation: $designation, orgId: $orgId, orgName: $orgName, personId: $personId, workLocation: $workLocation, leaveType: $leaveType, leaveId: $leaveId, startDate: $startDate, endDate: $endDate, duration: $duration, comment: $comment}';
  }
}