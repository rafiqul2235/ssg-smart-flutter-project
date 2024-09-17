
import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/body/salary_data.dart';
import 'package:ssg_smart2/data/model/response/SalaryEligibleInfo.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class SalaryAdvRepo {
  final DioClient dioClient;

  SalaryAdvRepo({
    required this.dioClient
});

  Future<SalaryEligibleInfo> fetchSalaryInfo(String empId) async {
    try{
      final response = await dioClient.postWithFormData(
          AppConstants.SAL_ELIGIBLE_INFO,
          data: {
            'emp_id': empId
          }
      );
      if ( response.statusCode == 200 ){
        final Map<String, dynamic> responseData = response.data;
        final eligibilityInfo = responseData['sal_eligible_info'][0];
        return SalaryEligibleInfo.fromJson(eligibilityInfo);
      }else{
        throw Exception('Failed to load data');
      }
    }catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSalLoanInfo(String empId) async {
    try{
      final response = await dioClient.postWithFormData(
          AppConstants.SAL_LOAN_INFO,
          data: {
            'emp_id': empId
          }
      );
      if ( response.statusCode == 200 ){
        final Map<String, dynamic> responseData = response.data;
        return responseData;
      }else{
        throw Exception('Failed to load data');
      }
    }catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ApiResponse> submitData(SalaryAdvanceData salaryAdvData) async {
    try{
      Response response = await dioClient.post(
        AppConstants.SAL_LOAN,
        data: salaryAdvData.toJson()
      );
      return ApiResponse.withSuccess(response);
    }catch (e) {
      throw Exception('Error: $e');
    }
  }

}

