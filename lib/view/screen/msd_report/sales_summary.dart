
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/attendence/widget/attendance_summary_table.dart';
import '../../../data/model/body/customer_details.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/attachment_provider.dart';
import '../../../provider/attendance_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class SalesSummary extends StatefulWidget {
  final bool isBackButtonExist;
  const SalesSummary({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<SalesSummary> createState() => _SalesSummaryState();
}

class _SalesSummaryState extends State<SalesSummary> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();

  bool _showResult = false;

  UserInfoModel? userInfoModel;

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
              title: 'Sales Summary Page',
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
                provider.fetchSaleSummary(

                  /*'100002083',
                    '3138',
                    '2024-01-01',
                    '2024-01-30'*/
                    userInfoModel!.salesRepId!,
                    _selectedCustomer!.customerId ?? '',
                    _startDateController.text,
                    _endDateController.text
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
                    } else if (provider.salesSummary.isEmpty) {
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
                                    DataColumn(label: Text('Customer Name', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Collection', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Sales', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Delivery', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                  ],
                                  rows: provider.salesSummary.map((record) => DataRow(
                                    cells: [
                                      DataCell(Container(width: 130, child: Text(record.cust_name ?? '', softWrap: true))),
                                      DataCell(Container(width: 80, child: Text(record.collection_qty ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.sales_qty ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.delivery_qty ?? '', softWrap: true))),
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