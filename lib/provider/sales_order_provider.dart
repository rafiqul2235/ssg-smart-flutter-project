import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/screen/salesOrder/sales_data_model.dart';
import '../data/model/body/sales_order.dart';
import '../data/model/response/base/api_response.dart';
import '../data/model/response/salesorder/customer.dart';
import '../data/model/response/salesorder/customer_location.dart';
import '../data/model/response/salesorder/item.dart';
import '../data/model/response/salesorder/order_type.dart';
import '../data/model/response/salesorder/vehicle_type.dart';
import '../data/model/response/salesorder/warehouse.dart';
import '../data/repository/sales_order_repo.dart';
import '../helper/api_checker.dart';
import 'auth_provider.dart';

class SalesOrderProvider with ChangeNotifier {

  final SalesOrderRepo salesOrderRepo;
  SalesOrderProvider({required this.salesOrderRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading ?? false;

  String? _error;
  String? get error => _error;

  String? _isSuccess;
  String? get isSuccess => _isSuccess;

  List<Customer>? _customerList = [];
  List<Customer> get customerList => _customerList ?? [];

  List<OrderType> _orderTypeList = [];
  List<OrderType> get orderTypeList => _orderTypeList ?? [];

  List<Warehouse> _warehouseList = [];
  List<Warehouse> get warehouseList => _warehouseList ?? [];

  List<VehicleType> _vehicleTypeList = [];
  List<VehicleType> get vehicleTypeList => _vehicleTypeList ?? [];

  List<String> _freightTermsList = [];
  List<String> get freightTermsList => _freightTermsList ?? [];

  List<OrderItem> _itemList = [];
  List<OrderItem> get itemList => _itemList ?? [];

  List<CustomerShipLocation> _customerShipToLocationList = [];
  List<CustomerShipLocation> get customerShipToLocationList => _customerShipToLocationList ?? [];

  SalesOrder? _salesOrder;
  SalesOrder get salesOrder => _salesOrder ?? SalesOrder();

  Future<void> getCustomerAndItemListAndOthers(BuildContext context) async {
    //showLoading();
    try{
      String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
      String salesPersonId =  Provider.of<AuthProvider>(context, listen: false).getSalesPersonId();

      print('orgId $orgId, salesPersonId $salesPersonId');

      ApiResponse apiResponse = await salesOrderRepo.getCustomerAndItemListAndOthers(orgId,salesPersonId);

      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _customerList = [];
        _orderTypeList = [];
        _warehouseList = [];
        _vehicleTypeList = [];
        _freightTermsList = [];
        _itemList = [];
        if(apiResponse.response?.data['customers'] != null){
          apiResponse.response?.data['customers'].forEach((element) => _customerList?.add(Customer.fromJson(element)));
        }
        if(apiResponse.response?.data['order_types'] != null){
          apiResponse.response?.data['order_types'].forEach((element) => _orderTypeList.add(OrderType.fromJson(element)));
        }
        if(apiResponse.response?.data['warehouses'] != null){
          apiResponse.response?.data['warehouses'].forEach((element) => _warehouseList.add(Warehouse.fromJson(element)));
        }
        if( apiResponse.response?.data['vehicle_types'] != null){
          apiResponse.response?.data['vehicle_types'].forEach((element) => _vehicleTypeList.add(VehicleType.fromJson(element)));
        }
        if(apiResponse.response?.data['freight_terms'] != null){
          apiResponse.response?.data['freight_terms'].forEach((element) => _freightTermsList.add(element));
        }
        if(apiResponse.response?.data['items'] != null){
          apiResponse.response?.data['items'].forEach((element) => _itemList.add(OrderItem.fromJson(element)));
        }
        //print('Item data Count ${_itemList.length}');
        notifyListeners();
      }else{
        ApiChecker.checkApi(context, apiResponse);
      }

      print("Frieight term: $freightTermsList");
    }catch(e){
      print("error: $e");
     // hideLoading();
    }
   // hideLoading();
    return null;
  }

  Future<void> getCustomerShipToLocation(BuildContext context, String customerId) async {
    //showLoading();
    try{
      String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
      String salesPersonId =  Provider.of<AuthProvider>(context, listen: false).getSalesPersonId();

      print('orgId $orgId, salesPersonId $salesPersonId customerId $customerId');

      ApiResponse apiResponse = await salesOrderRepo.getCustomerShipToLocation(orgId,salesPersonId,customerId);

      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _customerShipToLocationList = [];

        if(apiResponse.response?.data['orders'] != null){
          apiResponse.response?.data['orders'].forEach((element) => _customerShipToLocationList.add(CustomerShipLocation.fromJson(element)));
        }
        print('CustomerShipToLocationList ${_customerShipToLocationList.length}');
        notifyListeners();
      }else{
        ApiChecker.checkApi(context, apiResponse);
      }
    }catch(e){
      print("error: $e");
      // hideLoading();
    }
    // hideLoading();
    return null;
  }

  Future<void> salesOrderSubmit(BuildContext context, SalesDataModel salesDataModel) async {
   // _resetState();
    showLoading();

    try{
      await _submitSalesApplication(salesDataModel);
    }catch(e){
      _error = "An error occurred: ${e.toString()}";
    }finally{
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> _submitSalesApplication(SalesDataModel salesdataModel) async {
    final response = await salesOrderRepo.salesOrderSubmitRep(salesdataModel);
    if (response.response != null && response.response?.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.response.toString());
      if (responseData['success'] == 1) {
        _isSuccess = responseData['msg'][0];
      } else {
        _error = "Sales Order Submission failed";
      }
    } else {
      _error = "Server error occurred";
    }
  }

  void showLoading(){
    if(!_isLoading!) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void hideLoading(){
    if(_isLoading!) {
      _isLoading = false;
      notifyListeners();
    }
  }



}