import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';

import '../../utill/app_constants.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';

class ApprovalRepo{
  final DioClient dioClient;

  ApprovalRepo({
    required this.dioClient,
  });

  Future<List<ApprovalFlow>> fetchApprovalFlow(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.APPROVAL_HISTORY,
        data: {
          'emp_id': empId,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 && responseData['approval_flow'] != null) {
          return (responseData['approval_flow'] as List)
              .map((json) => ApprovalFlow.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load approval flow');
        }
      } else {
        throw Exception('Failed to load approval flow');
      }
    } catch (e) {
      throw Exception('Error fetching approval flow: $e');
    }
  }



  Future<ApiResponse> handleApproval(String notificationId, String action, String comments) async {
    print("noti_id: $notificationId, action: $action, comments: $comments");
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.CHUTI_APPROVAL,
        data: {
          'notification_id': notificationId,
          'action': action,
          'comment': comments,
        },
      );
      print("Response: $response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Leave Repo getLeaveBalance ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}