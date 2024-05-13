import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class NotificationRepo {

  final DioClient dioClient;
  NotificationRepo({required this.dioClient});

  Future<ApiResponse> getNotificationList(int pageNo, int pageSize) async {
    try {
      Response response = await dioClient.get('AppConstants.NOTIFICATION_URI'+'$pageNo&pageSize=$pageSize&filterKey=Serial&filterValue=&custBizCode=&fromDate&toDate');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> changeMessageFlag(int messageId) async {
    try {
      Response response = await dioClient.post('AppConstants.NOTIFICATION_CHANGE_MSG_FLAG_URI'+'$messageId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}