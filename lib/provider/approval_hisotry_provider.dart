import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/repository/approval_history_repo.dart';

import '../data/model/response/leaveapproval/leave_approval_history.dart';

class ApprovalHistoryProvider with ChangeNotifier{
  final ApprovalHistoryRepo approvalHistoryRepo;
  LeaveApprovalHistory? _leaveApprovalHistory;
  bool _isLoading = false;
  String? _error;

  ApprovalHistoryProvider({
    required this.approvalHistoryRepo
});
  LeaveApprovalHistory? get leaveApprovalHistory => _leaveApprovalHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLeaveApprovalHistory(String invoiceId) async{
    _isLoading = true;
    _error = null;
    notifyListeners();
    try{
      _leaveApprovalHistory = await approvalHistoryRepo.getLeaveApprovalHistory(invoiceId);
      print("leave approver history from provider: $_leaveApprovalHistory");
    }catch(e){
      _error = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

}