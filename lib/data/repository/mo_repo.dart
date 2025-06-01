import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/body/mo_list.dart';
import 'package:ssg_smart2/data/model/response/moveOrderResponse.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class MoveOrderRepo{
  final DioClient dioClient;

  MoveOrderRepo({
    required this.dioClient
});

  Future<List<MoveOrderItem>> fetchMoveOrderList(String empId) async {
    print('starting call repo');
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.MO_LIST,
        data: {
          'emp_id' : empId
        }
      );
      print('repo middle');
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print('mo_list(Repo):${responseData}');
        if(responseData['success'] == 1 && responseData['mo_list'] != null) {
          return (responseData['mo_list'] as List)
              .map((moList) => MoveOrderItem.fromJson(moList))
              .toList();
        }
      }
      return [];
    } catch(e) {
      print('Error: ${e.toString()}');
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<MoveOrderItem>> fetchApproverMoveOrderList(String empId) async {
    print('starting call repo');
    try {
      final response = await dioClient.postWithFormData(
          AppConstants.APPROVER_MO_LIST,
          data: {
            'emp_id' : empId
          }
      );
      print('repo middle');
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print('mo_list(Repo):${responseData}');
        if(responseData['success'] == 1 && responseData['mo_list'] != null) {
          return (responseData['mo_list'] as List)
              .map((moList) => MoveOrderItem.fromJson(moList))
              .toList();
        }
      }
      return [];
    } catch(e) {
      print('Error: ${e.toString()}');
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<MoveOrderResponse> fetchMoveOrderDetails(String orgId, String moNo) async {
    try {
      print('mo repo: $orgId and $moNo');
      final response = await dioClient.postWithFormData(
          AppConstants.MO_DETAILS,
          data: {
            'org_id' : orgId,
            'mo_no' : moNo
          }
      );
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if(responseData['success'] == 1 && responseData['mo_details'] != null) {
          return MoveOrderResponse.fromJson(responseData);
        }
      }
      throw new Exception("Failed to fetch mo details");
    } catch(e) {
      print('Error: ${e.toString()}');
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Map<String, dynamic>> submitMoveOrder(String headerId) async {
      final response = await dioClient.postWithFormData(
        AppConstants.MO_SUBMISSION,
        data: {
          'header_id' : headerId
        }
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return data;
      }else {
        throw Exception("Failed to submit MO");
      }
  }

  Future<Map<String, dynamic>> handleMoveOrder(String applicationType, String notificationId, String action, String comment) async {
    final response = await dioClient.postWithFormData(
        AppConstants.APPROVAL_FLOW,
        data: {
          'application_type' : applicationType,
          'notification_id' : notificationId,
          'action' : action,
          'comment' : comment
        }
    );
    if (response.statusCode == 200) {
      final data = response.data;
      print("data:$data");
      return data;
    }else {
      throw Exception("Failed to submit MO");
    }
  }

}