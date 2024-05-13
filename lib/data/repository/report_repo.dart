import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';

class ReportRepo {

  final DioClient dioClient;
  ReportRepo({required this.dioClient});

  Future<ApiResponse> getDashboardSummaryReport(String assigneeCode, String fromDate, String endDate) async {
    try {
      final response = await dioClient.get('AppConstants.GET_DASHBOARD_SUMMARY_REPORT'+assigneeCode+'&fromDate='+fromDate+'&toDate='+endDate);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getReportSummary(String assigneeCode, String fromDate, String endDate) async {
    try {
      final response = await dioClient.get('AppConstants.GET_REPORT_SUMMARY'+assigneeCode+'&fromDate='+fromDate+'&toDate='+endDate);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getStockReport(String serial) async {
    try {
      final response = await dioClient.get('AppConstants.GET_STOCK_REPORT_LIST_URL'+serial);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getStockReportWithPagination(int pageNo,int pageSize,String serial,String custBizCode) async {
    try {
      final response = await dioClient.get('AppConstants.GET_STOCK_REPORT_LIST_WITH_PAGINATION_URL'+'$pageNo&pageSize=$pageSize&filterKey=Serial&filterValue=$serial&custBizCode=$custBizCode');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSalesReport() async {
    try {
      final response = await dioClient.get('AppConstants.GET_SALES_REPORT_LIST_URL');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSalesReportWithPagination(int pageNo, int pageSize,String custBizCode, String fromDate, String toDate) async {
    try {
      final response = await dioClient.get('AppConstants.GET_SALES_REPORT_LIST_WITH_PAGINATION_URL'+'$pageNo&pageSize=$pageSize&filterKey=&filterValue&custBizCode=$custBizCode&fromDate=$fromDate&toDate=$toDate');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWarrantyReport(String serialNo) async {
    try {
      final response = await dioClient.get('AppConstants.GET_WARRANTY_REPORT_URL'+serialNo);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPDFReports() async {
    try {
      final response = await dioClient.get('AppConstants.GET_PDF_REPORTS');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
