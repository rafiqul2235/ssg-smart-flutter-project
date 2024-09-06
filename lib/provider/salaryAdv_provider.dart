import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/SalaryEligibleInfo.dart';
import 'package:ssg_smart2/data/repository/salaryAdv_repo.dart';

class SalaryAdvProvider with ChangeNotifier{
  final SalaryAdvRepo salaryAdvRepo;
  SalaryEligibleInfo? salaryEligibleInfo;
  Map<String, dynamic>? salaryLoanData;
  bool isLoading = false;
  String error = '';

  SalaryAdvProvider({
    required this.salaryAdvRepo
});

  Future<void> getSalaryInfo(String empId) async {
    try{
      setLoading(true);
      salaryEligibleInfo = await salaryAdvRepo.fetchSalaryInfo(empId);
      setLoading(false);
    }catch(e) {
      setLoading(false);
      error = e.toString();
    }
  }

  Future<void> getSalaryLoanInfo(String empId) async {
    try{
      setLoading(true);
      salaryLoanData = await salaryAdvRepo.fetchSalLoanInfo(empId);
      setLoading(false);
    }catch(e) {
      setLoading(false);
      error = e.toString();
    }
  }

  void setLoading(bool value){
    isLoading = value;
    notifyListeners();
  }
}

