import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/body/mo_list.dart';
import 'package:ssg_smart2/data/model/body/move_order_details.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class MoveOrderRepo{
  final DioClient dioClient;

  MoveOrderRepo({
    required this.dioClient
});

  Future<List<MoveOrderItem>> fetchMoveOrderList(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.MO_LIST,
        data: {
          'emp_id' : empId
        }
      );
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
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

  Future<List<MoveOrderDetails>> fetchMoveOrderDetails(String orgId, String moNo) async {
    try {
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
          return (responseData['mo_details'] as List)
              .map((moList) => MoveOrderDetails.fromJson(moList))
              .toList();
        }
      }
      return [];
    } catch(e) {
      print('Error: ${e.toString()}');
      throw Exception('Failed to fetch data: $e');
    }
  }

}