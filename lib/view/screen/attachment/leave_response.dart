class LeaveRequestResponse {
  final int success;
  final String msg;
  final PostData post;
  final List<dynamic> get;

  LeaveRequestResponse({
    required this.success,
    required this.msg,
    required this.post,
    required this.get,
  });

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponse(
      success: json['success'],
      msg: json['msg'],
      post: PostData.fromJson(json['post']),
      get: json['get'],
    );
  }
}

class PostData {
  final String leaveType;
  final String startDate;
  final String endDate;
  final String empId;
  final String empName;

  PostData({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.empId,
    required this.empName,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      empId: json['emp_id'],
      empName: json['emp_name'],
    );
  }
}