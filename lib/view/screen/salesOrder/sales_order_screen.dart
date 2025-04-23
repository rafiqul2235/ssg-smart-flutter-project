import 'package:ssg_smart2/data/model/body/sales_order.dart';
import 'package:ssg_smart2/data/model/response/available_cust_balance.dart';
import 'package:ssg_smart2/data/model/response/customer_balance.dart';
import 'package:ssg_smart2/data/model/response/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/salesorder/customer_location.dart';
import 'package:ssg_smart2/data/model/response/salesorder/item.dart';
import 'package:ssg_smart2/data/model/response/salesorder/item_price.dart';
import 'package:ssg_smart2/helper/date_converter.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/notification_provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ssg_smart2/view/screen/salesOrder/sales_data_model.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/salesorder/customer.dart';
import '../../../provider/auth_provider.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/button/custom_button_with_icon.dart';
import '../../basewidget/custom_auto_complete.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/custom_loading.dart';
import '../../basewidget/dialog/add_sales_order_item_dialog.dart';
import '../../basewidget/guest_dialog.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/my_dialog.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../../basewidget/textfield/custom_textfield.dart';
import '../home/dashboard_screen.dart';
import 'dart:developer' as developer;

class SalesOrderScreen extends StatefulWidget {
  final bool isBackButtonExist;

  const SalesOrderScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  TextEditingController? _customerController;
  TextEditingController? _warehouseController;
  TextEditingController? _shipToSiteController;
  TextEditingController? _orgNameController;
  TextEditingController? _cusPONoController;
  TextEditingController? _depositDateController;
  TextEditingController? _qtyController;
  TextEditingController? _deliverySiteDetailController;

  Customer? _selectedCustomer;
  //CustomerShipLocation? _shipLocationInfo;
  CustomerBalanceModel? _balanceModel;
  ItemPriceModel? _itemPriveModel;
  AvailableCustBalModel? _availableBalanceModel;

  CustomerBalanceModel? _custBalance = CustomerBalanceModel(customerBalance: '');

  List<DropDownModel> _customersDropDown = [];
  DropDownModel? _selectedCustomerDropDown;

  List<DropDownModel> _itemsDropDown = [];
  DropDownModel? _selectedItem;

  List<DropDownModel> _orderTypeDropDown = [];
  DropDownModel? _selectedOrderType;

  List<DropDownModel> _warehousesDropDown = [];
  DropDownModel? _selectedWareHouse;

  List<DropDownModel> _freightTermsDropDown = [];
  DropDownModel? _selectedFreightTerms;

  List<DropDownModel> _vehicleTypesDropDown = [];
  DropDownModel? _selectedVehicleType;

  List<DropDownModel> _vehicleCatDropDown = [];
  DropDownModel? _selectedVehicleCat;

  List<DropDownModel> _shipToLocationDropDown = [];
  //DropDownModel? _selectedShipToLocation;


  bool isViewOnly = false;
  bool addItem = true;

  bool _customerFieldError = false;
  bool _warehouseFieldError = false;
  bool _freightTermsFieldError = false;
  bool _orderDateFieldError = false;

  //SalesOrder? _salesOrder;


  String _orgName = '';
  String _userId= '';
  String _warehouseId = '';
  String _custId = '';
  String _custAccount = '';
  String _freightTerms = '';
  String _shipToSiteId = '';
  String _shipToLocation = '';
  String  _primaryShipTo = '';
  String  _salesPersonId = '';
  int _itemId = 0;
  String formattedDate = '';
  String customerBal ='';
  int itemPriceInt = 0;
  double totalPriceInt = 0;

