import 'package:flutter/foundation.dart';
import 'package:ssg_smart2/data/model/body/mo_list.dart';
import 'package:ssg_smart2/data/model/body/move_order_details.dart';
import 'package:ssg_smart2/data/repository/mo_repo.dart';

class MoveOrderProvider with ChangeNotifier {
  final MoveOrderRepo moveOrderRepo;
  MoveOrderProvider({required this.moveOrderRepo});

  List<MoveOrderItem> _moList = [];
  List<MoveOrderDetails> _moDetails = [];

  bool _isLoading = false;
  String? _isSuccess;
  String? _error = '';

  List<MoveOrderItem> get moList => _moList;
  List<MoveOrderDetails> get moDetails => _moDetails;
  bool get isLoading => _isLoading;
  String? get isSuccess => _isSuccess;
  String? get error => _error;

  Future<void> fetchMoList(String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print("Before calling : $empId");
      _moList = await moveOrderRepo.fetchMoveOrderList(empId);
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
      _moDetails = await moveOrderRepo.fetchMoveOrderDetails(orgId, moNo);
      print("Mo list: $_moDetails}");
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }
}