import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/dropdown_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/base/new_api_resonse.dart';
import 'package:ssg_smart2/view/screen/attachment/ait_data.dart';

import 'attachment_repo.dart';


class AttachmentProvider with ChangeNotifier {
  final AttachmentRepo attachmentRepo;
  bool _isLoading = false;
  String _error = '';

  ApiResonseNew? _aitResponse;
  List<AitData> _aitData = [];

  List<DropDownModel> _customerDetails = [];
  List<DropDownModel> get customerDetails => _customerDetails;

  AttachmentProvider({required this.attachmentRepo});
  bool get isLoading => _isLoading;
  String get error => _error;
  List<AitData> get aitData => _aitData;
  ApiResonseNew? get aitResponse => _aitResponse;



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

  Future<void> fetchAitData() async {
    try {
      _setLoading(true);
      _setError('');
      _aitData = await attachmentRepo.fetchAitData();
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
}