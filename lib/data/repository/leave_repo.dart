import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRepo {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  LeaveRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> applyLeave(Map<String, dynamic> data) async {
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.LEAVE_APPLY,
        data:data,
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

  Future<ApiResponse> getManagementData(String soures) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['soures'] = soures;
      Response response = await dioClient.postWithFormData(
        AppConstants.MANAGEMENT_DATA,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('managementDashboard ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPfData(String empId,orgId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['emp_id'] = empId;
      data['org_id'] = orgId;
      Response response = await dioClient.postWithFormData(
        AppConstants.PF_DATA,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('pfData ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getApprovalList(String empId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['emp_id'] = empId;

      final response = await dioClient.postWithFormData(
          AppConstants.APPROVAL_List,
          data:data
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
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
