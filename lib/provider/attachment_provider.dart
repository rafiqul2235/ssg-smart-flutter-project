import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/body/financial_year.dart';
import 'package:ssg_smart2/data/model/dropdown_model.dart';
import 'package:ssg_smart2/data/model/response/AitResponse.dart';
import 'package:ssg_smart2/data/model/response/ait_essential.dart';
import 'package:ssg_smart2/data/model/response/base/new_api_resonse.dart';
import 'package:ssg_smart2/data/model/ait_data.dart';

import '../data/model/body/ait_details.dart';
import '../data/model/body/approver.dart';
import '../data/repository/attachment_repo.dart';

class AttachmentProvider with ChangeNotifier {
  final AttachmentRepo attachmentRepo;
  bool _isLoading = false;
  String _error = '';

  ApiResonseNew? _aitResponse;
  List<AitData> _aitData = [];
  AitResponse? _response;

  List<CustomerDetails> _customerList = [];
  CustomerDetails? _selectedCustomer;
  List<FinancialYear> _finacialYearList = [];
  FinancialYear? _selectFinancialYear;

  AitDetail? _aitDetails;
  List<ApproverDetail> _approverList = [];

  AitDetail? get aitDetails => _aitDetails;
  List<ApproverDetail> get approverList => _approverList;

  AttachmentProvider({required this.attachmentRepo});
  bool get isLoading => _isLoading;
  String get error => _error;
  List<AitData> get aitData => _aitData;
  ApiResonseNew? get aitResponse => _aitResponse;
  AitResponse? get response => _response;

  List<CustomerDetails> get customersList => _customerList;
  CustomerDetails? get selectedCustomer => _selectedCustomer;
  List<FinancialYear> get financialYearsList => _finacialYearList;
  FinancialYear? get selectedFinancialYear => _selectFinancialYear;

  Future<void> submitAITAutomationForm(Map<String, dynamic> data) async {
    _setLoading(true);
    _setError('');
    try {
      final ApiResonseNew resonseNew = await attachmentRepo.submitAITAutomationForm(data);
      if (resonseNew.isSuccess) {
        _setResponse(resonseNew);
      }else{
        _setError(resonseNew.error?? "Unknown error");
      }
    }catch(e){
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }finally{
      _setLoading(false);
      _setError('');
    }
  }

  Future<void> updateAitEnty(String headerId, Map<String, dynamic> data) async {
    _setLoading(true);
    _setError('');
    try {
      final ApiResonseNew resonseNew = await attachmentRepo.updateAitEntry(headerId, data);
      if (resonseNew.isSuccess) {
        _setResponse(resonseNew);
      }else{
        _setError(resonseNew.error?? "Unknown error");
      }
    }catch(e){
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }finally{
      _setLoading(false);
      _setError('');
    }
  }


  Future<void> fetchAitEssentails(String orgId, String salesId) async{
    try {
      _setLoading(true);
      _setError('');
      final AitEssentialResponse aitEssential = await attachmentRepo.fetchAitEssential(orgId, salesId);
      _customerList = aitEssential.customerDetails;
      _finacialYearList = aitEssential.financialYears;
      _setLoading(false);
    }catch (e) {
      _setError(e.toString());
    }finally {
      _setLoading(false);
      _setError('');
    }
  }

  Future<void> fetchAitDetails(String headerId) async {
    try {
      _setLoading(true);
      _setError('');
      print("fetching ait details for headerId: $headerId");

      _response = await attachmentRepo.fetchAitDetails(headerId);
      print("ait response: $_response");
      _aitDetails = _response?.aitDetails;
      _approverList = _response?.approverList ?? [];

      // Debug print to verify
      print('AIT Details: $_aitDetails');
    }catch(e) {
      _setError(e.toString());
    }finally {
      _setLoading(false);
      _setError('');
    }
  }

  Future<void> fetchAitInfo(String empId) async {
    try {
      _setLoading(true);
      _setError('');
      _aitData = await attachmentRepo.fetchAitInfo(empId);
      print("ait proverder: $_aitData");
    }catch(e) {
      _setError(e.toString());
    }finally {
      _setLoading(false);
      _setError('');
    }
  }

  Future<bool> checkDuplicatechallan(String challanNumber) async {
    return await attachmentRepo.isChallanNumberExists(challanNumber);
  }

  void _setResponse(ApiResonseNew response){
    _aitResponse = response;
    notifyListeners();
  }
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void retryFetch(String empId) {
    fetchAitInfo(empId);
  }

  fetchAitData() {}

  void setSelectedCustomer(CustomerDetails? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }
  void setFinnacialYear(FinancialYear? fYear) {
    _selectFinancialYear = fYear;
    notifyListeners();
  }
}