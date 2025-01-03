import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

import '../../view/screen/salesOrder/sales_data_model.dart';
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

      final response = await dioClient.postWithFormData(
          AppConstants.ORDERS,
          data:data
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
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

}
