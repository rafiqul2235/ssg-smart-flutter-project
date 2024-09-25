
import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/body/pf_installment.dart';
import 'package:ssg_smart2/data/model/body/salary_data.dart';
import 'package:ssg_smart2/data/model/response/SalaryEligibleInfo.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/pf_eligible.dart';
import 'package:ssg_smart2/utill/app_constants.dart';


class PfLoanRepo {
  final DioClient dioClient;

  PfLoanRepo({
    required this.dioClient
});

  Future<PfEligibleInfo> fetchPfEligibilityInfo(String empId) async {
    try{
      final response = await dioClient.postWithFormData(
          AppConstants.PF_ELIGIBLE_INFO,
          data: {
            'emp_id': empId
          }
      );
      if ( response.statusCode == 200 ){
        final Map<String, dynamic> responseData = response.data;
        final eligibilityInfo = responseData['pf_eligible_info'][0];
        return PfEligibleInfo.fromJson(eligibilityInfo);
      }else{
        throw Exception('Failed to load data');
      }
    }catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPfLoanInfo(String empId) async {
    try{
      final response = await dioClient.postWithFormData(
          AppConstants.PF_LOAN_INFO,
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

  Future<List<PfInstallment>> fetchPfInstallment() async {
    try{
      final response = await dioClient.get(
          AppConstants.PF_INSTALLMENT,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data['success'] == 1) {
          final List<dynamic> installments = data['pf_installment'];
          return installments.map((json) => PfInstallment.fromJson(json)).toList();
        } else {
          throw Exception('API request failed');
        }
      } else {
        throw Exception('Failed to load PF installments');
      }
    }catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future<ApiResponse> submitData(SalaryAdvanceData salaryAdvData) async {
  //   try{
  //     Response response = await dioClient.post(
  //       AppConstants.SAL_LOAN,
  //       data: salaryAdvData.toJson()
  //     );
  //     return ApiResponse.withSuccess(response);
  //   }catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }

}

