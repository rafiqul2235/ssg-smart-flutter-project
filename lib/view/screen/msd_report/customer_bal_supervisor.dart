
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
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class CustBalForSupervisor extends StatefulWidget {
  final bool isBackButtonExist;
  const CustBalForSupervisor({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<CustBalForSupervisor> createState() => _CustBalForSupervisorState();
}

class _CustBalForSupervisorState extends State<CustBalForSupervisor> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();

  bool _showResult = false;

  UserInfoModel? userInfoModel;
  DropDownModel? selectedSPListForSupervisor;
  DropDownModel? selectedCustomerListForSupervisor;
  bool isSpCustListFieldError = false;



  List<DropDownModel> _customersDropDown = [];
  DropDownModel? _selectedCustomerDropDown;
  TextEditingController? _customerController;
  String _custId = '';
  Customer? _selectedCustomer;

  bool _customerFieldError = false;
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
    //provider.fetchAitEssentails(userInfoModel!.orgId!, userInfoModel!.salesRepId!);
    Provider.of<SalesOrderProvider>(context, listen: false).getCollectionInformation(context);
    //provider.fetchAitEssentails('100002083','101');

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
   // final provider = context.watch<SalesOrderProvider>();
    //final customers = provider.customersList;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Customer Balance',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (
                        BuildContext context) => const DashBoardScreen()));
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
                        MandatoryText(text: 'Salesperson List', mandatoryText: '', textStyle: titilliumRegular),
                      ],
                    ),

                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    CustomDropdownButton(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      dropdownWidth: MediaQuery.of(context).size.width - 40,
                      hint: 'Select Salesperson',
                      dropdownItems: salesOrderProvider.SpListForSupervisor,
                      value: selectedSPListForSupervisor,
                      buttonBorderColor: isSpCustListFieldError ? Colors.red : Colors.black12,
                      onChanged: (value) {
                        setState(() {
                          selectedSPListForSupervisor = value;
                          // Reset result visibility when selection changes
                          _showResult = false;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          Consumer<SalesOrderProvider>(
            builder: (context, salesOrderProvider, child) {
              return Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.streetview, color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Customer List', mandatoryText: '*', textStyle: titilliumRegular),
                      ],
                    ),

                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    CustomDropdownButton(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      dropdownWidth: MediaQuery.of(context).size.width - 40,
                      hint: 'Select Customer',
                      dropdownItems: salesOrderProvider.CustListForSupervisor,
                      value: selectedCustomerListForSupervisor,
                      buttonBorderColor: isSpCustListFieldError ? Colors.red : Colors.black12,
                      onChanged: (value) {
                        setState(() {
                          selectedCustomerListForSupervisor = value;
                          // Reset result visibility when selection changes
                          _showResult = false;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          /*Consumer<SalesOrderProvider>(
            builder: (context, provider, child) {

              if (_customersDropDown == null || _customersDropDown.isEmpty) {
                _customersDropDown = [];
                provider.customerList.forEach((element) =>
                    _customersDropDown.add(DropDownModel(
                        code: element.customerId,
                        name: element.customerName
                    )));
              }


              return Container(
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
                           mandatoryText: '',
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
                                   *//*Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context, _custId);*//*
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
               );

            },
          ),*/
          // Date Inputs
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
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
                provider.fetchCustomerBalSupervisor(

                    userInfoModel!.userName!,
                   //_selectedCustomer?.accountNumber ?? ''
                  selectedCustomerListForSupervisor?.code??'',
                  selectedSPListForSupervisor?.code??'',
                  userInfoModel!.orgId!,
                  //'100002083',
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
                    } else if (provider.custBalSupervisor.isEmpty) {
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
                                    DataColumn(label: Text('Account', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Customer Name', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Balance', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    //DataColumn(label: Text('Freight', softWrap: true,style: TextStyle(
                                        //fontWeight: FontWeight.bold))),
                                    //DataColumn(label: Text('UOM', softWrap: true,style: TextStyle(
                                        //fontWeight: FontWeight.bold))),
                                  ],
                                  rows: provider.custBalSupervisor.map((record) => DataRow(
                                    cells: [
                                      DataCell(Container(width: 80, child: Text(record.cust_account ?? '', softWrap: true))),
                                      DataCell(Container(width: 200, child: Text(record.customer_name ?? '', softWrap: true))),
                                      DataCell(Container(width: 100, child: Text(record.balance ?? '', softWrap: true))),
                                      //DataCell(Container(width: 70, child: Text(record.freight ?? '', softWrap: true))),
                                      //DataCell(Container(width: 70, child: Text(record.uom ?? '', softWrap: true))),
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