import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/dropdown_model.dart';
import 'package:ssg_smart2/data/model/response/AitResponse.dart';
import 'package:ssg_smart2/data/model/response/ait_essential.dart';
import 'package:ssg_smart2/data/model/response/base/new_api_resonse.dart';
import 'package:ssg_smart2/view/screen/attachment/ait_data.dart';

import '../../../data/model/body/ait_details.dart';
import '../../../data/model/body/approver.dart';
import 'attachment_repo.dart';

class AttachmentProvider with ChangeNotifier {
  final AttachmentRepo attachmentRepo;
  bool _isLoading = false;
  String _error = '';

  ApiResonseNew? _aitResponse;
  List<AitData> _aitData = [];
  AitResponse? _response;

  List<DropDownModel> _customerDetails = [];
  List<DropDownModel> get customerDetails => _customerDetails;

  List<DropDownModel> _financialYears = [];
  List<DropDownModel> get financialYears => _financialYears;

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

  
  Future<void> fetchCustomerDetailsInfo(String orgId, String salesId) async{
    try {
      _setLoading(true);
      _setError('');
      final List<CustomerDetails> _customers = await attachmentRepo.fetchCustomerDetailsInfo(orgId, salesId);
      print("value of customers: $_customers");
      _customerDetails = (_customers as List)
          .map((customer) => DropDownModel.fromJsonCustomerInfo(customer))
          .toList();
      print("provider: ${_customerDetails}");
      _setLoading(false);
    }catch (e) {
      _setError(e.toString());
    }finally {
      _setLoading(false);
      _setError('');
    }
  }
  Future<void> fetchAitEssentails(String orgId, String salesId) async{
    try {
      _setLoading(true);
      _setError('');
      final AitEssentialResponse aitEssential = await attachmentRepo.fetchAitEssential(orgId, salesId);

      _customerDetails = (aitEssential.customerDetails as List)
          .map((customer) => DropDownModel.fromJsonCustomerInfo(customer))
          .toList();
      print("customer: ${_customerDetails}");
      _financialYears = (aitEssential.financialYears as List)
          .map((fny) => DropDownModel.fromJsonFinancialYear(fny))
          .toList();
      print("financial: ${_financialYears}");
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
    }catch(e) {
      _setError(e.toString());
    }finally {
      _setLoading(false);
      _setError('');
    }
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
}