  String _vehicleType ='';
  String _vehicleCate ='';

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController();
    _orgNameController = TextEditingController();
    _depositDateController = TextEditingController();
    _qtyController = TextEditingController();
    _deliverySiteDetailController = TextEditingController();
    _cusPONoController = TextEditingController();
    _intData();
  }

  void _intData() async {
    currentDateTime();
    Provider.of<SalesOrderProvider>(context, listen: false).clearData();
    Provider.of<SalesOrderProvider>(context, listen: false).clearSalesOrderItem();
    _orgName = Provider.of<AuthProvider>(context, listen: false).getOrgName();
    _orgNameController?.text = _orgName ?? '';
    _depositDateController?.text = formattedDate ?? '';
    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerAndItemListAndOthers(context);
    _userId = Provider.of<AuthProvider>(context, listen: false).getUserId();
  }

  void currentDateTime() {
    // Get the current date and time
    DateTime now = DateTime.now();
    // Print the current date
    print("Current Date: ${now.toLocal()}"); // Outputs: YYYY-MM-DD HH:MM:SS.mmmuuu
    // If you want only the date (DD-MM-YYYY)
    formattedDate ="${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    print("Formatted Date: $formattedDate"); // Outputs: DD-MM-YYYY
  }

  Future<void> _onClickCustBal() async {
    final salesProvider = Provider.of<SalesOrderProvider>(context, listen: false);
    await salesProvider.getCustBalance(context, '$_custId');
    _balanceModel = salesProvider.custBalance;
    final customerBal = _balanceModel!.customerBalance;
    print("customerBalance : $customerBal");

    //print("Sales data: $CustomerBalanceModel()!.customerBalance");
    if (_selectedCustomer == null) {
      _showErrorDialog("Select Customer for showing Balance");
      return;
    }
    // _showErrorDialog("Rafiqul");
    _showCustBalDialog('$customerBal');
    return;
  }

  Future<void> _onClickItemPrice(int itemId, String siteId) async {

    if(_custAccount == null || _custAccount.isEmpty){
      _showErrorDialog("Select Customer");
      return;
    }

    if(itemId == null || itemId <= 0){
      _showErrorDialog("Select Item");
      return;
    }

    if(siteId == null || siteId.isEmpty){
      _showErrorDialog("Select Site ID");
      return;
    }

    if(_freightTerms == null || _freightTerms.isEmpty){
      _showErrorDialog("Select Freight Terms");
      return;
    }

    final salesProvider = Provider.of<SalesOrderProvider>(context, listen: false);
    await salesProvider.getItemPrice(context, '$_custId',siteId,itemId.toString(),'$_freightTerms');
    final String qtyText = _qtyController?.text ?? '0';
    //final TextEditingController _qtyController = TextEditingController();
    final int quantity = int.tryParse(qtyText) ?? 0;
    _itemPriveModel = salesProvider.itemPriceModel;

    setState(() {
      itemPriceInt = _itemPriveModel!.itemPrice;
      totalPriceInt = (itemPriceInt * quantity).toDouble();
      // print("Item ptice : $itemPriceInt");
    });
    if( itemPriceInt <= 0){
      _showErrorDialog("Inactive price, Please contact with Finance department");
      return;
    }
    return;

  }


  Future<void>  _onClickAddButton() async {

    _customerFieldError = false;
    _warehouseFieldError = false;
    _freightTermsFieldError = false;
    _orderDateFieldError = false;

    if (_selectedCustomer == null) {
      _customerFieldError = true;
      _showMessage('Select Customer!',true);
      return;
    }

    if (_warehouseId == null || _warehouseId.isEmpty ) {
      _warehouseFieldError = true;
      _showMessage('Select Warehouse',true);
      return;
    }

    if(_freightTerms == null || _freightTerms.isEmpty){
      _showErrorDialog("Select Freight Terms");
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    showAnimatedDialog(
      context,
      //GuestDialog(),
      AddSalesOrderItemDialog(),
      dismissible: false,
    );
  /*

    ItemDetail? itemDetail = ItemDetail();
    itemDetail.salesPersonId = _salesPersonId;
    itemDetail.customerId = _selectedCustomer?.customerId;
    itemDetail.orgId = _selectedCustomer?.orgId;
    itemDetail.shipToSiteId = _shipToSiteId;
    itemDetail.primaryShipTo = _primaryShipTo;
    itemDetail.shipToLocation = _shipToLocation;
    itemDetail.customerName = _selectedCustomer?.customerName;

    itemDetail.itemName = _selectedItem?.name;
    itemDetail.itemId = _selectedItem?.id;
    itemDetail.itemUOM = _selectedItem?.code;
    itemDetail.quantity = _qtyController!=null && _qtyController!.text.isNotEmpty?int.parse(_qtyController!.text):0;
    itemDetail.unitPrice = itemPriceInt??0;
    itemDetail.totalPrice = totalPriceInt??0;
    //itemDetail.remarks = _deliverySiteDetailController?.text;
    itemDetail.primaryShipTo = _deliverySiteDetailController?.text;
    itemDetail.vehicleType = _vehicleType;
    itemDetail.vehicleTypeId = _selectedVehicleType?.id.toString();
    itemDetail.vehicleCate = _vehicleCate;
    itemDetail.vehicleCateId = _selectedVehicleCat?.id.toString();

    Provider.of<SalesOrderProvider>(context, listen: false).addSalesOrderItem(itemDetail);

    //Provider.of<SalesOrderProvider>(context, listen: false).clearShipToLocationData();
    *//* Clear Data *//*
    _selectedItem = null;
    _shipToLocation='';
    _qtyController?.text = '';
    itemPriceInt=0;
    totalPriceInt=0;
    _deliverySiteDetailController?.text = '';
    _vehicleType = '';
    _selectedVehicleType = null;
    _vehicleCate = '';
    _selectedVehicleCat = null;*/
  }

  Future<void> _onClickSubmit() async {

    _customerFieldError = false;
    _warehouseFieldError = false;
    _freightTermsFieldError = false;
    _orderDateFieldError = false;

    if (_selectedCustomer == null) {
      _customerFieldError = true;
      _showMessage('Select Customer!',true);
      return;
    }

    if (_warehouseId == null || _warehouseId.isEmpty ) {
      _warehouseFieldError = true;
      _showMessage('Select Warehouse',true);
      return;
    }

    if(_freightTerms == null || _freightTerms.isEmpty){
      _showErrorDialog("Select Freight Terms");
      return;
    }


    /*ItemDetail? itemDetail = ItemDetail();
    Provider.of<SalesOrderProvider>(context, listen: false).addSalesOrderItem(itemDetail);

    if (itemDetail== null) {
      _showErrorDialog("Please add at least one order item.");
      return;
    }*/



    /* if(_selectedItem == null){
      _showErrorDialog("Select Item");
      return;
    }

    if(_shipToLocationDropDown == null){
      _showErrorDialog("Select Ship to Location");
      return;
    }

    if(_qtyController == null || _qtyController!.text.isEmpty){
      _showErrorDialog("Enter SO Qty");
      return;
    }

    if(_selectedVehicleType == null){
      _showMessage('Select Vehicle Type',true);
      return;
    }*/

    SalesOrder? salesInfoModel = Provider.of<SalesOrderProvider>(context, listen: false).salesOrder;
    if(salesInfoModel == null || salesInfoModel.orderItemDetail == null || salesInfoModel.orderItemDetail!.length <= 0){
      _showErrorDialog("Please add item");
      return;
    }


    var isSubmit = await showAnimatedDialog(context, MyDialog(
      title: '',
      description: 'Are you sure you want to submit your order?',
      rotateAngle: 0,
      negativeButtonTxt: 'No',
      positionButtonTxt: 'Yes',
    ), dismissible: false);

    if(!isSubmit!) return;


    salesInfoModel.customerId = _selectedCustomer?.customerId;
    salesInfoModel.salesPersonId = _selectedCustomer?.salesPersonId;
    salesInfoModel.orgId = _selectedCustomer?.orgId;
    //salesInfoModel.orgName = _selectedCustomer?.orgName;
    salesInfoModel.accountNumber = _selectedCustomer?.accountNumber;
    salesInfoModel.partySiteNumber = _selectedCustomer?.partySiteNumber;
    salesInfoModel.billToSiteId = _selectedCustomer?.billToSiteId;
    salesInfoModel.customerName = _selectedCustomer?.customerName;
    salesInfoModel.billToAddress = _selectedCustomer?.billToAddress;
    salesInfoModel.priceListId = _selectedCustomer?.priceListId;
    salesInfoModel.primaryShipToSiteId = _selectedCustomer?.primaryShipToSiteId;
    salesInfoModel.orgId = _selectedCustomer?.orgId;
    salesInfoModel.userId = _userId;
    salesInfoModel.orderType = _selectedCustomer?.orderType;
    salesInfoModel.orderTypeId = _selectedCustomer?.orderTypeId;
    salesInfoModel.freightTerms = _freightTerms;
    salesInfoModel.orderDate = formattedDate;
    salesInfoModel.warehouseId = _warehouseId;
    salesInfoModel.warehouseName = _selectedWareHouse?.name;
    salesInfoModel.customerPoNumber = _cusPONoController?.text;

   // developer.log(salesInfoModel.toJson().toString());

    await Provider.of<SalesOrderProvider>(context, listen: false).salesOrderSubmit(context, salesInfoModel).then((status) async {

      if(status){
        _customerController?.text= '';
        if(_shipToSiteController!=null) {
          _shipToSiteController!.text = '';
        }

        _selectedCustomer = null;
        _warehouseId = '';
        _custId = '';
        Provider.of<SalesOrderProvider>(context, listen: false).selectedCustId = '';
        _custAccount = '';
        _freightTerms = '';
        Provider.of<SalesOrderProvider>(context, listen: false).selectedFreightTerms = '';
        _selectedWareHouse = null;
        _selectedFreightTerms = null;
        //_selectedShipToLocation = null;
        itemPriceInt=0;
        totalPriceInt=0;
      }


      bool? action = await showAnimatedDialog(context, MyDialog(
        title: status?'Successfully submitted your order':"Fail, Please try again",
        description: 'Are you sure you want to submit your Another Sales Order?',
        rotateAngle: 0,
        negativeButtonTxt: 'YES',
        positionButtonTxt: 'NO',
      ), dismissible: false);

      if(action!){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const DashBoardScreen()));
      }

    });

  }


  @override
  Widget build(BuildContext context) {
    final freightTerm = Provider.of<SalesOrderProvider>(context).freightTermsList;
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(children: [
        CustomAppBar(
            title: 'Sales Order',
            isBackButtonExist: widget.isBackButtonExist,
            icon: Icons.home,
            onActionPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            }),

        Expanded(
          child: Consumer<SalesOrderProvider>(
            builder: (context, provider, child) {
              if (_customersDropDown == null || _customersDropDown.isEmpty) {
                _customersDropDown = [];
                provider.customerList.forEach((element) =>
                    _customersDropDown.add(DropDownModel(
                        code: element.customerId, name: element.customerName)));
              }

              if (_itemsDropDown == null || _itemsDropDown.isEmpty) {
                _itemsDropDown = [];
                provider.itemList.forEach((element) => _itemsDropDown.add(
                    DropDownModel(id: element.itemId, name: element.itemName, code: element.itemUOM)));
              }

              if (_orderTypeDropDown == null || _orderTypeDropDown.isEmpty) {
                _orderTypeDropDown = [];
                provider.orderTypeList.forEach((element) =>
                    _orderTypeDropDown.add(DropDownModel(
                        code: element.orderTypeId, name: element.orderType)));
              }

              if (_warehousesDropDown == null || _warehousesDropDown.isEmpty) {
                _warehousesDropDown = [];
                provider.warehouseList.forEach((element) =>
                    _warehousesDropDown.add(DropDownModel(
                        code: element.warehouseId,
                        name: element.warehouseName)));
              }

              if (_freightTermsDropDown == null ||
                  _freightTermsDropDown.isEmpty) {
                _freightTermsDropDown = [];
                provider.freightTermsList.forEach((element) =>
                    _freightTermsDropDown
                        .add(DropDownModel(code: element, name: element)));
              }

              if (_vehicleTypesDropDown == null ||
                  _vehicleTypesDropDown.isEmpty) {
                _vehicleTypesDropDown = [];
                provider.vehicleTypeList.forEach((element) =>
                    _vehicleTypesDropDown.add(DropDownModel(
                        code: element.typeId, name: element.typeName)));
              }

              //if (_shipToLocationDropDown.isEmpty) {
                _shipToLocationDropDown = [];
                provider.customerShipToLocationList.forEach((element) =>
                    _shipToLocationDropDown.add(DropDownModel(
                        code: element.shipToSiteId,
                        name: element.shipToLocation,
                        nameBl: element.primaryShipTo,
                        description: element.salesPersonId
                    )));
             // }

              return ListView(children: [
                provider.isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 10.0, bottom: 5.0),
                        child: CustomTextLoading(),
                      )
                    : const SizedBox.shrink(),
                // for Org Name
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.business,
                            color: ColorResources.getPrimary(context),
                            size: 20,
                          ),
                          const SizedBox(
                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          MandatoryText(
                            text: 'Org Name',
                            textStyle: titilliumRegular,
                            mandatoryText: '*',
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              height: 35,
                              controller: _orgNameController,
                              hintText: 'Org Name',
                              // hintText: '${_customer?.orgId}',
                              borderColor: Colors.black12,
                              textInputType: TextInputType.text,
                              readOnly: true,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // for Customer
                Container(
                  margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_SMALL,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns content to the start
                    children: [
                      // Row for Label and Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            color: ColorResources.getPrimary(context),
                            size: 20,
                          ),
                          const SizedBox(
                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          MandatoryText(
                            text: 'Customer',
                            textStyle: titilliumRegular,
                            mandatoryText: '*',
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: Dimensions
                              .MARGIN_SIZE_SMALL), // Spacing between rows
                      // Row for Dropdown Field
                      Row(
                        children: [
                          Expanded(
                            child: CustomAutoComplete(
                              dropdownItems: _customersDropDown,
                              hint: 'Select Customer Name',
                              value: _customerController != null
                                  ? _customerController!.text
                                  : '',
                              icon: const Icon(Icons.search),
                              height: 45,
                              width: width,
                              dropdownHeight: 300,
                              dropdownWidth: width - 40,
                              borderColor: _customerFieldError?Colors.red:Colors.transparent,
                              onReturnTextController: (textController) =>
                                  _customerController = textController,
                              onClearPressed: () {
                                setState(() {

                                  if(_shipToSiteController!=null) {
                                    _shipToSiteController!.text = '';
                                  }
                                  _selectedCustomer = null;
                                  Provider.of<SalesOrderProvider>(context, listen: false).selectedCustomer = null;
                                  _warehouseId = '';
                                  _custId = '';
                                  Provider.of<SalesOrderProvider>(context, listen: false).selectedCustId = '';
                                  _custAccount = '';
                                  _freightTerms = '';
                                  Provider.of<SalesOrderProvider>(context, listen: false).selectedFreightTerms = '';
                                  _selectedWareHouse = null;
                                  _selectedFreightTerms = null;
                                  //_selectedShipToLocation = null;
                                  itemPriceInt=0;
                                  totalPriceInt=0;
                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());

                                //_selectedShipToLocation = null;
                                _shipToLocationDropDown = [];

                                if(_shipToSiteController!=null) {
                                  //_shipToSiteController!.text = '';
                                }

                                Provider.of<SalesOrderProvider>(context, listen: false).clearShipToLocationData();

                                for (Customer customer in provider.customerList) {
                                  if (customer.customerId == value.code) {
                                    provider.salesOrder.customerId = customer.customerId;
                                    provider.salesOrder.customerName = customer.customerName;
                                    provider.salesOrder.warehouseId = customer.warehouseId;
                                    provider.salesOrder.warehouseName = customer.warehouseName;
                                    provider.salesOrder.freightTermsId = customer.freightTermsId;
                                    provider.salesOrder.freightTerms = customer.freightTerms;

                                    _selectedCustomer = customer;
                                    _custId = _selectedCustomer?.customerId ?? '';
                                    Provider.of<SalesOrderProvider>(context, listen: false).selectedCustomer = customer;
                                    Provider.of<SalesOrderProvider>(context, listen: false).selectedCustId = _selectedCustomer?.customerId ?? '';
                                    _custAccount = _selectedCustomer?.accountNumber ?? '';
                                    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, _custId);
                                    _warehouseId = _selectedCustomer?.warehouseId ?? '';
                                    _freightTerms =  _selectedCustomer?.freightTerms ?? '';
                                    Provider.of<SalesOrderProvider>(context, listen: false).selectedFreightTerms = _selectedCustomer?.freightTerms ?? '';
                                    _selectedWareHouse = null;
                                    break;
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // for Customer PO Number
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            color: ColorResources.getPrimary(context),
                            size: 20,
                          ),
                          const SizedBox(
                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          MandatoryText(
                            text: 'Customer PO Number',
                            textStyle: titilliumRegular,
                            //mandatoryText: '*',
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              height: 45,
                              controller: _cusPONoController,
                              hintText: 'Enter Customer PO Number',
                              borderColor: Colors.black12,
                              textInputType: TextInputType.text,
                              readOnly: false,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // for Warehouse
                Container(
                  margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_SMALL,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align content to the left
                    children: [
                      // Row for Icon and Mandatory Text
                      Row(
                        children: [
                          Icon(
                            Icons.warehouse,
                            color: ColorResources.getPrimary(context),
                            size: 20,
                          ),
                          const SizedBox(
                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          MandatoryText(
                            text: 'Warehouse',
                            textStyle: titilliumRegular,
                            mandatoryText: '*',
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: Dimensions
                              .MARGIN_SIZE_SMALL), // Space between label and dropdown
                      // Dropdown Button
                      CustomAutoComplete(
                        dropdownItems: _warehousesDropDown,
                        value: _warehouseController != null
                            ? _warehouseController!.text
                            : _warehouseId??'',
                        icon: const Icon(Icons.search),
                        height: 45,
                        width: width,
                        hint: _selectedCustomer?.warehouseName??"",
                        hintColor: Colors.black,
                        dropdownHeight: 300,
                        dropdownWidth: width - 40,
                        borderColor: _warehouseFieldError?Colors.red:Colors.transparent,
                        onReturnTextController: (textController) =>
                            _warehouseController = textController,
                        onChanged: (value) {
                          setState(() {
                            _warehouseId = value.code??'0';
                            _selectedWareHouse = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // for FREIGHT TERMS
                Container(
                  margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_SMALL,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align content to the left
                    children: [
                      // Row for Icon and Mandatory Text (Label)
                      Row(
                        children: [
                          Icon(
                            Icons.vaccines,
                            color: ColorResources.getPrimary(context),
                            size: 20,
                          ),
                          const SizedBox(
                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          MandatoryText(
                            text: 'Freight Terms',
                            textStyle: titilliumRegular,
                            mandatoryText: '*',
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: Dimensions
                              .MARGIN_SIZE_SMALL), // Space between label and dropdown
                      // Dropdown Field
                      CustomDropdownButton(
                        buttonHeight: 45,
                        buttonWidth: double.infinity,
                        dropdownWidth: width - 40,
                        hint: _freightTerms,
                        hintColor: Colors.black,
                        dropdownItems: _freightTermsDropDown,
                        value: _selectedFreightTerms,
                        buttonBorderColor: Colors.black12,
                        onChanged: (value) {
                          setState(() {
                            _freightTerms = value?.code??'0';
                            Provider.of<SalesOrderProvider>(context, listen: false).selectedFreightTerms = value?.code??'0';
                            _selectedFreightTerms = value;
                          });
                        },
                      ),

                    ],
                  ),
                ),

               /* Container(
                  margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_SMALL,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    bottom: Dimensions.MARGIN_SIZE_DEFAULT,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align content to the left
                    children: [
                      // Row for Icon and Mandatory Text (Label)
                      Row(
                        children: [
                          Icon(
                            Icons.confirmation_num_outlined,
                            color: ColorResources.getPrimary(context),
                            size: 20,
                          ),
                          const SizedBox(
                              width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          MandatoryText(
                            text: 'Order Date',
                            textStyle: titilliumRegular,
                            mandatoryText: '*',
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: Dimensions
                              .MARGIN_SIZE_SMALL), // Space between label and date picker
                      // Date Picker Field
                      CustomDateTimeTextField(
                        controller: _depositDateController,
                        hintTxt: 'Select Deposit Date',
                        borderColor: Colors.black12,
                        textInputAction: TextInputAction.next,
                        isTime: false,
                        readyOnly: true,
                        isHideBackDate: false,
                      ),
                    ],
                  ),
                ),*/
                const SizedBox(
                    height: Dimensions
                        .MARGIN_SIZE_SMALL),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Text('Order Items List ',
                            style: titilliumBold.copyWith(
                                color: Colors.purple, fontSize: 18)),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 150.0),
                      child: ElevatedButton(
                        child: Text(
                          addItem?'Add Item':'Add More',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          _onClickAddButton();
                          addItem=false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Text('-Order Details- ',
                            style: titilliumBold.copyWith(
                                color: Colors.purple, fontSize: 18)),
                      ),
                    ),
                  ],
                ),

                // for order / item details
                Container(
                  color: Colors.red.withOpacity(0.2),
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 0.0, bottom: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.red.withOpacity(0.6)),
                        columnSpacing: 8,
                        horizontalMargin: 2,
                        border: TableBorder.all(width: 0.5, color: Colors.grey),
                        showCheckboxColumn: false,
                        columns: _tableHeader(),
                        rows: [
                         /* if (!isViewOnly) ...[
                            _inputDataRow(),
                          ],*/
                          if (provider.salesOrder != null &&
                              provider.salesOrder.orderItemDetail != null) ...[
                            for (var item in provider.salesOrder.orderItemDetail!)
                              _dataRow(item)
                          ]
                        ]),
                  ),
                )
              ]);
            },
          ),
        ),

        // for Submit Button
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.MARGIN_SIZE_LARGE,
              vertical: Dimensions.MARGIN_SIZE_SMALL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.purple.withOpacity(0.2),
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    text: 'Grant Total -- ',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    children: const <TextSpan>[
                      TextSpan(text: 'Total Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' Total Price '),
                    ],
                  ),
                ),
              ),
              !Provider.of<SalesOrderProvider>(context).isLoading
                  ? Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: Text('Clear'),
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _onClickSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        'Balance',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _onClickCustBal();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                  ),
                ],
              )
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ],
          )

        ) //:const SizedBox.shrink(),
      ]),
    );
  }

  void _showErrorDialog(String message) {
    showAnimatedDialog(
        context,
        MyDialog(
          icon: Icons.error,
          title: 'Error',
          description: message,
          rotateAngle: 0,
          positionButtonTxt: 'Ok',
        ),
        dismissible: false);
  }

  void _showCustBalDialog(String message) {
    showAnimatedDialog(
        context,
        MyDialog(
          title: 'Customer Balance',
          description: message,
          rotateAngle: 0,
          positionButtonTxt: 'Ok',
        ),
        dismissible: false);
  }



  /*  Table Header */
  List<DataColumn> _tableHeader() {
    return [
      DataColumn(
          label: Expanded(
        child: Container(
          width: 150,
          height: 50,
          child: Center(
            child: Text(
              'Item Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Container(
          width: 50,
          height: 50,
          child: Center(
            child: Text(
              'Qty',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Container(
          width: 70,
          height: 50,
          child: Center(
            child: Text(
              'Unit Price',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Container(
          width: 80,
          height: 50,
          child: Center(
            child: Text(
              'Total Price',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Ship To Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
        child: Container(
          width: 100,
          height: 50,
          child: Center(
            child: Text(
              'Vehicle Type',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Vehicle Category',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
        child: Container(
          width: 200,
          height: 50,
          child: Center(
            child: Text(
              'Delivery Site Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
      DataColumn(
          label: Expanded(
        child: Container(
          width: 100,
          height: 50,
          child: Center(
            child: Text(
              'Action',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
        ),
      )),
    ];
  }
  /* Data Row */
  DataRow _dataRow(ItemDetail itemDetails) {

    TextEditingController qtyController = TextEditingController();
    TextEditingController deliverySiteDetailController = TextEditingController();
    /*TextEditingController unitPriceController = TextEditingController();TextEditingController _unitPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();TextEditingController _totalPriceController = TextEditingController();*/
    TextEditingController remakes = TextEditingController();
    TextEditingController _remakes = TextEditingController();

    qtyController.text = '${itemDetails.quantity}';
    deliverySiteDetailController.text = '${itemDetails.primaryShipTo}';
 /*   unitPriceController.text = '${itemDetails.unitPrice}';
    totalPriceController.text = '${itemDetails.totalPrice}';
    remakes.text = '${itemDetails.remarks}';*/
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.itemName}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child: itemDetails.isEditable
                ? CustomTextField(
                    controller: qtyController,
                    width: 100,
                    height: 50,
                    hintText: 'Qty',
                    borderColor: Colors.black12,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        itemDetails.quantity = int.parse(value.isEmpty ? '0' : value);
                        itemDetails.totalPrice = (itemDetails.quantity! * itemDetails.unitPrice!).toDouble();
                      });
                    },
                  )
                : Text('${itemDetails.quantity}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.unitPrice}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.totalPrice}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.shipToLocation}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.vehicleType}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.vehicleCate}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child: itemDetails.isEditable
                ? CustomTextField(
                    controller: deliverySiteDetailController,
                    width: 200,
                    height: 50,
                    maxLine: 3,
                    hintText: 'Delivery Site Details',
                    borderColor: Colors.black12,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      itemDetails.remarks = value;
                    },
                  )
                : Text('${itemDetails.remarks}')),
      )),

      DataCell(Padding(
        padding: const EdgeInsets.only(right: 2.0, top: 5.0, bottom: 5.0),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (itemDetails.isEditable) ...[
              InkWell(
                  onTap: () => _editItemDetail(itemDetails.itemId??0, false),
                  child: Icon(
                    Icons.done,
                    color: Colors.green,
                  ))
            ] else ...[
              InkWell(
                  onTap: () => _editItemDetail(itemDetails.itemId??0, true),
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
              InkWell(
                  onTap: () => _deleteItemDetail(itemDetails.itemId,itemDetails.quantity),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ))
            ]
          ],
        )),
      ))
    ]);
  }



  /* Input Data Row */
  DataRow _inputDataRow() {

    return DataRow(
        color: WidgetStateColor.resolveWith(
            (states) => Colors.blueAccent.withOpacity(0.3)),
        cells: [
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomDropdownButton(
              buttonHeight: 45,
              buttonWidth: 150,
              dropdownWidth: 200,
              hint: 'Select Item',
              hintColor: Colors.black87,
              dropdownItems: _itemsDropDown,
              value: _selectedItem,
              buttonBorderColor:
                  _customerFieldError ? Colors.red : Colors.black87,
              onChanged: (item) {
                setState(() {
                  //_selectCompanyError = false;
                  _selectedItem = item;
                  //_itemId = value?.id??0;
                  _itemId = item?.id??0;
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomAutoComplete(
              dropdownItems: _shipToLocationDropDown,
              value: _shipToSiteController != null
                  ? _shipToSiteController!.text
                  : '',
              icon: const Icon(Icons.search),
              dropdownWidth: 200,
              hint: 'Select Ship Name',
              hintColor: Colors.black87,
              borderColor: Colors.transparent,
              onReturnTextController: (textController) => _shipToSiteController = textController,
              onChanged: (value) {
                setState(() {
                  //_selectCompanyError = false;
                  //_selectedShipToLocation = value;
                  _shipToSiteId = value.code??'';
                  _shipToLocation = value.name??'';
                  _primaryShipTo = value.nameBl??'';
                  _salesPersonId = value.description??'';
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomTextField(
              width: 100,
              height: 50,
              controller: _qtyController,
              hintText: 'Qty',
              //focusNode: _qtyNode,
              //nextNode: _unitPriceNode,
              borderColor: Colors.black12,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                _onClickItemPrice(_itemId,_shipToSiteId);
                /*setState(() {
                  // _selectCompanyError = false;
                 // _onClickItemPrice(_itemId,_shipToSiteId);
                });*/
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Center(child: Text('$itemPriceInt')),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Center(child: Text('$totalPriceInt')),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomDropdownButton(
              buttonHeight: 45,
              buttonWidth: 150,
              dropdownWidth: 200,
              hint: 'Select Vehicle Type',
              hintColor: Colors.black87,
              dropdownItems: _vehicleTypesDropDown,
              value: _selectedVehicleType,
              buttonBorderColor:
                  _customerFieldError ? Colors.red : Colors.black87,
              onChanged: (value) async{
                _vehicleCatDropDown =  await Provider.of<SalesOrderProvider>(context, listen: false).getVehicleCategoryByType(value?.code??'');
                setState((){
                  // _selectCompanyError = false;
                  _vehicleType = value?.name??'';
                  _selectedVehicleType = value;
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomDropdownButton(
              buttonHeight: 45,
              buttonWidth: 150,
              dropdownWidth: 200,
              hint: 'Select Vehicle Category',
              hintColor: Colors.black87,
              dropdownItems: _vehicleCatDropDown,
              value: _selectedVehicleCat,
              buttonBorderColor:
              _customerFieldError ? Colors.red : Colors.black87,
              onChanged: (value) {
                setState(() {
                  // _selectCompanyError = false;
                  _vehicleCate = value?.name??'';
                  _selectedVehicleCat = value;
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomTextField(
              width: 200,
              height: 50,
              maxLine: 3,
              controller: _deliverySiteDetailController,
              hintText: 'Delivery Site Details',
              //focusNode: _qtyNode,
              //nextNode: _unitPriceNode,
              borderColor: Colors.black12,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          )),
          //action Add method
          DataCell(Padding(
            padding: const EdgeInsets.only(right: 2.0, top: 5.0, bottom: 5.0),
            child: CustomButtonWithIcon(
              onTap: () {
                _onClickAddButton();
              },
              color: Colors.lightGreenAccent,
              buttonText: '',
              icon: Icons.add,
            ),
          ))
        ]);
  }

  _editItemDetail(int itemId, bool bool) {
    Provider.of<SalesOrderProvider>(context,listen: false).EditableSalesOrderItem(itemId,bool);
  }

  _deleteItemDetail(int? itemId, int? count) async {
   // print(' itemId $itemId count $count');
    var isSubmit = await showAnimatedDialog(context, MyDialog(
      title: '',
      description: 'Are you sure you want to delete the item?',
      rotateAngle: 0,
      negativeButtonTxt: 'No',
      positionButtonTxt: 'Yes',
    ), dismissible: false);

    if(!isSubmit!) return;

    Provider.of<SalesOrderProvider>(context,listen: false).deleteSalesOrderItem(itemId??0, count??0);
  }

  _showMessage(String message, bool isError){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError?Colors.red:Colors.green,
    ));
  }

}
