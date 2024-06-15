class LeaveData{
  String? leaveType;
  String? startDate;
  String? endDate;
  String? duration;
  String? comment;

  LeaveData({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.comment
});

  Map<String, dynamic> toJson(){
    return{
      'leave_type': leaveType,
      'leave_start_date': startDate,
      'leave_end_date': endDate,
      'leave_duration': duration,
      'comment': comment
    };
  }

}