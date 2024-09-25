import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/body/pf_installment.dart';
import 'package:ssg_smart2/data/model/body/salary_data.dart';
import 'package:ssg_smart2/data/model/response/SalaryEligibleInfo.dart';
import 'package:ssg_smart2/data/model/response/pf_eligible.dart';
import 'package:ssg_smart2/data/repository/pfloan_repo.dart';
import 'package:ssg_smart2/data/repository/salaryAdv_repo.dart';

class PfLoanProvider with ChangeNotifier{
  final PfLoanRepo pfLoanRepo;
  PfEligibleInfo? pfEligibleInfo;
  SalaryAdvanceData? _data;
  Map<String, dynamic>? pfLoanData;
  List<PfInstallment> _installment = [];
  bool isLoading = false;
  String error = '';

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  List<PfInstallment> get installment => _installment;

  SalaryAdvanceData? get data => _data;

  PfLoanProvider({
    required this.pfLoanRepo
});

  Future<void> getPfEligibilityInfo(String empId) async {
    try{
      setLoading(true);
      pfEligibleInfo = await pfLoanRepo.fetchPfEligibilityInfo(empId);
      setLoading(false);
    }catch(e) {
      setLoading(false);
      error = e.toString();
    }
  }

  Future<void> getPfLoanInfo(String empId) async {
    try{
      setLoading(true);
      pfLoanData = await pfLoanRepo.fetchPfLoanInfo(empId);
      setLoading(false);
    }catch(e) {
      setLoading(false);
      error = e.toString();
    }
  }

  Future<void> getPfInstallment() async {
    try{
      setLoading(true);
      _installment = await pfLoanRepo.fetchPfInstallment();
      setLoading(false);
    }catch (e) {
      setLoading(false);
      error = e.toString();
    }
  }

  // Future<void> submitData(SalaryAdvanceData salaryAdvData) async {
  //   try{
  //     _isSubmitting = true;
  //     notifyListeners();
  //     await salaryAdvRepo.submitData(salaryAdvData);
  //     // await getSalaryInfo(salaryAdvData.empId);
  //     // await getSalaryLoanInfo(salaryAdvData.empId);
  //   }catch(e) {
  //     error = e.toString();
  //   }finally {
  //     _isSubmitting = false;
  //     notifyListeners();
  //   }
  // }

  void setLoading(bool value){
    isLoading = value;
    notifyListeners();
  }
}

