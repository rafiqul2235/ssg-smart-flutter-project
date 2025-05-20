import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:ssg_smart2/view/screen/msd_report/balance_confirmation_model.dart';
import 'package:ssg_smart2/view/screen/msd_report/cust_target_vsAchiv_model.dart';
import 'package:ssg_smart2/view/screen/msd_report/delivery_info_model.dart';
import 'package:ssg_smart2/view/screen/msd_report/item_wise_pending_model.dart';
import 'package:ssg_smart2/view/screen/msd_report/msd_report_model.dart';
import 'package:ssg_smart2/view/screen/msd_report/notification_summary_model.dart';
import 'package:ssg_smart2/view/screen/msd_report/sales_summary_model.dart';

import '../../view/screen/salesOrder/sales_data_model.dart';
import '../model/body/collection.dart';
import '../model/body/sales_order.dart';

class SalesOrderRepo {

  final DioClient dioClient;

  SalesOrderRepo({required this.dioClient});

  Future<ApiResponse> getCustomerAndItemListAndOthers(String orgId, String salesPersonId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['org_id'] = orgId;
      data['salesrep_id'] = salesPersonId;

      final response = await dioClient.postWithFormData(
          AppConstants.SALES,
          data:data
      );
     print("Respons for sales; $response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> geCustBalance(String orgId, String customerId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['org_id'] = orgId;
      data['customer_id'] = customerId;
      Response response = await dioClient.postWithFormData(
        AppConstants.Customer_BALANCE,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('customer balance ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getItemPriceRep(String orgId, String account_id, String site_id,String item_id,String freght) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['org_id'] = orgId;
      data['account_id'] = account_id;
      data['site_id'] = site_id;
      data['item_id'] = item_id;
      data['freght'] = freght;
      Response response = await dioClient.postWithFormData(
        AppConstants.Item_PRICE,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Item price ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAvailCustBalance(String orgId, String customerId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['org_id'] = orgId;
      data['customer_id'] = customerId;
      Response response = await dioClient.postWithFormData(
        AppConstants.AVAIL_Cust_BAL,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Available customer balance ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getItemRep(String warehouseId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['warehouse_id'] = warehouseId;
      Response response = await dioClient.postWithFormData(
        AppConstants.ITEM,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('item name ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerShipToLocation(String orgId, String salesPersonId, String customerId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['org_id'] = orgId;
      data['salesrep_id'] = salesPersonId;
      data['customer_id'] = customerId;
      //data['customer_id'] = 2491;

      final response = await dioClient.postWithFormData(
          AppConstants.ORDERS,
          data:data
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPendingSoRep(String salesPersonId, String customerId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['salerep_id'] = salesPersonId;
      data['customer_id'] = customerId;

      final response = await dioClient.postWithFormData(
          AppConstants.PENDINGSO,
          data:data
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSPCustListRep(String salesPersonId, String org_id) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salesrep_id'] = salesPersonId;
    data['org_id'] = org_id;
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.SP_CUST_LIST,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('custList ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getTripNumberSrRep(String salesPersonId, String org_id) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salesrep_id'] = salesPersonId;
    data['org_id'] = org_id;
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.SP_TRIP_NUMBER,
        data:data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('tripNum ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> salesOrderSubmitRep (SalesOrder salesData) async {
    try {
      Response response = await dioClient.post(
        AppConstants.NEW_SALE_SUBMIT,
        data:salesData.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> salesOrderBookedSubmitRep (SalesOrder salesData) async {
    try {
      Response response = await dioClient.post(
        AppConstants.NEW_SALE_BOOKED_SUBMIT,
        data:salesData.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deliveryRequestSubmitRep (SalesOrder salesData) async {
    try {
      Response response = await dioClient.post(
        AppConstants.DELIVERY_RREQUEST_SUBMIT,
        data:salesData.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<List<MsdReportModel>> fetchSalesNotificationData(String salesrep_id,String cust_id, String fromDate, String toDate, String type) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.MSD_REPORT_DATA,
        data: {
          'type': type,
          'salesrep_id': salesrep_id,
          'cust_id': cust_id,
          'fromDate': fromDate,
          'toDate': toDate
        },
      );
      print("Notification $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("notification data: $responseData");
        if (responseData['success'] == 1 && responseData['messages'] != null) {
          return (responseData['messages'] as List)
              .map((json) => MsdReportModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<MsdReportModel>> fetchSalesNotifiSupervisorData(String user_name,String salesrep_id,String cust_id, String fromDate, String toDate, String type) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.MSD_REPORT_SUPERVISOR_DATA,
        data: {
          'user_name':user_name,
          'type': type,
          'salesrep_id': salesrep_id,
          'cust_id': cust_id,
          'fromDate': fromDate,
          'toDate': toDate
        },
      );
      print("NotificationS $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("notificationS data: $responseData");
        if (responseData['success'] == 1 && responseData['messages'] != null) {
          return (responseData['messages'] as List)
              .map((json) => MsdReportModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<NotificationSummaryModel> fetchSalesNotiSummaryRep(String salesrep_id,String cust_id, String fromDate, String toDate, String type) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.NOTIFICATION_SUMMARY,
        data: {
          'type': type,
          'salesrep_id': salesrep_id,
          'cust_id': cust_id,
          'fromDate': fromDate,
          'toDate': toDate
        },
      );
      print("Notif summary $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("noti summary: $responseData");
        if (responseData['success'] == 1 && responseData['messages'] != null) {
          final summaryModel = NotificationSummaryModel.fromJson(responseData['messages'][0]);
          print('summary(repo):${responseData['messages'][0]}');
          return summaryModel;
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<SalesSummaryModel>> fetchSalesSummaryRep(String salesrepId,String custId, String fromDate, String toDate) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.SALES_SUMMARY_DATA,
        data: {
          'salesrep_id': salesrepId,
          'cust_id': custId,
          'from_date': fromDate,
          'to_date': toDate,

        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 &&
            responseData['get_summary_report'] != null) {
          return (responseData['get_summary_report'] as List)
              .map((json) => SalesSummaryModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<ItemWisePendingModel>> fetchItemWisePendingRep(String salesrepId,String custId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.ITEM_WISE_PENDING_DATA,
        data: {
          'salerep_id': salesrepId,
          'customer_id': custId,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 &&
            responseData['pending_so'] != null) {
          return (responseData['pending_so'] as List)
              .map((json) => ItemWisePendingModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<CustTargetVsAchivModel>> fetchCustTargetVsAchivRep(String orgId,String period, String custAc) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.CUST_TARGET_VS_ACHIV_DATA,
        data: {
          'org_id': orgId,
          'period': period,
          'cus_no': custAc,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 &&
            responseData['cust_target'] != null) {
          return (responseData['cust_target'] as List)
              .map((json) => CustTargetVsAchivModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<BalanceConfirmationModel>> fetchBalanceConfirmationRep(String salesrepId,String custId,fromMonth,toMonth) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.BALANCE_CONFIRMATION_DATA,
        data: {
          'emp_id': salesrepId,
          'customer_id': custId,
          'fromDate': fromMonth,
          'toDate': toMonth
        },
      );
      print("balance confirmation response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 &&
            responseData['cust_balance_con'] != null) {
          return (responseData['cust_balance_con'] as List)
              .map((json) => BalanceConfirmationModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<DeliveryInfoModel>> fetchDlvInfoRep(String salesrep_id,String trip_number) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.DLV_INFO_DATA,
        data: {
          'salerep_id': salesrep_id,
          'trip_number': trip_number
        },
      );
      print("dlv_info $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("dlv_info data: $responseData");
        if (responseData['success'] == 1 && responseData['pending_so'] != null) {
          return (responseData['pending_so'] as List)
              .map((json) => DeliveryInfoModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<MsdReportModel>> fetchMsdReportRep(String salesrep_id,String cust_id, String fromDate, String toDate, String type) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.MSD_REPORT_DATA,
        data: {
          'type': type,
          'salesrep_id': salesrep_id,
          'cust_id': cust_id,
          'fromDate': fromDate,
          'toDate': toDate
        },
      );
      print("msdSales response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 &&
            responseData['messages'] != null) {
          return (responseData['messages'] as List)
              .map((json) => MsdReportModel.fromJson(json))
              .toList();
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('No data found');
      }
    } catch (e) {
      throw Exception('Error fetching: $e');
    }
  }

  Future<ApiResponse> getCollectionInformation(String orgId, String salesPersonId) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['org_id'] = orgId;
      data['salesrep_id'] = salesPersonId;

      final response = await dioClient.postWithFormData(
          AppConstants.COLLECTION,
          data:data
      );
      print("Respons for collection ; $response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> collectionSubmission (Collection collection) async {
    try {
      Response response = await dioClient.post(
        AppConstants.NEW_COLLECTION_SUBMIT,
        data:collection.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
