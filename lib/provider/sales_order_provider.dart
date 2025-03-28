import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/available_cust_balance.dart';
import 'package:ssg_smart2/data/model/response/customer_balance.dart';
import 'package:ssg_smart2/data/model/response/salesorder/item_price.dart';
import 'package:ssg_smart2/view/screen/salesOrder/sales_data_model.dart';
import '../data/model/body/collection.dart';
import '../data/model/body/sales_order.dart';
import '../data/model/dropdown_model.dart';
import '../data/model/response/base/api_response.dart';
import '../data/model/response/salesorder/bankinfo.dart';
import '../data/model/response/salesorder/customer.dart';
import '../data/model/response/salesorder/customer_location.dart';
import '../data/model/response/salesorder/item.dart';
import '../data/model/response/salesorder/order_type.dart';
import '../data/model/response/salesorder/pending_so.dart';
import '../data/model/response/salesorder/vehicle_type.dart';
import '../data/model/response/salesorder/warehouse.dart';
import '../data/repository/sales_order_repo.dart';
import '../helper/api_checker.dart';
import '../view/screen/msd_report/msd_report_model.dart';
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

  ItemPriceModel? _itemPriceModel;
  ItemPriceModel get itemPriceModel => _itemPriceModel??ItemPriceModel(itemPrice: 0);

  CustomerBalanceModel? _custBalance;
  CustomerBalanceModel get custBalance => _custBalance??CustomerBalanceModel(customerBalance: '');

  AvailableCustBalModel? _availCustBalance;
  AvailableCustBalModel get availCustBalance => _availCustBalance??AvailableCustBalModel(customerBalance: '');

  List<Customer>? _customerList = [];
  List<Customer> get customerList => _customerList ?? [];

  List<PendingSO>? _pendingSoList = [];
  List<PendingSO> get pendingSoList => _pendingSoList ?? [];

  List<OrderType> _orderTypeList = [];
  List<OrderType> get orderTypeList => _orderTypeList ?? [];

  List<Warehouse> _warehouseList = [];
  List<Warehouse> get warehouseList => _warehouseList ?? [];

  List<VehicleType> _vehicleTypeList = [];
  List<VehicleType> get vehicleTypeList => _vehicleTypeList ?? [];

  List<VehicleType> _vehicleCategoryList = [];
  List<VehicleType> get vehicleCategoryList => _vehicleCategoryList ?? [];

  List<String> _freightTermsList = [];
  List<String> get freightTermsList => _freightTermsList ?? [];

  List<OrderItem> _itemList = [];
  List<OrderItem> get itemList => _itemList ?? [];

  List<BankInfo> _bankInfoList = [];
  List<BankInfo> get bankInfoList => _bankInfoList ?? [];

  List<String> _modesList = [];
  List<String> get modesList => _modesList ?? [];

  List<CustomerShipLocation> _customerShipToLocationList = [];
  List<CustomerShipLocation> get customerShipToLocationList => _customerShipToLocationList ?? [];

  /* Submit Order Object */
  SalesOrder? _salesOrder;
  SalesOrder get salesOrder => _salesOrder ?? SalesOrder();

  List<MsdReportModel> _salesNotification = [];
  List<MsdReportModel> get salesNotification =>_salesNotification;

  /*DlvRequestItemDetail? _dlvRequestOrder;
  DlvRequestItemDetail get dlvRequestOrder => _dlvRequestOrder ?? DlvRequestItemDetail();*/

 /*
  ItemDetail? _itemDetails;
  ItemDetail get itemDetails => _itemDetails ?? ItemDetail();
 */

  Future<void> clearSalesOrderItem() async{
    _salesOrder ??= SalesOrder();
    _salesOrder?.orderItemDetail?.clear();
  }

  Future<void> deleteSalesOrderItem(int itemId, int amount) async{
    _salesOrder?.orderItemDetail?.removeWhere((item) => item.itemId == itemId);
    notifyListeners();
  }

  Future<void> EditableSalesOrderItem(int itemId, bool editable) async{
    for(ItemDetail item in _salesOrder!.orderItemDetail!){
      if(item.itemId == itemId){
        item.isEditable = editable;
        break;
      }
    }
    notifyListeners();
  }

  Future<List<DropDownModel>> getVehicleCategoryByType(String vehicleType) async {
    List<DropDownModel> vehicleCats = [];
     for(VehicleType item in vehicleTypeList){
      if(item.typeId == vehicleType){
        item.categories?.forEach((catItem) =>
            vehicleCats.add(DropDownModel(code: catItem.categoryId, name: catItem.categoryName)));
        break;
      }
     }
    return vehicleCats;
  }

  Future<void> addSalesOrderItem(ItemDetail item) async {
    _salesOrder ??= SalesOrder();
    _salesOrder?.addItem(item);

    if(_salesOrder==null){
      print(' null ');
    }else{
      print(' not null ');
    }

    print('addSalesOrderItem ${_salesOrder?.orderItemDetail?.length}');
    //notifyListeners();
  }

  /*Future<void> addDeliveryReqItem(DlvRequestItemDetail item) async {
    _dlvRequestOrder ??= DlvRequestItemDetail();
    _dlvRequestOrder?.;

    if(_dlvRequestOrder==null){
      print(' null ');
    }else{
      print(' not null ');
    }

    print('addSalesOrderItem ${_dlvRequestOrder?.dlvItemDetail?.length}');
    //notifyListeners();
  }*/

  List<MsdReportModel> _msdsalesReport = [];
  List<MsdReportModel> get msdsalesReport => _msdsalesReport;

  Future<void> getCustomerAndItemListAndOthers(BuildContext context) async {
    //showLoading();
    try{
      String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
      String salesPersonId =  Provider.of<AuthProvider>(context, listen: false).getSalesPersonId();

      print('orgId $orgId, salesPersonId $salesPersonId');

      ApiResponse apiResponse = await salesOrderRepo.getCustomerAndItemListAndOthers(orgId,salesPersonId);

      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _customerList = [];
       // _pendingSoList = [];
        _orderTypeList = [];
        _warehouseList = [];
        _vehicleTypeList = [];
        _freightTermsList = [];
        _itemList = [];
        if(apiResponse.response?.data['customers'] != null){
          apiResponse.response?.data['customers'].forEach((element) => _customerList?.add(Customer.fromJson(element)));
        }
        /*if(apiResponse.response?.data['pending_so'] != null){
          apiResponse.response?.data['pending_so'].forEach((element) => _pendingSoList?.add(PendingSO.fromJson(element)));
        }*/
        if(apiResponse.response?.data['order_types'] != null){
          apiResponse.response?.data['order_types'].forEach((element) => _orderTypeList.add(OrderType.fromJson(element)));
        }
        if(apiResponse.response?.data['warehouses'] != null){
          apiResponse.response?.data['warehouses'].forEach((element) => _warehouseList.add(Warehouse.fromJson(element)));
        }
        if( apiResponse.response?.data['vehicle_types'] != null){
          apiResponse.response?.data['vehicle_types'].forEach((element) => _vehicleTypeList.add(VehicleType.fromJson(element)));
        }
        if( apiResponse.response?.data['pending_so'] != null){
          apiResponse.response?.data['pending_so'].forEach((element) => _vehicleTypeList.add(VehicleType.fromJson(element)));
        }
        if( apiResponse.response?.data['vehicle_types'] != null){
          apiResponse.response?.data['vehicle_types'].forEach((element) => _vehicleCategoryList.add(VehicleType.fromJson(element)));
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

    print('getCustomerShipToLocation ');

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

  Future<void> getPendingSo(BuildContext context) async {
    //showLoading();
    try{
      //String salesPersonId =  Provider.of<AuthProvider>(context, listen: false).getSalesPersonId();

      print('getPendingSo');

      ApiResponse apiResponse = await salesOrderRepo.getPendingSoRep("100125041","939295");

      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _pendingSoList = [];
        print('pendingSoLeanth ${apiResponse.response?.data['pending_so'].length}');
        if(apiResponse.response?.data['pending_so'] != null){
          apiResponse.response?.data['pending_so'].forEach((element) => _pendingSoList?.add(PendingSO.fromJson(element)));
        }
        print('pendingSoLeanth ${_pendingSoList?.length}');
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


  Future<void> getItemName(BuildContext context, String wareHoseId) async {
    //showLoading();
    try{
      //print('orgId $orgId');
      ApiResponse apiResponse = await salesOrderRepo.getItemRep(wareHoseId);

      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _itemList = [];

        if(apiResponse.response?.data['items'] != null){
          apiResponse.response?.data['items'].forEach((element) => _itemList.add(OrderItem.fromJson(element)));
        }
        print('_itemlist ${_itemList.length}');
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


  Future<bool> salesOrderSubmit(BuildContext context, SalesOrder salesOrder) async {
   // _resetState();
    showLoading();
    bool success = false;

    try{
      final response = await salesOrderRepo.salesOrderSubmitRep(salesOrder);
      if (response.response != null && response.response?.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.response.toString());
        print('salesOrderSubmit '+responseData.toString());
        if (responseData['success'] == 1) {
          //_isSuccess = responseData['msg'][0];
          _salesOrder = SalesOrder();
          success = true;
        } else {
          //_error = "Sales Order Submission failed";
        }
      } else {
        _error = "Server error occurred";
      }
    }catch(e){
      _error = "An error occurred: ${e.toString()}";
      print('salesOrderSubmit '+e.toString());
    }finally{
      hideLoading();
     // notifyListeners();
      return success;
    }
  }

  Future<bool> deliveryRequestSubmit(BuildContext context, SalesOrder salesOrder) async {
    // _resetState();
    showLoading();
    bool success = false;

    try{
      final response = await salesOrderRepo.deliveryRequestSubmitRep(salesOrder);
      if (response.response != null && response.response?.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.response.toString());
        print('salesOrderSubmit '+responseData.toString());
        if (responseData['success'] == 1) {
          //_isSuccess = responseData['msg'][0];
          _salesOrder = SalesOrder();
          success = true;
        } else {
          //_error = "Sales Order Submission failed";
        }
      } else {
        _error = "Server error occurred";
      }
    }catch(e){
      _error = "An error occurred: ${e.toString()}";
      print('DlvRequestSubmit '+e.toString());
    }finally{
      hideLoading();
      // notifyListeners();
      return success;
    }
  }


  Future<ItemPriceModel?> getItemPrice(BuildContext context,String account_id,String site_id,String item_id,String freght) async {
    String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
    ApiResponse apiResponse = await salesOrderRepo.getItemPriceRep(orgId,account_id,site_id,item_id,freght);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _itemPriceModel = ItemPriceModel.fromJson(apiResponse.response?.data['item_price'][0]);

      return _itemPriceModel;

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }

    return ItemPriceModel(itemPrice: 0);

  }


  Future<CustomerBalanceModel?> getCustBalance(BuildContext context,String customerId) async {
    String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
    ApiResponse apiResponse = await salesOrderRepo.geCustBalance(orgId,customerId);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _custBalance = CustomerBalanceModel.fromJson(apiResponse.response?.data['customer_balance'][0]);

      return _custBalance;

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }

    return CustomerBalanceModel(customerBalance: '');

  }


  Future<AvailableCustBalModel?> getCustAvailBalance(BuildContext context,String customerId) async {
    String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
    ApiResponse apiResponse = await salesOrderRepo.getAvailCustBalance(orgId,customerId);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _availCustBalance = AvailableCustBalModel.fromJson(apiResponse.response?.data['cust_balance'][0]);

      return _availCustBalance;

    }else{
      ApiChecker.checkApi(context, apiResponse);
    }

    return AvailableCustBalModel(customerBalance: '');

  }


  /*Future<void> _submitSalesApplication(SalesDataModel salesdataModel) async {
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
  }*/

  Future<void> fetchSalesNotification(String salesrep_id, String cust_id,String fromDate, String toDate, String type) async{
    _isLoading = true;
    _error = '';
    notifyListeners();

    try{
      _salesNotification = await salesOrderRepo.fetchSalesNotificationData(salesrep_id, cust_id, fromDate, toDate, type);
      print("notification provider: $_salesNotification");
    }catch(e){
      _error = e.toString();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSalesMsadReport(String salesrep_id, String cust_id,String fromDate, String toDate, String type) async {
    _isLoading = true;
    notifyListeners();

    try {
      _msdsalesReport = await salesOrderRepo.fetchMsdReportRep(salesrep_id, cust_id,fromDate, toDate, type);
    } catch (e) {
      print('Error fetching: $e');
      _msdsalesReport = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCollectionInformation(BuildContext context) async {
    //showLoading();
    try{
      String orgId =  Provider.of<AuthProvider>(context, listen: false).getOrgId();
      String salesPersonId =  Provider.of<AuthProvider>(context, listen: false).getSalesPersonId();

      //print('orgId $orgId, salesPersonId $salesPersonId');

      ApiResponse apiResponse = await salesOrderRepo.getCollectionInformation(orgId,salesPersonId);

      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _customerList = [];
        _bankInfoList = [];
        _modesList = [];

        if(apiResponse.response?.data['banks'] != null){
          apiResponse.response?.data['banks'].forEach((element) => _bankInfoList.add(BankInfo.fromJson(element)));
        }

        if(apiResponse.response?.data['customers'] != null){
          apiResponse.response?.data['customers'].forEach((element) => _customerList?.add(Customer.fromJson(element)));
        }

        if(apiResponse.response?.data['modes'] != null){
          apiResponse.response?.data['modes'].forEach((element) => _modesList.add(element));
        }

        print('Modes Count ${_modesList.length}');
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

  Future<bool> collectionSubmit(BuildContext context, Collection collection) async {
    // _resetState();
    showLoading();
    bool success = false;

    try{
      final response = await salesOrderRepo.collectionSubmission(collection);
      if (response.response != null && response.response?.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.response.toString());
        print('collectionSubmit '+responseData.toString());
        if (responseData['success'] == 1) {
          success = true;
        } else {
          _error = "Collection Submission failed";
        }
      } else {
        _error = "Server error occurred";
      }
    }catch(e){
      _error = "An error occurred: ${e.toString()}";
      print('collectionSubmit '+e.toString());
    }finally{
      hideLoading();
      // notifyListeners();
      return success;
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