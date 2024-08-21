import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/model/response/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription;
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription =
              "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response?.statusCode) {
                case 400:
                  //errorDescription = "No Record Found!";
                  //errorDescription = error.response?.data?['detail'];
                  errorDescription = error.response!.data.toString();
                  break;
                case 401:
                  errorDescription = "Unauthorized User";
                  break;
                case 404:
                case 403:
                  //errorDescription = error.response?.data?['detail'];
                  //errorDescription = error.response!.statusMessage;
                  errorDescription = error.response!.data.toString();
                  break;
                case 500:
                  //errorDescription = error.response.data['detail'];
                  errorDescription = error.response!.data.toString();
                  //errorDescription = error.response!.statusMessage;
                  break;
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  ErrorResponse errorResponse =
                  ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.errors.isNotEmpty) {
                    errorDescription = errorResponse;
                  }
                  else {
                    errorDescription =
                    "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;

            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Connection Error";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
