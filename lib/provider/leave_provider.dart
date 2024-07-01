
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
    _resetState();
    showLoading();

    try{
      await _checkDuplicateLeave(leaveData);
      if(_isDuplicateLeave) return;

      await _checkSingleOccasionLeave(leaveData);
      if(_isSingleOccasionLeave) return;

      await _checkProbationStatus(leaveData);
      if(_isProbationPeriodEnd) return;

      await _submitLeaveApplication(leaveData);
    }catch(e){
      _error = "An error occurred: ${e.toString()}";
    }finally{
      hideLoading();
      notifyListeners();
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

  Future<void> _checkDuplicateLeave(LeaveData leaveData) async {
    final response = await leaveRepo.checkDuplicateLeave(leaveData.empNumber, leaveData.startDate);
    Map<String, dynamic> data = jsonDecode(response.response.toString());
    _isDuplicateLeave = data['isDuplicate'];
  }

  Future<void> _checkSingleOccasionLeave(LeaveData leaveData) async {
    if (!['Attendance Leave', 'Late Leave'].contains(leaveData.leaveType)) {
      final response = await leaveRepo.checkSingleOccasionLeave(
          leaveData.empNumber, leaveData.leaveType, leaveData.startDate);
      Map<String, dynamic> data = jsonDecode(response.response.toString());
      _isSingleOccasionLeave = data['isSingleOccasion'];
    }
  }

  Future<void> _checkProbationStatus(LeaveData leaveData) async {
    if (leaveData.leaveType == "Casual Leave") {
      final response = await leaveRepo.checkProbationStatus(leaveData.empNumber, leaveData.startDate);
      Map<String, dynamic> data = jsonDecode(response.response.toString());
      _isProbationPeriodEnd = data['isProbationEnd'];
    }
  }

  Future<void> _submitLeaveApplication(LeaveData leaveData) async {
    final response = await leaveRepo.applyLeave(leaveData);
    if (response.response != null && response.response?.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.response.toString());
      if (responseData['success'] == 1) {
        _isSuccess = responseData['msg'][0];
      } else {
        _error = "Leave application failed";
      }
    } else {
      _error = "Server error occurred";
    }
  }

  void _resetState() {
    _error = null;
    _isSuccess = null;
    _isDuplicateLeave = false;
    _isSingleOccasionLeave = false;
    _isProbationPeriodEnd = false;
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