import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';
import 'package:ssg_smart2/data/model/response/rsm_approval_flow_model.dart';

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

  Future<List<RsmApprovalFlowModel>> fetchRsmApprovalData(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.RSM_APPROVAL_FLOW_LIST,
        data: {
          'emp_id': empId,
        },
      );
      print("Rsm Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("rsm data: $responseData");
        if (responseData['success'] == 1 && responseData['approval_flow'] != null) {
          return (responseData['approval_flow'] as List)
              .map((json) => RsmApprovalFlowModel.fromJson(json))
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

 /* Future<List<CashPaymentModel>> fetchCashPaymentHistory(String empId) async {
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
  }*/


  Future<ApiResponse> fetchCashPaymentHistory(String empId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['emp_id'] = empId;
      Response response = await dioClient.postWithFormData(
        AppConstants.CASH_PAYMENT_HISTORY,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('pfData ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
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

  Future<ApiResponse> handleSoBookedRepo(String salesOrderId,String status,String commet,String lastUpdatedBy,String messageAtt3) async {
    //print("trans_id: $transactionId");
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.SOBOKKED_APPROVAL_UPDATE,
        data: {
          'salesorder_id': salesOrderId,
          'status': status,
          'commet': commet,
          'last_updated_by': lastUpdatedBy,
          'message_att3': messageAtt3
        },
      );
      print("Response: $response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Exception :  ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}