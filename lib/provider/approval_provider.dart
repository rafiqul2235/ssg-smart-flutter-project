import 'package:flutter/widgets.dart';
import 'package:ssg_smart2/data/repository/approval_repo.dart';

import '../data/model/response/approval_flow.dart';

class ApprovalProvider with ChangeNotifier{
  final ApprovalRepo approvalRepo;
  List<ApprovalFlow> _approvalFlows = [];
  bool _isLoading = false;
  String _error = '';

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
}