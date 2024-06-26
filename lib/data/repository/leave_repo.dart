import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/body/leave_data.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRepo {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  LeaveRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> checkDuplicateLeave(String? empId, String? startDate) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['emp_id'] = empId;
      data['start_date'] = startDate;
      Response response = await dioClient.postWithFormData(
        AppConstants.DUPLICATE_LEAVE,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Leave Repo getLeaveBalance ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> applyLeave(LeaveData leaveData) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LEAVE_APPLY,
        data:leaveData.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Leave Repo getLeaveBalance ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLeaveBalance(String empId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['emp_id'] = empId;
      Response response = await dioClient.postWithFormData(
        AppConstants.LEAVE_BALANCE,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Leave Repo getLeaveBalance ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLeaveType() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.LEAVE_TYPE,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Leave Repo getLeaveType ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
