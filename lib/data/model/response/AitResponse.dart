import 'package:ssg_smart2/data/model/body/ait_details.dart';
import 'package:ssg_smart2/data/model/body/approver.dart';

class AitResponse {
  final int success;
  final List<dynamic> msg;
  final AitDetail? aitDetails;
  final List<ApproverDetail> approverList;
  final Map<String, dynamic> post;
  final List<dynamic> get;

  AitResponse({
    required this.success,
    required this.msg,
    required this.aitDetails,
    required this.approverList,
    required this.post,
    required this.get,
  });

  factory AitResponse.fromJson(Map<String, dynamic> json) {
    return AitResponse(
      success: json['success'] ?? 0,
      msg: json['msg'] ?? [],
      aitDetails: AitDetail.fromJson(json['ait_details']),
      approverList: (json['approver_list'] as List?)
          ?.map((e) => ApproverDetail.fromJson(e))
          .toList() ?? [],
      post: json['post'] ?? {},
      get: json['get'] ?? [],
    );
  }
}