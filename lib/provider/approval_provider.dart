import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:ssg_smart2/data/repository/approval_repo.dart';

import '../data/model/response/approval_flow.dart';

class ApprovalProvider with ChangeNotifier{
  final ApprovalRepo approvalRepo;
  List<ApprovalFlow> _approvalFlows = [];

  bool _isLoading = false;
  String _error = '';
  String? _isSuccess;
  String? get isSuccess => _isSuccess;

  ApprovalProvider({required this.approvalRepo});

  List<ApprovalFlow> get approvalFlows => _approvalFlows;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchApprovalFlow(String empId) async{
    _isLoading = true;
    _error = '';
    notifyListeners();

    try{
      _approvalFlows = await approvalRepo.fetchApprovalFlow(empId);
      print("Approval flow from provider: $_approvalFlows");
    }catch(e){
      _error = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleApproval(BuildContext context, String notificationId, String action, String comments) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await approvalRepo.handleApproval(notificationId, action, comments);
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
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}