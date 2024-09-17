import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/cashpayment_model.dart';
import 'package:ssg_smart2/data/repository/approval_repo.dart';
import 'package:ssg_smart2/data/repository/cashpayment_repo.dart';

import '../data/model/response/approval_flow.dart';
import '../data/model/response/base/api_response.dart';
import '../helper/api_checker.dart';
import 'auth_provider.dart';

class CashPaymentProvider with ChangeNotifier{
  final CashPaymentRepo cashPaymentRepo;
  List<CashPaymentModel> _cashPaymentData = [];

  bool _isLoading = false;
  String _error = '';
  String? _isSuccess;
  String? get isSuccess => _isSuccess;

  CashPaymentProvider({required this.cashPaymentRepo});

  List<CashPaymentModel> get cashPaymentModel => _cashPaymentData;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchCashPayData(String empId) async{
    _isLoading = true;
    _error = '';
    notifyListeners();

    try{
      _cashPaymentData = await cashPaymentRepo.fetchCashPaymentData(empId);
      print("Cash payment from provider: $_cashPaymentData");
    }catch(e){
      _error = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCashPaymentAkg(BuildContext context, String notificationId, String action, String empId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await cashPaymentRepo.handleCashPayment(notificationId, action,empId);
      if (response.response != null && response.response?.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.response.toString());
        if (responseData['success'] == 1) {
          _isSuccess = responseData['msg'][0];
        } else {
          _error = "Update failed";
        }
      } else {
        _error = "Server error occurred";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Future<List<CashPaymentModel>> getPaymentHistory(BuildContext context) async {
    List<CashPaymentModel> _list = [];
    String empId = Provider.of <AuthProvider> (context, listen: false).getEmpId();
    ApiResponse apiResponse = await cashPaymentRepo.fetchCashPaymentHistory(empId);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _list = [];
      apiResponse.response?.data['get_cash_pay_his'].forEach((item) => _list.add(CashPaymentModel.fromJson(item)));

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }
    return _list;

  }


}