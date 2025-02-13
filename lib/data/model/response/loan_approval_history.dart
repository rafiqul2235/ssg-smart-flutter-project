
import 'package:ssg_smart2/data/model/response/loan_application_info.dart';


class LoanApprovalHistory {
  final int success;
  final List<String> msg;
  final List<LoanApplicationInfo> applicationInfo;
  final Map<String, dynamic> post;
  final List<dynamic> get;

  LoanApprovalHistory({
    required this.success,
    required this.msg,
    required this.applicationInfo,
    required this.post,
    required this.get,
  });

  factory LoanApprovalHistory.fromJson(Map<String, dynamic> json) {
    return LoanApprovalHistory(
      success: json['success'],
      msg: List<String>.from(json['msg']),
      applicationInfo: (json['application_info'] as List)
          .map((item) => LoanApplicationInfo.fromJson(item))
          .toList(),
      post: json['post'],
      get: json['get'],
    );
  }

  @override
  String toString() {
    return 'LeaveApprovalHistory{success: $success, msg: $msg, applicationInfo: $applicationInfo, post: $post, get: $get}';
  }
}
