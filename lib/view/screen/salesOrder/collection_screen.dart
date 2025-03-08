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
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/my_dialog.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../../basewidget/textfield/custom_textfield.dart';
import '../home/dashboard_screen.dart';
import 'dart:developer' as developer;

class CollectionScreen extends StatefulWidget {
  final bool isBackButtonExist;

  const CollectionScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  TextEditingController? _customerController;
  TextEditingController? _shipToSiteController;
  TextEditingController? _orgNameController;
  TextEditingController? _cusPONoController;
  TextEditingController? _depositDateController;

  Customer? _selectedCustomer;

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

  bool _customerFieldError = false;


  //SalesOrder? _salesOrder;

  String _orgName = '';
  String _warehouseId = '';
  String _custId = '';
  String _freightTerms = '';
  String _shipToSiteId = '';
  int _itemId = 0;
  String formattedDate = '';
  String customerBal ='';
  int itemPriceInt = 0;
  int totalPriceInt = 0;

  String _vehicleType ='';
  String _vehicleCate ='';

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController();
    _orgNameController = TextEditingController();
    _depositDateController = TextEditingController();
    _cusPONoController = TextEditingController();
    _intData();
  }

  void _intData() async {
    currentDateTime();
    Provider.of<SalesOrderProvider>(context, listen: false).clearSalesOrderItem();
    _orgName = Provider.of<AuthProvider>(context, listen: false).getOrgName();
    _orgNameController?.text = _orgName ?? '';
    _depositDateController?.text = formattedDate ?? '';
    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerAndItemListAndOthers(context);
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

  Future<void> _onClickSubmit() async {

    _customerFieldError = false;

    if (_selectedCustomer == null) {
      _customerFieldError = true;
      _showMessage('Select Customer!',true);
      return;
    }


    /*if(_freightTerms == null || _freightTerms.isEmpty){
      _showErrorDialog("Select Freight Terms");
      return;
    }

    if(_itemId == null || _itemId <= 0){
      _showErrorDialog("Select Item");
      return;
    }

    if(_shipToSiteId == null || _shipToSiteId.isEmpty){
      _showErrorDialog("Select Ship to Location");
      return;
    }
    if(_vehicleType == null){
      _showMessage('Select Vehicle Type',true);
      return;
    }*/

    var isSubmit = await showAnimatedDialog(context, MyDialog(
      title: '',
      description: 'Are you sure you want to submit your Collection?',
      rotateAngle: 0,
      negativeButtonTxt: 'No',
      positionButtonTxt: 'Yes',
    ), dismissible: false);

    if(!isSubmit!) return;

    SalesOrder? salesInfoModel = Provider.of<SalesOrderProvider>(context, listen: false).salesOrder;
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
    salesInfoModel.orderType = _selectedCustomer?.orderType;
    salesInfoModel.orderTypeId = _selectedCustomer?.orderTypeId;
    salesInfoModel.freightTerms = _freightTerms;
    salesInfoModel.orderDate = formattedDate;
    salesInfoModel.warehouseId = _warehouseId;
    salesInfoModel.warehouseName = _selectedWareHouse?.name;

    salesInfoModel.customerPoNumber = _cusPONoController?.text;


    developer.log(salesInfoModel.toJson().toString());

    await Provider.of<SalesOrderProvider>(context, listen: false).salesOrderSubmit(context, salesInfoModel).then((status) async {

      if(status){
        _customerController?.text= '';
        if(_shipToSiteController!=null) {
          _shipToSiteController!.text = '';
        }
        _selectedCustomer = null;
        _warehouseId = '';
        _custId = '';
      }


      bool? action = await showAnimatedDialog(context, MyDialog(
        title: status?'Successfully submitted your order':"Fail, Please try again",
        description: 'Are you sure you want to submit your order?',
        rotateAngle: 0,
        negativeButtonTxt: 'Again Order',
        positionButtonTxt: 'Go To Home',
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
            title: 'Collection Page',
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

              /*if (_orderTypeDropDown == null || _orderTypeDropDown.isEmpty) {
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
                    )));*/
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
                            Icons.home_outlined,
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
                              height: 35,
                              width: width,
                              dropdownHeight: 300,
                              dropdownWidth: width - 40,
                              borderColor: _customerFieldError?Colors.red:Colors.transparent,
                              onReturnTextController: (textController) =>
                                  _customerController = textController,
                              onClearPressed: () {
                                setState(() {
                                  _selectedCustomer = null;
                                  //_warehouseId = '';
                                  _custId = '';
                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());

                                //_selectedShipToLocation = null;
                                _shipToLocationDropDown = [];

                                if(_shipToSiteController!=null) {
                                  _shipToSiteController!.text = '';
                                }

                                for (Customer customer in provider.customerList) {
                                  if (customer.customerId == value.code) {

                                    provider.salesOrder.customerId = customer.customerId;
                                    provider.salesOrder.customerName = customer.customerName;

                                    _selectedCustomer = customer;
                                    _custId = _selectedCustomer?.customerId ?? '';
                                    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, _custId);

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
                            text: 'Account',
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
                              hint: 'Select a bank account',
                              value: _customerController != null
                                  ? _customerController!.text
                                  : '',
                              icon: const Icon(Icons.search),
                              height: 35,
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
                                  _warehouseId = '';
                                  _custId = '';
                                  _freightTerms = '';
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
                                  _shipToSiteController!.text = '';
                                }

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
                                    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, _custId);
                                    _warehouseId = _selectedCustomer?.warehouseId ?? '';
                                    _freightTerms =  _selectedCustomer?.freightTerms ?? '';
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
                            text: 'Deposit No *',
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
                              height: 35,
                              controller: _cusPONoController,
                              hintText: 'Enter Deposit Number',
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
                            text: 'Instrument No *',
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
                              height: 35,
                              controller: _cusPONoController,
                              hintText: 'Enter Instrument Number',
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
                ),
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
                            text: 'Remarks*',
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
                              height: 35,
                              controller: _cusPONoController,
                              hintText: 'Enter Remarks',
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
                            text: 'Amount',
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
                              controller: _cusPONoController,
                              hintText: 'Enter Amount',
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
              ]);
            },
          ),
        ),

        // for Submit Button
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.MARGIN_SIZE_LARGE,
              vertical: Dimensions.MARGIN_SIZE_SMALL),
          child: !Provider.of<SalesOrderProvider>(context).isLoading
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
                    /*Expanded(
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

                    ),*/
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
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


  _showMessage(String message, bool isError){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError?Colors.red:Colors.green,
    ));
  }

}
