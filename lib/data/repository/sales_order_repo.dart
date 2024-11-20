import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

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

}
