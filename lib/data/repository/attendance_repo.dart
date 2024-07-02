import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/response/attendance_sheet_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';

import '../../utill/app_constants.dart';
import '../datasource/remote/exception/api_error_handler.dart';

class AttendanceRepo{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AttendanceRepo({
    required this.dioClient,
    required this.sharedPreferences
});

  Future<ApiResponse> getAttendanceSheet(String empId, String fromDate, String toDate, String status) async {
    try {
      print("Starting api running.");
      final Map<String, dynamic> data = <String, dynamic>{};
      data['emp_id'] = empId;
      data['fromDate'] = fromDate;
      data['toDate'] = toDate;
      data['status'] = status;
      Response response = await dioClient.postWithFormData(
        AppConstants.ATTENDANCE_DATA,
        data:data,
      );
      print("response from repo: $response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('pfData ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<List<AttendanceSheet>> fetchAttendanceSheet(String empId, String fromDate, String toDate, String status) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.ATTENDANCE_DATA,
        data: {
          'emp_id': empId,
          'fromDate': fromDate,
          'toDate': toDate,
          'status': status,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 && responseData['attendance_sheet'] != null) {
          return (responseData['attendance_sheet'] as List)
              .map((json) => AttendanceSheet.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load attendance sheet');
        }
      } else {
        throw Exception('Failed to load attendance sheet');
      }
    } catch (e) {
      throw Exception('Error fetching attendance sheet: $e');
    }
  }
}

