
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

class CustBalanceConfirmation extends StatefulWidget {
  final bool isBackButtonExist;
  const CustBalanceConfirmation({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<CustBalanceConfirmation> createState() => _CustBalanceConfirmationState();
}

class _CustBalanceConfirmationState extends State<CustBalanceConfirmation> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();

  bool _showResult = false;

  UserInfoModel? userInfoModel;



  List<DropDownModel> _customersDropDown = [];
  DropDownModel? _selectedCustomerDropDown;
  TextEditingController? _customerController;
  String _custId = '';
  Customer? _selectedCustomer;
  String outputFormat='';

  List<String> _preiodList = [
    'Select Month Name',
    'Jul-24',
    'Jan-25',
    'Feb-25',
    'Mar-25',
    'Apr-25',
    'May-25',
    'Jun-25',
    'Jul-25',
    'Aug-25',
    'Sep-25',
    'Oct-25',
    'Nov-25',
    'Dec-25',
    'Jan-26',
    'Feb-26',
    'Mar-26',
    'Apr-26',
    'May-26',
    'Jun-26',
  ];
  String? _selectedPreiodListFrom;
  String? _selectedPreiodListTo;

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


  String? convertDateFormatFrom(String startDate) {
    try {
      // Parse the input date
      DateFormat inputFormat = DateFormat("MMM-yy", "en_US");
      DateTime date = inputFormat.parse(startDate);
      // Format the date to the desired output format
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(date);
    } catch (e) {
      print("Error parsing date: \$e");
      return null; // Handle parsing error as needed
    }
  }

  String? convertDateFormatTo(String startDate) {
    try {
      // Parse the input date
      DateFormat inputFormat = DateFormat("MMM-yy", "en_US");
      DateTime date = inputFormat.parse(startDate);
      // Format the date to the desired output format
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(date);
    } catch (e) {
      print("Error parsing date: \$e");
      return null; // Handle parsing error as needed
    }
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
              title: 'Balance Confirmation Page',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (
                        BuildContext context) => const DashBoardScreen()));
              }),

          /*Consumer<AttendanceProvider>(
            builder: (context, attendanceProvider, child) {
              return Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.streetview,
                            color: ColorResources.getPrimary(context),
                            size: 20),
                        const SizedBox(
                            width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'From Month',
                            mandatoryText: '*',
                            textStyle: titilliumRegular),
                      ],
                    ),
                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    DropdownButton2<String>(
                      buttonStyleData: ButtonStyleData(
                        height: 45,
                        width: double.infinity,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: width - 40,
                      ),
                      hint: Text('Select From Month'),
                      items: _preiodList
                          .map((type) => DropdownMenuItem<String>
                        (
                        value: type == 'Select From Month' ? null : type,
                        child: Text(type),
                      )

                      )
                          .toList(),
                      value: _selectedPreiodListFrom,
                      onChanged: (value) {
                        setState(() {
                          _selectedPreiodListFrom = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer<AttendanceProvider>(
            builder: (context, attendanceProvider, child) {
              return Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.streetview,
                            color: ColorResources.getPrimary(context),
                            size: 20),
                        const SizedBox(
                            width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'To Month',
                            mandatoryText: '*',
                            textStyle: titilliumRegular),
                      ],
                    ),
                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    DropdownButton2<String>(
                      buttonStyleData: ButtonStyleData(
                        height: 45,
                        width: double.infinity,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        width: width - 40,
                      ),
                      hint: Text('To Month'),
                      items: _preiodList
                          .map((type) => DropdownMenuItem<String>
                        (
                        value: type == 'Select To Month' ? null : type,
                        child: Text(type),
                      )

                      )
                          .toList(),
                      value: _selectedPreiodListTo,
                      onChanged: (value) {
                        setState(() {
                          _selectedPreiodListTo= value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),*/

          Consumer<SalesOrderProvider>(
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
               );

            },
          ),
          // Date Inputs
          const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
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
                            MandatoryText(text: 'From Month',
                                mandatoryText: '*',
                                textStyle: titilliumRegular),
                          ],
                        ),

                        Consumer<AttendanceProvider>(
                          builder: (context, attendanceProvider, child) {
                            return Container(
                              margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                              child: Column(
                                children: [
                                  DropdownButton2<String>(
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: double.infinity,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      width: width - 40,
                                    ),
                                    hint: Text('Select From Month'),
                                    items: _preiodList
                                        .map((type) => DropdownMenuItem<String>
                                      (
                                      value: type == 'Select From Month' ? null : type,
                                      child: Text(type),
                                    )

                                    )
                                        .toList(),
                                    value: _selectedPreiodListFrom,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPreiodListFrom = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
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
                            const SizedBox(width: Dimensions
                                .MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(text: 'To Month',
                                mandatoryText: '*',
                                textStyle: titilliumRegular),
                          ],
                        ),
                        Consumer<AttendanceProvider>(
                          builder: (context, attendanceProvider, child) {
                            return Container(
                              margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                              child: Column(
                                children: [
                                  DropdownButton2<String>(
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: double.infinity,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      width: width - 40,
                                    ),
                                    hint: Text('Select To Month'),
                                    items: _preiodList
                                        .map((type) => DropdownMenuItem<String>
                                      (
                                      value: type == 'Select To Month' ? null : type,
                                      child: Text(type),
                                    )

                                    )
                                        .toList(),
                                    value: _selectedPreiodListTo,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPreiodListTo= value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
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
                String? startDate = convertDateFormatFrom(_selectedPreiodListFrom??'');
                String? endDate = convertDateFormatFrom(_selectedPreiodListTo??'');
                print('fromD:$startDate');
                print('toD:$endDate');
                //outputFormat = convertDateFormat('Dce-23')!;
                final provider = Provider.of<SalesOrderProvider>(
                    context, listen: false);
                UserInfoModel? userInfoModel = Provider
                    .of<UserProvider>(context, listen: false)
                    .userInfoModel;
                provider.fetchBalanceConfirmation(
                    userInfoModel!.salesRepId!,
                   _selectedCustomer?.customerId ?? '',
                    startDate,
                    endDate


                    //'2024-12-01',
                    //'2024-12-31'
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
                    } else if (provider.balanceConf.isEmpty) {
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
                                    DataColumn(label: Text('Month', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Openning Balance', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Rec. Amount', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Adj. Amount', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('SO Issued\n (Bag)', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Delivered\n (Bag)', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Undelivered\n (Bag)', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                    DataColumn(label: Text('Closing B/L', softWrap: true,style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                  ],
                                  rows: provider.balanceConf.map((record) => DataRow(
                                    cells: [
                                      DataCell(Container(width: 130, child: Text(record.customer ?? '', softWrap: true))),
                                      DataCell(Container(width: 80, child: Text(record.month ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.opennig_bal ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.rec_amount ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.adj_amount ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.so_issue ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.delivered ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.undelivered ?? '', softWrap: true))),
                                      DataCell(Container(width: 70, child: Text(record.closing_bal ?? '', softWrap: true))),
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