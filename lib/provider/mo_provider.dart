import 'package:flutter/foundation.dart';
import 'package:ssg_smart2/data/model/body/approver.dart';
import 'package:ssg_smart2/data/model/body/mo_list.dart';
import 'package:ssg_smart2/data/model/body/move_order_details.dart';
import 'package:ssg_smart2/data/model/response/moveOrderResponse.dart';
import 'package:ssg_smart2/data/repository/mo_repo.dart';

class MoveOrderProvider with ChangeNotifier {
  final MoveOrderRepo moveOrderRepo;
  MoveOrderProvider({required this.moveOrderRepo});

  List<MoveOrderItem> _moList = [];
  List<MoveOrderDetails> _moDetails = [];
  MoveOrderResponse? _moResponse;
  List<ApproverDetail> _approverList = [];

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _error = '';

  List<MoveOrderItem> get moList => _moList;
  List<MoveOrderDetails> get moDetails => _moDetails;
  MoveOrderResponse? get moResponse => _moResponse;
  List<ApproverDetail> get approverList => _approverList;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get error => _error;

  Future<void> fetchMoList(String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _moList = await moveOrderRepo.fetchMoveOrderList(empId);
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<void> fetchApproverMoList(String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _moList = await moveOrderRepo.fetchApproverMoveOrderList(empId);
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<void> fetchMoDetails(String orgId, String moNo) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _moResponse = await moveOrderRepo.fetchMoveOrderDetails(orgId, moNo);
      _moDetails = _moResponse!.moveOrderDetails;
      _approverList = _moResponse!.approverList!;
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitMoveOrder(String headerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await moveOrderRepo.submitMoveOrder(headerId);
      _isSuccess = result['success'] == 1;
      _error = result['msg'] ?? 'Unknown response';
    }catch(e){
      _isSuccess = false;
      _error = 'Submission failed: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleMoveOrder(String applicationType, String notificationId, String action, String comment) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await moveOrderRepo.handleMoveOrder(applicationType, notificationId, action, comment);
      _isSuccess = result['success'].toString() == '1';
      _error = result['msg'].first.toString();
    }catch(e){
      _isSuccess = false;
      _error = 'Submission failed: ${e.toString()}';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

}