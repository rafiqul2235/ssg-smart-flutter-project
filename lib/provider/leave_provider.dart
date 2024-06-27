
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/leave_data.dart';
import '../data/model/dropdown_model.dart';
import '../data/model/response/base/api_response.dart';
import '../data/model/response/leave_balance.dart';
import '../data/repository/leave_repo.dart';
import '../helper/api_checker.dart';
import 'auth_provider.dart';

class LeaveProvider with ChangeNotifier {

  final LeaveRepo leaveRepo;
  LeaveProvider({required this.leaveRepo});

  LeaveBalance? _leaveBalance;
  LeaveBalance get leaveBalance => _leaveBalance??LeaveBalance(casual: 0,compensatory: 0,earned: 0.0,sick: 0);

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

  Future<void> applyLeave(BuildContext context, LeaveData leaveData) async {
    // showLoading();
    // Check duplicate leave
    final duplicateResponse = await leaveRepo.checkDuplicateLeave(
        leaveData.empNumber, leaveData.startDate);
    Map<String, dynamic> duplicateData = jsonDecode(duplicateResponse.response.toString());
    _isDuplicateLeave = duplicateData['isDuplicate'];

    // Check single occasion leave
    if (!['Attendance Leave', 'Late Leave'].contains(leaveData.leaveType)) {
      final occationLeaveResponse = await leaveRepo.checkSingleOccasionLeave(
          leaveData.empNumber, leaveData.leaveType, leaveData.startDate);
      Map<String, dynamic> occationLeaveData = jsonDecode(occationLeaveResponse.response.toString());
      _isSingleOccasionLeave = occationLeaveData['isSingleOccasion'];
    } else {
      _isSingleOccasionLeave = false;
    }

    // Check probation status
    if (leaveData.leaveType == "Casual Leave") {
      final probationResponse = await leaveRepo.checkProbationStatus(
          leaveData.empNumber, leaveData.startDate);
      Map<String, dynamic> probationStatusData = jsonDecode(probationResponse.response.toString());
      _isProbationPeriodEnd = probationStatusData['isProbationEnd'];
    } else {
      _isProbationPeriodEnd = false;
    }

    if (!_isDuplicateLeave &&
        !_isSingleOccasionLeave &&
        !_isProbationPeriodEnd) {
      try {
        showLoading();
        final response = await leaveRepo.applyLeave(leaveData);
        if( response.response != null && response.response?.statusCode == 200){
          Map<String, dynamic> responseData = jsonDecode(response.response.toString());
          if( responseData['success'] == 1){
            _isSuccess = responseData['msg'][0];
            hideLoading();
          }
        }
      } catch (e) {
        print("Errorm message from e: $e");
        _error = e.toString();
      } finally {
        hideLoading();
      }
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