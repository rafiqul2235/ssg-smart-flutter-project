import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';

import '../../utill/app_constants.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';
import '../model/response/cashpayment_model.dart';

class CashPaymentRepo{
  final DioClient dioClient;

  CashPaymentRepo({
    required this.dioClient,
  });

  Future<List<CashPaymentModel>> fetchCashPaymentData(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.CASH_PAYMENT_AKG,
        data: {
          'emp_id': empId,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 && responseData['get_cash_pay'] != null) {
          return (responseData['get_cash_pay'] as List)
              .map((json) => CashPaymentModel.fromJson(json))
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

  Future<List<CashPaymentModel>> fetchCashPaymentHistory(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.CASH_PAYMENT_HISTORY,
        data: {
          'emp_id': empId,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 && responseData['get_cash_pay_his'] != null) {
          return (responseData['get_cash_pay_his'] as List)
              .map((json) => CashPaymentModel.fromJson(json))
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

  Future<ApiResponse> handleCashPayment(String transactionId,String action, empId) async {
    print("trans_id: $transactionId");
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.CASH_PAYMENT_UPDATE,
        data: {
          'transaction_id': transactionId,
          'status': action,
          'emp_id': empId,
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