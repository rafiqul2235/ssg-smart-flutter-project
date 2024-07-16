import 'dart:convert';

import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

import '../model/response/leaveapproval/leave_approval_history.dart';

class ApprovalHistoryRepo{
  final DioClient dioClient;

  ApprovalHistoryRepo({
    required this.dioClient,
});
  Future<LeaveApprovalHistory> getLeaveApprovalHistory(String invoiceId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.APPROVAL_HISTORY,
        data: {
          'invoice_id': invoiceId
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("Response data of history: $responseData");
        return LeaveApprovalHistory.fromJson(responseData);
      } else {
        throw Exception('Failed to load leave approval history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
