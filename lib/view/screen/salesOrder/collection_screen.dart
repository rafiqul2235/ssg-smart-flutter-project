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
import '../../../data/model/body/collection.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/salesorder/customer.dart';
import '../../../provider/auth_provider.dart';
import '../../../utill/number_formatter.dart';
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
  TextEditingController? _bankAccountController;
  TextEditingController? _orgNameController;
  TextEditingController? _depositNoController;
  //TextEditingController? _depositDateController;
  TextEditingController? _instrumentNoController;
  TextEditingController? _remarksController;
  TextEditingController? _amountController;

  Customer? _selectedCustomer;

  List<DropDownModel> _customersDropDown = [];
  DropDownModel? _selectedCustomerDropDown;

  List<DropDownModel> _bankAccountsDropDown = [];
  DropDownModel? _selectedBankAccount;

  List<DropDownModel> _modesDropDown = [];
  DropDownModel? _selectedModes;


  bool isViewOnly = false;

  bool _customerFieldError = false;

  //SalesOrder? _salesOrder;

  String _orgName = '';
  String _userId= '';
  String _warehouseId = '';
  String _custId = '';
  String _modes = '';
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
    _bankAccountController = TextEditingController();
    _orgNameController = TextEditingController();
    //_depositDateController = TextEditingController();
    _instrumentNoController = TextEditingController();
    _remarksController = TextEditingController();
    _amountController = TextEditingController();
    _depositNoController = TextEditingController();
    _intData();
    _setupCommaFormatting(_amountController!);
  }

  void _intData() async {
    currentDateTime();
    Provider.of<SalesOrderProvider>(context, listen: false).clearSalesOrderItem();
    _orgName = Provider.of<AuthProvider>(context, listen: false).getOrgName();
    _orgNameController?.text = _orgName ?? '';
    //_depositDateController?.text = formattedDate ?? '';
    Provider.of<SalesOrderProvider>(context, listen: false).getCollectionInformation(context);
    _userId = Provider.of<AuthProvider>(context, listen: false).getUserId();
  }

  void _setupCommaFormatting(TextEditingController controller) {
    controller.addListener((){
      final text = controller.text;
      final formatted = NumberFormatterUtil.format(text);
      if (text != formatted) {
        controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length)
        );
      }
    });
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
      _showErrorDialog('Select Customer!');
      return;
    }

    if(_selectedBankAccount == null){
      _showErrorDialog("Select Bank Account");
      return;
    }

    if(_selectedModes == null){
      _showErrorDialog("Select Mode");
      return;
    }

    /*if(_depositNoController == null || _depositNoController!.text.isEmpty){
      _showErrorDialog("Enter Deposit No");
      return;
    }

    if(_instrumentNoController == null || _instrumentNoController!.text.isEmpty){
      _showErrorDialog("Enter Instrument No");
      return;
    }*/

    if(_amountController == null || _amountController!.text.isEmpty){
      _showErrorDialog("Enter Amount");
      return;
    }
    var amountText = _amountController?.text ?? '';
    var isSubmit = await showAnimatedDialog(context, MyDialog(
      title: '',
      description: 'Your Collection Amount $amountText\n Are you sure you want to submit your collection?',
      rotateAngle: 0,
      negativeButtonTxt: 'No',
      positionButtonTxt: 'Yes',
    ), dismissible: false);

    if(!isSubmit!) return;

    Collection? collection = Collection();
    collection.customerId = _selectedCustomer?.customerId;
    collection.salesPersonId = _selectedCustomer?.salesPersonId;
    collection.orgId = _selectedCustomer?.orgId;
    collection.userId=_userId;
    collection.bankAccountId = _selectedBankAccount?.code??'';
    collection.bankAccountName = _selectedBankAccount?.name??'' ;
    collection.receiptMethodId = _selectedBankAccount?.description??'' ;
    collection.receiptMethod = _selectedBankAccount?.nameBl??'';
    collection.remitBankAcctUseId = _selectedBankAccount?.type??'';
    collection.collMode = _selectedModes?.code??'';
    collection.instrument = _instrumentNoController?.text??'';
    collection.remarks = _remarksController?.text??'';
    collection.depositNo = _depositNoController?.text??'';
    collection.collAmount = NumberFormatterUtil.unformat(_amountController?.text??'0');
    collection.billToSiteId = _selectedCustomer?.billToSiteId??'';
    collection.billToSiteAddress = _selectedCustomer?.billToAddress??'';
    collection.custAmount = NumberFormatterUtil.unformat(_amountController?.text??'0');

    developer.log(collection.toJson().toString());

    await Provider.of<SalesOrderProvider>(context, listen: false).collectionSubmit(context, collection).then((status) async {

      if(status){
        _customerController?.text= '';
        _bankAccountController?.text= '';
        _selectedBankAccount = null;
        _selectedCustomer = null;
        _selectedModes = null;
        _instrumentNoController?.text = '';
        _remarksController?.text = '';
        _depositNoController?.text = '';
        _amountController?.text = '';
        _custId = '';
      }

      bool? action = await showAnimatedDialog(context, MyDialog(
        title: status?'Successfully submitted your collection':"Fail, Please try again",
        description: 'Are you want to Submit another Collection?',
        rotateAngle: 0,
        negativeButtonTxt: 'Yes',
        positionButtonTxt: 'No',
      ), dismissible: false);

      if(action!){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const DashBoardScreen()));
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    //final freightTerm = Provider.of<SalesOrderProvider>(context).freightTermsList;
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
                        code: element.customerId,
                        name: element.customerName
                    )));
              }

              if (_bankAccountsDropDown == null || _bankAccountsDropDown.isEmpty) {
                _bankAccountsDropDown = [];
                provider.bankInfoList.forEach((element) =>
                    _bankAccountsDropDown.add(DropDownModel(
                        code: element.bankAccountId,
                        name: element.bankAccountName,
                        nameBl: element.receiptMethod,
                        description: element.receiptMethodId,
                        type: element.remitBankAccountUseId
                    )));
              }

              if (_modesDropDown == null || _modesDropDown.isEmpty) {
                _modesDropDown = [];
                provider.modesList.forEach((element) =>
                    _modesDropDown.add(DropDownModel(code: element, name: element)));
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
               /* Container(
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
                ),*/

                // for Customer
                Container(
                  margin: const EdgeInsets.only(
                    //top: Dimensions.MARGIN_SIZE_DEFAULT,
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
                                  _selectedCustomer = null;
                                  _custId = '';
                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());

                                for (Customer customer in provider.customerList) {
                                  if (customer.customerId == value.code) {
                                    provider.salesOrder.customerId = customer.customerId;
                                    provider.salesOrder.customerName = customer.customerName;
                                    _selectedCustomer = customer;
                                    _custId = _selectedCustomer?.customerId ?? '';
                                    /*Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, _custId);*/
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

                //Account / Bank
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
                              dropdownItems: _bankAccountsDropDown,
                              hint: 'Select a bank account',
                              value: _bankAccountController != null
                                  ? _bankAccountController!.text
                                  : '',
                              icon: const Icon(Icons.search),
                              height: 45,
                              width: width,
                              dropdownHeight: 300,
                              dropdownWidth: width - 40,
                              borderColor: _customerFieldError?Colors.red:Colors.transparent,
                              onReturnTextController: (textController) =>
                              _bankAccountController = textController,
                              onClearPressed: () {
                                setState(() {
                                  _selectedBankAccount = null;
                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                _selectedBankAccount = value;
                               // setState(() { });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // for Modes
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
                            text: 'Modes',
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
                        hint: _modes,
                        hintColor: Colors.black,
                        dropdownItems: _modesDropDown,
                        value: _selectedModes,
                        buttonBorderColor: Colors.black12,
                        onChanged: (value) {
                          setState(() {
                            _modes = value?.code??'0';
                            _selectedModes = value;
                          });
                        },
                      ),

                    ],
                  ),
                ),

                // for Deposit No
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
                              height: 45,
                              controller: _depositNoController,
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

                //Instrument No
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
                          const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
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
                              height: 45,
                              controller: _instrumentNoController,
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

                //Order Date
               /* Container(
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
                ),*/
                // Remarks
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
                              height: 45,
                              controller: _remarksController,
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
                //Amount
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
                              height: 45,
                              controller: _amountController,
                              hintText: 'Enter Amount',
                              borderColor: Colors.black12,
                              textInputType: TextInputType.number,
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
                      horizontal: Dimensions.MARGIN_SIZE_SMALL,
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
                )
              ]);
            },
          ),
        ),

        // for Submit Button
       //:const SizedBox.shrink(),
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
