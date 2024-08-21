import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class BrandRepo {
  final DioClient dioClient;
  BrandRepo({required this.dioClient});

  Future<ApiResponse> getBrandList(String languageCode) async {

    try {
      final response = await dioClient.get('AppConstants.BRANDS_URI',
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}