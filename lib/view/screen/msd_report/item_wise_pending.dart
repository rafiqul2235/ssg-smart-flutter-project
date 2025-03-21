
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/attendence/widget/attendance_summary_table.dart';
import '../../../data/model/body/customer_details.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/salesorder/customer.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/attachment_provider.dart';
import '../../../provider/attendance_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_auto_complete.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class ItemWisePending extends StatefulWidget {
  final bool isBackButtonExist;
  const ItemWisePending({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<ItemWisePending> createState() => _ItemWisePendingState();
}

class _ItemWisePendingState extends State<ItemWisePending> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();

  bool _showResult = false;

  UserInfoModel? userInfoModel;



  List<DropDownModel> _customersDropDown = [];
  DropDownModel? _selectedCustomerDropDown;
  TextEditingController? _customerController;


  CustomerDetails? _selectedCustomer;
  List<CustomerDetails> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _intData();

    DateTime now = DateTime.now();
    _endDateController.text = DateFormat('dd-MM-yyyy').format(now);
    _startDateController.text = DateFormat('dd-MM-yyyy').format(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false)
          .clearAttendanceData();
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
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Item Wise Pending Page',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (
                        BuildContext context) => const DashBoardScreen()));
              }),
          // Attendance Type Dropdown
          Consumer<AttendanceProvider>(
            builder: (context, attendanceProvider, child) {
               return Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.streetview, color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Customer Name', textStyle: titilliumRegular),
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

              /*return Container(
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
                              //borderColor: _customerFieldError?Colors.red:Colors.transparent,
                              onReturnTextController: (textController) =>
                              _customerController = textController,
                              onClearPressed: () {
                                setState(() {


                                  _selectedCustomer = null;

                                });
                              },
                              onChanged: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());


                                for (Customer customer in provider.customerList) {
                                  if (customer.customerId == value.code) {

                                    *//*provider.salesOrder.customerId = customer.customerId;
                                    provider.salesOrder.customerName = customer.customerName;
                                    provider.salesOrder.warehouseId = customer.warehouseId;
                                    provider.salesOrder.warehouseName = customer.warehouseName;
                                    provider.salesOrder.freightTermsId = customer.freightTermsId;
                                    provider.salesOrder.freightTerms = customer.freightTerms;*//*

                                    _selectedCustomer = customer as CustomerDetails?;
                                    *//*_custId = _selectedCustomer?.customerId ?? '';
                                    _custAccount = _selectedCustomer?.accountNumber ?? '';
                                    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, _custId);
                                    _warehouseId = _selectedCustomer?.warehouseId ?? '';
                                    _freightTerms =  _selectedCustomer?.freightTerms ?? '';
                                    _selectedWareHouse = null;*//*
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
                );*/

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
                            const SizedBox(width: Dimensions
                                .MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(text: 'Start Date',
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
                            const SizedBox(width: Dimensions
                                .MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(text: 'End Date',
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
                final provider = Provider.of<SalesOrderProvider>(
                    context, listen: false);
                UserInfoModel? userInfoModel = Provider
                    .of<UserProvider>(context, listen: false)
                    .userInfoModel;
                provider.fetchItemWisePending(

                    userInfoModel!.salesRepId!,
                    _selectedCustomer!.customerId ?? ''
                 // '100002083',
                  //''
                );
                setState(() {
                  _showResult = true;
                });
              },
              buttonText: 'SUBMIT',
            ),
          ),
          Visibility(
            visible: _showResult,
            child: Expanded(
              child: SingleChildScrollView(
                child: Consumer<SalesOrderProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (provider.itemWisePending.isEmpty) {
                      // return Center(child: Text('No records found'));
                      return NoInternetOrDataScreen(isNoInternet: false);
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 10, // Reduce spacing if needed
                                  columns: [
                                    DataColumn(label: Text('Item Name', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Pending Qty', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Freight', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('UOM', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                  ],
                                  rows: provider.itemWisePending.map((record) => DataRow(
                                    cells: [
                                      DataCell(Container(width: 130, child: Text(record.item_name ?? '', softWrap: true))),
                                      DataCell(Container(width: 80, child: Text(record.pending_qty ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.freight ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.uom ?? '', softWrap: true))),
                                    ],
                                  )).toList(),
                                )
                            )
                          ],
                        ),

                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}