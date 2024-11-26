import 'package:ssg_smart2/data/model/body/sales_order.dart';
import 'package:ssg_smart2/data/model/response/available_cust_balance.dart';
import 'package:ssg_smart2/data/model/response/customer_balance.dart';
import 'package:ssg_smart2/data/model/response/notification_model.dart';
import 'package:flutter/material.dart';
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
  TextEditingController? _CusPONoController;
  TextEditingController? _depositDateController;
  TextEditingController? _qtyController;
  TextEditingController? _deliverySiteDetailController;

  Customer? _selectedCustomer;
  CustomerBalanceModel? _balanceModel;
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

  List<DropDownModel> _shipToLocationDropDown = [];
  DropDownModel? _selectedShipToLocation;

  bool _selectCompanyError = false;
  bool isViewOnly = false;

  //SalesOrder? _salesOrder;

  String _orgName = '';
  String _warehouse = '';
  String _custId = '';
  String _freightTerms = '';
  String formattedDate = '';
  String customerBal ='';

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController();
    _orgNameController = TextEditingController();
    _depositDateController = TextEditingController();
    _qtyController = TextEditingController();
    _deliverySiteDetailController = TextEditingController();
    _intData();
  }

  void _intData() async {
    currentDateTime();
    final salesProvider =
        Provider.of<SalesOrderProvider>(context, listen: false)
            .getCustomerAndItemListAndOthers(context);
    _orgName = Provider.of<AuthProvider>(context, listen: false).getOrgName();
    _orgNameController?.text = _orgName ?? '';
    _depositDateController?.text = formattedDate ?? '';
    Provider.of<SalesOrderProvider>(context, listen: false)
        .getCustomerAndItemListAndOthers(context);
    //Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, '3138');
  }

  void currentDateTime() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Print the current date
    print(
        "Current Date: ${now.toLocal()}"); // Outputs: YYYY-MM-DD HH:MM:SS.mmmuuu

    // If you want only the date (DD-MM-YYYY)
    formattedDate =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    print("Formatted Date: $formattedDate"); // Outputs: DD-MM-YYYY
  }

  @override
  Widget build(BuildContext context) {
    final freightTerm =
        Provider.of<SalesOrderProvider>(context).freightTermsList;
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
                    DropDownModel(id: element.itemId, name: element.itemName)));
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

              if (_shipToLocationDropDown == null ||
                  _shipToLocationDropDown.isEmpty) {
                _shipToLocationDropDown = [];
                provider.customerShipToLocationList.forEach((element) =>
                    _shipToLocationDropDown.add(DropDownModel(
                        code: element.shipToSiteId,
                        name: element.shipToLocation)));
              }

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
                              borderColor: Colors.transparent,
                              onReturnTextController: (textController) =>
                                  _customerController = textController,
                              onClearPressed: () {
                                setState(() {
                                  _selectedCustomer = null;
                                  _warehouse = '';
                                  _custId = '';
                                  _freightTerms = '';
                                  _selectedWareHouse = null;
                                  _selectedFreightTerms = null;
                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                for (Customer customer
                                    in provider.customerList) {
                                  if (customer.customerId == value?.code) {
                                    _selectedCustomer = customer;
                                    _custId =
                                        _selectedCustomer?.customerId ?? '';
                                    Provider.of<SalesOrderProvider>(context,
                                            listen: false)
                                        .getCustomerShipToLocation(
                                            context, _custId);
                                    _warehouse =
                                        _selectedCustomer?.warehouseName ?? '';
                                    _freightTerms =
                                        _selectedCustomer?.freightTerms ?? '';
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
                              height: 35,
                              controller: _CusPONoController,
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
                            Icons.person,
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
                            : '',
                        icon: const Icon(Icons.search),
                        height: 35,
                        width: width,
                        hint: _warehouse,
                        hintColor: Colors.black,
                        dropdownHeight: 300,
                        dropdownWidth: width - 40,
                        borderColor: Colors.transparent,
                        onReturnTextController: (textController) =>
                            _warehouseController = textController,
                        onChanged: (value) {
                          setState(() {
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
                            Icons.person,
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
                        buttonHeight: 35,
                        buttonWidth: double.infinity,
                        dropdownWidth: width - 40,
                        hint: _freightTerms,
                        hintColor: Colors.black,
                        dropdownItems: _freightTermsDropDown,
                        value: _selectedFreightTerms,
                        buttonBorderColor: Colors.black12,
                        onChanged: (value) {
                          setState(() {
                            _selectedFreightTerms = value;
                          });
                        },
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

                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                  child: Center(
                      child: Text('- Order Details - ',
                          style: titilliumBold.copyWith(
                              color: Colors.purple, fontSize: 18))),
                ),

                // for order / item details
                Container(
                  color: Colors.red.withOpacity(0.3),
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 0.0, bottom: 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.red.withOpacity(0.2)),
                        columnSpacing: 8,
                        horizontalMargin: 2,
                        border: TableBorder.all(width: 0.5, color: Colors.grey),
                        showCheckboxColumn: false,
                        columns: _tableHeader(),
                        rows: [
                          if (!isViewOnly) ...[
                            _inputDataRow(),
                          ],
                          if (provider.salesOrder != null &&
                              provider.salesOrder.orderItemDetail != null) ...[
                            for (var item
                                in provider.salesOrder.orderItemDetail!)
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
        ) //:const SizedBox.shrink(),
      ]),
    );
  }



  Future<void> _onClickSubmit() async {
    if (_selectedCustomer == null) {
      _showErrorDialog("Select Customer Name");
      return;
    }

    final salesProviderAvailable = Provider.of<SalesOrderProvider>(context, listen: false);
    await salesProviderAvailable.getCustAvailBalance(context, '$_custId');
    _availableBalanceModel = salesProviderAvailable.availCustBalance;
    final availableCustBal = _availableBalanceModel!.customerBalance;
    print("Available customer Balance : $availableCustBal");

    if (availableCustBal == '71953') {
      _showErrorDialog("Insufficient Customer Balance");
      return;
    }



    /*if(_selectedWareHouse == null ){
      _showErrorDialog("Warehouse is Emty");
      return;
    }*/

    /* if(_selectedFreightTerms == null ){
      _showErrorDialog("Warehouse is Emty");
      return;
    }*/

    SalesOrder? salesInfoModel =
        Provider.of<SalesOrderProvider>(context, listen: false).salesOrder;
    SalesDataModel salesDataModel = SalesDataModel(
      custId: _selectedCustomer?.customerId,
      selesrepId: _selectedCustomer?.salesPersonId,
      orgId: _selectedCustomer?.orgId,
      billToSiteId: _selectedCustomer?.billToSiteId,
      billToAddress: _selectedCustomer?.billToAddress,
      orderTypeId: _selectedCustomer?.orderTypeId,
      orderType: _selectedCustomer?.orderType,
      freightTerm: _selectedCustomer?.freightTerms,
      freightTermId: _selectedCustomer?.freightTermsId,
      wareHouseId: _selectedCustomer?.warehouseId,
      orderDate: "24-12-2024",
      priceListId: _selectedCustomer?.priceListId,
      primaryShipToSiteId: _selectedCustomer?.priceListId,
    );
    print("Sales data: $salesDataModel");
    final salesProvider =
        Provider.of<SalesOrderProvider>(context, listen: false);
    await salesProvider.salesOrderSubmit(context, salesDataModel);

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
          width: 100,
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
          width: 100,
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
          width: 100,
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
    TextEditingController deliverySiteDetailController =
        TextEditingController();

    qtyController.text = '${itemDetails.quantity}';
    deliverySiteDetailController.text = '${itemDetails.primaryShipTo}';

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
                      itemDetails.quantity = value.isEmpty ? '0' : value;
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
                      itemDetails.primaryShipTo = value;
                    },
                  )
                : Text('${itemDetails.primaryShipTo}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(right: 2.0, top: 5.0, bottom: 5.0),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (itemDetails.isEditable) ...[
              InkWell(
                  onTap: () => _editItemDetail(itemDetails.itemId,
                      itemDetails.itemId, itemDetails.customerId, false),
                  child: Icon(
                    Icons.done,
                    color: Colors.green,
                  ))
            ] else ...[
              InkWell(
                  onTap: () => _editItemDetail(itemDetails.itemId,
                      itemDetails.orgId, itemDetails.customerId, true),
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
              InkWell(
                  onTap: () => _deleteItemDetail(itemDetails.itemId,
                      itemDetails.itemId, itemDetails.customerId),
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
                  _selectCompanyError ? Colors.red : Colors.black87,
              onChanged: (value) {
                setState(() {
                  //_selectCompanyError = false;
                  _selectedItem = value;
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
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Center(child: Text('632')),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Center(child: Text('521541')),
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
              onReturnTextController: (textController) =>
                  _shipToSiteController = textController,
              onChanged: (value) {
                setState(() {
                  //_selectCompanyError = false;
                  _selectedShipToLocation = value;
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
              hint: 'Select Vehicle Type',
              hintColor: Colors.black87,
              dropdownItems: _vehicleTypesDropDown,
              value: _selectedVehicleType,
              buttonBorderColor:
                  _selectCompanyError ? Colors.red : Colors.black87,
              onChanged: (value) {
                setState(() {
                  // _selectCompanyError = false;
                  _selectedVehicleType = value;
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
          DataCell(Padding(
            padding: const EdgeInsets.only(right: 2.0, top: 5.0, bottom: 5.0),
            child: CustomButtonWithIcon(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                //_addItem();
              },
              color: Colors.transparent,
              buttonText: '',
              icon: Icons.add,
            ),
          ))
        ]);
  }

  _editItemDetail(masterId, detailsId, company, bool bool) {}

  _deleteItemDetail(masterId, detailsId, company) {}

  _submitButton() {}
}
