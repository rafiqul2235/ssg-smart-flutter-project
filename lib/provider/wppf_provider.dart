import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/repository/wppf_repo.dart';

import '../data/model/response/WppfLedger.dart';

class WppfProvider with ChangeNotifier {
  final WppfRepo wppfRepo;
  List<WppfLedger> _wppfLedgers = [];
  bool _isLoading = false;
  String _error = '';

  WppfProvider({
    required this.wppfRepo
  });

  List<WppfLedger> get wppfLedgers => _wppfLedgers;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchWppfLedger(String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _wppfLedgers = await wppfRepo.fetchWppfLedger(empId);
      print("Result: ${_wppfLedgers}");
    } catch (e) {
      print("Error: ${e.toString()}");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}