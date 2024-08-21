import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/response/attendance_sheet_model.dart';
import 'package:ssg_smart2/data/model/response/attendance_summary_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';

import '../../utill/app_constants.dart';
import '../datasource/remote/exception/api_error_handler.dart';

class AttendanceRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AttendanceRepo({
    required this.dioClient,
    required this.sharedPreferences
  });

  Future<List<AttendanceSheet>> fetchAttendanceSheet(String empId,
      String fromDate, String toDate, String status) async {
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
        if (responseData['success'] == 1 &&
            responseData['attendance_sheet'] != null) {
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

  Future<List<AttendanceSummaryModel>> attendanceSummary(String empId,
      String fromDate, String toDate, String status) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.ATTENDANCE_SUMMARY,
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
        if (responseData['success'] == 1 &&
            responseData['attendance_summary'] != null) {
          return (responseData['attendance_summary'] as List)
              .map((json) => AttendanceSummaryModel.fromJson(json))
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
