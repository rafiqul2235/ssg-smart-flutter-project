
import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/leave_data.dart';
import '../data/model/dropdown_model.dart';
import '../data/model/response/approval_list_model.dart';
import '../data/model/response/attendance_sheet_model.dart';
import '../data/model/response/base/api_response.dart';
import '../data/model/response/leave_balance.dart';
import '../data/model/response/management_dashboard_model.dart';
import '../data/model/response/pf_ledger_model.dart';
import '../data/repository/leave_repo.dart';
import '../helper/api_checker.dart';
import 'auth_provider.dart';

class LeaveProvider with ChangeNotifier {

  final LeaveRepo leaveRepo;
  LeaveProvider({required this.leaveRepo});

  LeaveBalance? _leaveBalance;
  LeaveBalance get leaveBalance => _leaveBalance??LeaveBalance(casual: 0,compensatory: 0,earned: 0.0,sick: 0);

  ManagementDashboardModel? _dashboardModel;
  ManagementDashboardModel get dashboardModel => _dashboardModel??ManagementDashboardModel(scbl_call: 0,sscml_call: 0,sscil_call: 0);

  PfLedgerModel? _pfLedgerModel;
  PfLedgerModel get pfLedgerModel => _pfLedgerModel??PfLedgerModel(period_name: '',con_prof_total: 0,net_total: 0);

  List<DropDownModel> _leaveTypes = [] ;
  List<DropDownModel> get leaveTypes => _leaveTypes??[] ;
  String? _error;
  String? get error => _error;

  String? _isSuccess;
  String? get isSuccess => _isSuccess;

  bool _loading = false;
  bool get loading => _loading;

  bool _isDuplicateLeave = false;
  bool get isDuplicateLeave => _isDuplicateLeave;

  bool _isSingleOccasionLeave = false;
  bool get isSingleOccasionLeave => _isSingleOccasionLeave;

  bool _isProbationPeriodEnd = false;
  bool get isProbationPeriodEnd => _isProbationPeriodEnd;

  Future<String?> applyLeave(BuildContext context, LeaveData leaveData) async {
    showLoading();
    try {
      //check duplicate leave
      final duplicateResponse = await leaveRepo.checkDuplicateLeave(leaveData.empNumber, leaveData.startDate);
      Map<String, dynamic> duplicateData = jsonDecode(duplicateResponse.response.toString());
      _isDuplicateLeave = duplicateData['isDuplicate'];
      print("Duplicate leave: $_isDuplicateLeave");
      
      if (!_isDuplicateLeave) {
        final response = await leaveRepo.applyLeave(leaveData);
        if (response.response != null && response.response?.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.response.toString());
          print("Response data: $responseData");
          if (responseData['success'] == 1) {
            return responseData['msg'][0];
          } else {
            return responseData['msg'][0];
          }
        } else {
          return null;
        }
      }else{
        _error = "Duplicate leave";
        return _error;
      }
    } catch (e) {
      return null;
    } finally {
      hideLoading();
    }
  }

  Future<LeaveBalance?> getLeaveBalance(BuildContext context) async {

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
    String empName =  Provider.of<AuthProvider>(context, listen: false).getUserName();
    ApiResponse apiResponse = await leaveRepo.getLeaveBalance(empId);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _leaveBalance = LeaveBalance.fromJson(apiResponse.response?.data['leave_balance'][0]);

      return _leaveBalance;

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }

    return LeaveBalance(casual: 0,compensatory: 0,earned: 0.0,sick: 0);

  }

  Future<ManagementDashboardModel?> getManageDashbData(BuildContext context) async {

    //String soures =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
    ApiResponse apiResponse = await leaveRepo.getManagementData("Yearly");

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _dashboardModel = ManagementDashboardModel.fromJson(apiResponse.response?.data['cust_master_data'][0]);

      return _dashboardModel;

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }

    return ManagementDashboardModel(scbl_call: 0,sscml_call: 0,sscil_call: 0);

  }

  Future<List<PfLedgerModel>> getPfLedgerData(BuildContext context) async {

    List<PfLedgerModel> _list = [];

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
    ApiResponse apiResponse = await leaveRepo.getPfData(empId,"901");
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _list = [];
      apiResponse.response?.data['service_list'].forEach((item) => _list.add(PfLedgerModel.fromJson(item)));

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
    return _list;

  }

  Future<List<AttendanceSheetModel>> getAttendanceData(BuildContext context,String startDate,String endDate,String attendanceType) async {

    List<AttendanceSheetModel> _list = [];

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
    ApiResponse apiResponse = await leaveRepo.getAttendData(empId,startDate,endDate,'');
    //ApiResponse apiResponse = await leaveRepo.getAttendData(empId,'2023-05-01','2023-05-30','');
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _list = [];
      apiResponse.response?.data['attendance_sheet'].forEach((item) => _list.add(AttendanceSheetModel.fromJson(item)));

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
    return _list;

  }



  /*Future<void> getApprovalListData(BuildContext context) async {

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();

    ApiResponse apiResponse = await leaveRepo.getApprovalList(empId);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _applicationList = [];
      apiResponse.response?.data['approval_flow'].forEach((application) => _applicationList.add(ApprovalListModel.fromJson(application)));

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
*/

  Future<void> getLeaveType(BuildContext context) async {

    ApiResponse apiResponse = await leaveRepo.getLeaveType();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _leaveTypes = [];
      apiResponse.response?.data['leave_type'].forEach((leaveType) => _leaveTypes.add(DropDownModel.fromJsonForLeaveType(leaveType)));
      notifyListeners();
    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void showLoading(){
    if(!_loading){
      _loading = true;
      notifyListeners();
    }
  }
  void hideLoading(){
    if(_loading){
      _loading = false;
      notifyListeners();
    }
  }

}