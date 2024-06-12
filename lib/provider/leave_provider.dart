
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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


  Future<void> applyLeave(BuildContext context, String leaveTypeId, String startDate, String endDate, String duration, String comments) async {


    print('Leve provider applyLeave');
    print("leave type: $leaveTypeId startdate: $startDate, end date: $endDate , duration: $duration and comment:$comments");



    /*String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();

    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_id'] = empId;
    data['leave_type'] = empId;

    ApiResponse apiResponse = await leaveRepo.applyLeave(data);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {


    }else{
      ApiChecker.checkApi(context, apiResponse);
    }*/

  }

  Future<LeaveBalance?> getLeaveBalance(BuildContext context) async {

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
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

}