import 'package:ssg_smart2/data/model/body/ait_details.dart';
import 'package:ssg_smart2/data/model/body/approver.dart';
import 'package:ssg_smart2/data/model/body/move_order_details.dart';

import '../../../view/screen/moveorder/user/mo_details.dart';

class MoveOrderResponse {
  final int success;
  final List<dynamic> msg;
  final List<MoveOrderDetails> moveOrderDetails;
  final List<ApproverDetail> approverList;
  final Map<String, dynamic> post;
  final List<dynamic> get;

  MoveOrderResponse({
    required this.success,
    required this.msg,
    required this.moveOrderDetails,
    required this.approverList,
    required this.post,
    required this.get,
  });

  factory MoveOrderResponse.fromJson(Map<String, dynamic> json) {
    return MoveOrderResponse(
      success: json['success'] ?? 0,
      msg: json['msg'] ?? [],
      moveOrderDetails: (json['mo_details'] as List?)
          ?.map((e) => MoveOrderDetails.fromJson(e))
          .toList() ?? [],
      approverList: (json['approval_history'] as List?)
          ?.map((e) => ApproverDetail.fromJson(e))
          .toList() ?? [],
      post: json['post'] ?? {},
      get: json['get'] ?? [],
    );
  }

  @override
  String toString() {
    return 'MoveOrderResponse{success: $success, msg: $msg, moveOrderDetails: $moveOrderDetails, approverList: $approverList, post: $post, get: $get}';
  }
}