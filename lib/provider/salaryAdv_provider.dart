import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/body/salary_data.dart';
import 'package:ssg_smart2/data/model/response/SalaryEligibleInfo.dart';
import 'package:ssg_smart2/data/repository/salaryAdv_repo.dart';

class SalaryAdvProvider with ChangeNotifier{
  final SalaryAdvRepo salaryAdvRepo;
  SalaryEligibleInfo? salaryEligibleInfo;
  SalaryAdvanceData? _data;
  Map<String, dynamic>? salaryLoanData;
  bool isLoading = false;
  String error = '';

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  SalaryAdvanceData? get data => _data;

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

  Future<void> submitData(SalaryAdvanceData salaryAdvData) async {
    try{
      _isSubmitting = true;
      notifyListeners();
      await salaryAdvRepo.submitData(salaryAdvData);
      // await getSalaryInfo(salaryAdvData.empId);
      // await getSalaryLoanInfo(salaryAdvData.empId);
    }catch(e) {
      error = e.toString();
    }finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void setLoading(bool value){
    isLoading = value;
    notifyListeners();
  }
}

