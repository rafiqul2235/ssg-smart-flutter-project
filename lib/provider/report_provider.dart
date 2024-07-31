import 'dart:async';
import 'package:ssg_smart2/data/model/response/dashboard_status_model.dart';
import 'package:ssg_smart2/data/model/response/api_pagination_response.dart';
import 'package:ssg_smart2/data/repository/report_repo.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import '../data/model/response/pdf_report_model.dart';
import '../data/model/response/summary_report_model.dart';
import '../helper/api_checker.dart';

class ReportProvider extends ChangeNotifier {

  final ReportRepo reportRepo;

  ReportProvider({required this.reportRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _groupTypeIndex = 0;
  int get groupTypeIndex => _groupTypeIndex;

  void resetLoading(){
    _isLoading = false;
  }

  void setIndex(int index) {
    _groupTypeIndex = index;
    notifyListeners();
  }

  List<SummaryReportModel> _reportSummaryList = [];
  List<SummaryReportModel> get reportSummaryList => _reportSummaryList ?? [];

  DashboardStatusModel? _dashboardStatusModel;
  DashboardStatusModel get dashboardStatusModel => _dashboardStatusModel??DashboardStatusModel(code: '', name: '', planed: 0, visited: 0, prospectiveCustomer: 0, groups: [], actionLog: 0);

  List<PDFReportModel> _pdfReportLList = [];
  List<PDFReportModel> get pdfReportLList => _pdfReportLList ?? [];


  Future<void> getDashboardSummaryReport(BuildContext context, String assigneeCode, String fromDate, String endDate) async {
   // _isLoading = true;
   // notifyListeners();
    ApiResponse apiResponse = await reportRepo.getDashboardSummaryReport(assigneeCode, fromDate, endDate);
    //_isLoading = false;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _dashboardStatusModel = DashboardStatusModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getReportSummary(BuildContext context, String assigneeCode, String fromDate, String endDate) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await reportRepo.getReportSummary(assigneeCode, fromDate, endDate);
    Timer(const Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
    });
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _reportSummaryList = [];
      apiResponse.response?.data.forEach((json)=>_reportSummaryList.add(SummaryReportModel.fromJson(json)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<ApiPaginationResponse?> getSalesReportsWithPagination(int pageNo, int pageSize,String custBizCode, String fromDate, String toDate) async {
   // List<SalesModel> salesModels = [];
    ApiPaginationResponse? response;
    ApiResponse apiResponse = await reportRepo.getSalesReportWithPagination(pageNo,pageSize,custBizCode,fromDate,toDate);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      /*  apiResponse.response?.data.forEach((data) => items.add(InventoryItemModel.fromJsonSalesReport(data)));*/

      response = ApiPaginationResponse.fromJson(apiResponse.response?.data);

      /*for(Map<String, dynamic> json in apiResponse.response?.data) {
        bool matched = false;
        for(SalesModel salesModel in salesModels) {
          if(json['productCode'] == salesModel.productCode && json['consumerName'] == salesModel.consumerName && json['soldDate'] == salesModel.soldDate){
            matched = true;
            salesModel.addProduct(SalesItem.fromJson(json));
            break;
          }
        }
        if(!matched){
          salesModels.add(SalesModel.fromJson(json));
        }
      }*/
    }
    return response;
  }

  Future<void> getPDFReports(BuildContext context) async {
    ApiResponse apiResponse = await reportRepo.getPDFReports();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _pdfReportLList = [];
      apiResponse.response?.data.forEach((data) => _pdfReportLList.add(PDFReportModel.fromJson(data)));
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
   // notifyListeners();
  }

}
