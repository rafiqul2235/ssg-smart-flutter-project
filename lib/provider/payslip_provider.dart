import 'package:flutter/widgets.dart';
import 'package:ssg_smart2/data/repository/payslip_repo.dart';

import '../data/model/response/payslip_model.dart';

class PaySlipProvider with ChangeNotifier {
  final PaySlipRepo paySlipRepo;
  EmployeePaySlip? _employeePaySlip;
  bool _isLoading = false;
  String _error = '';

  PaySlipProvider({required this.paySlipRepo});

  EmployeePaySlip? get employeePaySlip => _employeePaySlip;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadEmployeePaySlip(String empId) async{
    _isLoading = true;
    notifyListeners();
    try{
      _employeePaySlip = await paySlipRepo.fetchEmployeePaySlip(empId);
      _error = '';
    }catch(e){
      _employeePaySlip = null;
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

}
