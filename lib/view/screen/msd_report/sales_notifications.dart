import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/attendence/widget/attendance_summary_table.dart';
import 'package:ssg_smart2/view/screen/msd_report/msd_report_model.dart';
import '../../../data/model/body/customer_details.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/attachment_provider.dart';
import '../../../provider/attendance_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/my_dialog.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class SalesNotifications extends StatefulWidget {
  final bool isBackButtonExist;
  const SalesNotifications({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<SalesNotifications> createState() => _SalesNotificationsState();
}

class _SalesNotificationsState extends State<SalesNotifications> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  DropDownModel? selectedSpCustList;
  bool isSpCustListFieldError = false;

  CustomerDetails? _selectedCustomer;
  List<CustomerDetails> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();


  UserInfoModel? userInfoModel;
  bool _showResult = false;

  List<String> _reportTypes = [
    'Collection',
    'Sales',
    'Delivery Request',
    'Pending SO',
    'Customer PI, Cr. Memo etc.'
  ];
  String? _selectedReportType;
  late String cust_id;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }




  @override
  void initState() {
    super.initState();
    _intData();

    //Provider.of<SalesOrderProvider>(context, listen: false).getSpCustList(context);

    DateTime now = DateTime.now();
    _endDateController.text = DateFormat('dd-MM-yyyy').format(now);
    _startDateController.text = DateFormat('dd-MM-yyyy').format(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalesOrderProvider>(context, listen: false)
          .clearSalesOrder();
    });
  }

  _intData() async {
    // Provider.of<UserProvider>(context, listen: false).resetLoading();
    userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    print("userinfo: ${userInfoModel}");
    final provider = Provider.of<AttachmentProvider>(context, listen: false);
    provider.fetchAitEssentails(userInfoModel!.orgId!, userInfoModel!.salesRepId!);
    //provider.fetchAitEssentails('100002083','101');

    setState(() {});
  }


  void _showCustomerDialog(List<CustomerDetails> customers) {
    _filteredCustomers = customers;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      'Select Customer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey[50],
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Filter customer baseed on search text
                          _filteredCustomers = customers.where((customer) {
                            final customerName = customer.customarName?.toLowerCase() ?? '';
                            final accountNumber = customer.accountNumber?.toLowerCase() ?? '';
                            final searchText = value.toLowerCase();
                            return customerName.contains(searchText) || accountNumber.contains(searchText);
                          }).toList();
                        });
                      },
                    ),
                  ],
                ),
                content: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${_filteredCustomers[index].customarName!}(${_filteredCustomers[index].accountNumber})',
                          style: TextStyle(fontSize: 16),
                        ),
                        leading: Icon(Icons.business),
                        selected: customers[index] == _selectedCustomer,
                        selectedTileColor: Colors.blue.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCustomer = _filteredCustomers[index];
                          });
                          this.setState(() {});
                          Navigator.pop(context);
                          _searchController.clear();
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _searchController.clear();
                    },
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
  InputDecoration _buildInputDecoration(String hint, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      errorStyle: TextStyle(height: 0.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttachmentProvider>();
    final customers = provider.customersList;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Sales Report Page',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                    const DashBoardScreen()));
              }),

          Consumer<SalesOrderProvider>(
            builder: (context, salesOrderProvider, child) {
              return Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    // 🔹 First Dropdown (Report Type)
                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    Row(
                      children: [
                        Icon(Icons.streetview, color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Report Type', mandatoryText: '*', textStyle: titilliumRegular),
                      ],
                    ),
                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    DropdownButton2<String>(
                      buttonStyleData: ButtonStyleData(
                        height: 45,
                        width: double.infinity,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: MediaQuery.of(context).size.width - 40,
                      ),
                      hint: Text('Select Report Type'),
                      items: _reportTypes.map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      )).toList(),
                      value: _selectedReportType,
                      onChanged: (value) {
                        setState(() {
                          _selectedReportType = value;
                          // Reset result visibility when selection changes
                          _showResult = false;
                        });
                      },
                    ),



                    const SizedBox(height: 10),

                    // 🔹 Second Dropdown (Customer Name)
                    /*Row(
                      children: [
                        Icon(Icons.streetview, color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Customer Name', mandatoryText: '*', textStyle: titilliumRegular),
                      ],
                    ),

                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    CustomDropdownButton(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      dropdownWidth: MediaQuery.of(context).size.width - 40,
                      hint: 'Select Customer Name',
                      dropdownItems: salesOrderProvider.SpCustList,
                      value: selectedSpCustList,
                      buttonBorderColor: isSpCustListFieldError ? Colors.red : Colors.black12,
                      onChanged: (value) {
                        setState(() {
                          selectedSpCustList = value;
                          // Reset result visibility when selection changes
                          _showResult = false;
                        });
                      },
                    ),*/

                    Row(
                      children: [
                        Icon(Icons.streetview, color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Customer Name', mandatoryText: '*', textStyle: titilliumRegular),
                      ],
                    ),
                    const SizedBox(height: 10),

                  //  _buildFormLabel('Customer Name *'),
                    TextFormField(
                      readOnly: true,
                      decoration: _buildInputDecoration(
                        _selectedCustomer?.customarName ?? 'Select customer',
                        Icons.business_outlined,
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      onTap: () => _showCustomerDialog(customers),
                      validator: (value) {
                        if (_selectedCustomer == null) {
                          return 'Please select a customer';
                        }
                        return null;
                      },
                    ),

                  ],

                ),

              );

            },
          ),



          // Date Inputs
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Start Date
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.date_range,
                                color: ColorResources.getPrimary(context),
                                size: 20),
                            const SizedBox(
                                width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(
                                text: 'From Date',
                                mandatoryText: '*',
                                textStyle: titilliumRegular),
                          ],
                        ),
                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                        CustomDateTimeTextField(
                          controller: _startDateController,
                          focusNode: _startDateFocus,
                          nextNode: _endDateFocus,
                          textInputAction: TextInputAction.next,
                          isTime: false,
                          readyOnly: false,
                          onChanged: (value) {
                            // Reset result visibility when date changes
                            setState(() {
                              _showResult = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // End Date
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.date_range,
                                color: ColorResources.getPrimary(context),
                                size: 20),
                            const SizedBox(
                                width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(
                                text: 'To Date',
                                mandatoryText: '*',
                                textStyle: titilliumRegular),
                          ],
                        ),
                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                        CustomDateTimeTextField(
                          controller: _endDateController,
                          focusNode: _endDateFocus,
                          textInputAction: TextInputAction.next,
                          isTime: false,
                          readyOnly: false,
                          onChanged: (value) {
                            // Reset result visibility when date changes
                            setState(() {
                              _showResult = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Submit Button

          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.MARGIN_SIZE_LARGE,
              vertical: Dimensions.MARGIN_SIZE_SMALL,
            ),
            child: CustomButton(
              onTap: () {
                if (_selectedReportType == null) {
                  _showErrorDialog('Please select a Report Type');
                  return;
                }
                /*if (selectedSpCustList == null) {
                  _showErrorDialog('Please select a Customer');
                  return;
                }*/

                final provider = Provider.of<SalesOrderProvider>(context, listen: false);
                UserInfoModel? userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;

                // Clear previous data before fetching new data
                provider.clearSalesOrder();

                provider.fetchSalesNotification(
                    userInfoModel!.salesRepId!,
                    //'3138',
                    _selectedCustomer!.customerId ?? '',
                    //selectedSpCustList!.code ?? '',
                    _startDateController.text,
                    _endDateController.text,
                    _selectedReportType ?? ''
                );
                setState(() {
                  _showResult = true;
                });
              },
              buttonText: 'SUBMIT',
            ),
          ),

          Expanded(
            child: Consumer<SalesOrderProvider>(
              builder: (context, provider, child) {
                if (!_showResult) {
                  return SizedBox.shrink();
                }
                else if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (provider.salesNotification.isEmpty) {
                  return NoInternetOrDataScreen(isNoInternet: false);
                }
                else {
                  return ListView.builder(
                    itemCount: provider.salesNotification.length,
                    itemBuilder: (context, index) {
                      final approval = provider.salesNotification[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.blue,
                          child: InkWell(
                            splashColor: Colors.blue.withOpacity(0.1),
                            onTap: () {
                              debugPrint("Card is pressed");
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                top(context, approval),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget top(BuildContext context, MsdReportModel msdReportModel) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[50]!, Colors.orange[50]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${msdReportModel.msg_date}",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "${msdReportModel.msg}",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showCustBalDialog(String message) {
    showAnimatedDialog(
        context,
        MyDialog(
          title: 'Attention!',
          description: message,
          rotateAngle: 0,
          positionButtonTxt: 'Ok',
        ),
        dismissible: false);
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
}