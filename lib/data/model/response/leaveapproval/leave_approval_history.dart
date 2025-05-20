
import 'package:ssg_smart2/data/model/response/leaveapproval/leave_approval.dart';

import 'application_info.dart';

class LeaveApprovalHistory {
  final int success;
  final List<String> msg;
  final List<PendingSO> pendingSO;
  final List<ApplicationInfo> applicationInfo;
  final Map<String, dynamic> post;
  final Map<String, dynamic> get;

  LeaveApprovalHistory({
    required this.success,
    required this.msg,
    required this.pendingSO,
    required this.applicationInfo,
    required this.post,
    required this.get,
  });

  factory LeaveApprovalHistory.fromJson(Map<String, dynamic> json) {
    return LeaveApprovalHistory(
      success: json['success'],
      msg: List<String>.from(json['msg']),
      pendingSO: (json['pending_so'] as List)
          .map((item) => PendingSO.fromJson(item))
          .toList(),
      applicationInfo: (json['application_info'] as List)
          .map((item) => ApplicationInfo.fromJson(item))
          .toList(),
      post: json['post'],
      get: json['get'],
    );
  }

  @override
  String toString() {
    return 'LeaveApprovalHistory{success: $success, msg: $msg, pendingSO: $pendingSO, applicationInfo: $applicationInfo, post: $post, get: $get}';
  }
}