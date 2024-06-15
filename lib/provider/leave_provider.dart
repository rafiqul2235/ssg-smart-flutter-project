
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/management_dashboard_model.dart';
import 'package:ssg_smart2/data/model/response/pf_ledger_model.dart';
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

  ManagementDashboardModel? _dashboardModel;
  ManagementDashboardModel get dashboardModel => _dashboardModel??ManagementDashboardModel(scbl_call_mon: 0,sscml_call_mon: 0,sscil_call_mon: 0);

 /* PfLedgerModel? _pfLedgerModel;
  PfLedgerModel get pfLedgerModel => _pfLedgerModel??PfLedgerModel(period_name: '',con_prof_total: 0,net_total: 0);
*/

  List<DropDownModel> _leaveTypes = [] ;
  List<DropDownModel> get leaveTypes => _leaveTypes??[] ;


  Future<void> applyLeave(BuildContext context, String leaveTypeId, String startDate, String endDate, String duration, String comments) async {


    print('Leve provider applyLeave');
    



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

  Future<ManagementDashboardModel?> getManageDashbData(BuildContext context) async {

    //String soures =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
    ApiResponse apiResponse = await leaveRepo.getManagementData("Monthly");

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _dashboardModel = ManagementDashboardModel.fromJson(apiResponse.response?.data['cust_master_data'][0]);

      return _dashboardModel;

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }

    return ManagementDashboardModel(scbl_call_mon: 0,sscml_call_mon: 0,sscil_call_mon: 0);

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