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
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/user_info_model.dart';
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

class SalesSummary extends StatefulWidget {
  final bool isBackButtonExist;
  const SalesSummary({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<SalesSummary> createState() => _SalesSummaryState();
}

class _SalesSummaryState extends State<SalesSummary> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  DropDownModel? selectedSpCustList;
  bool isSpCustListFieldError = false;

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
  //MsdReportModel msdReportModel

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

    Provider.of<SalesOrderProvider>(context, listen: false).getSpCustList(context);

    DateTime now = DateTime.now();
    _endDateController.text = DateFormat('dd-MM-yyyy').format(now);
    /*DateTime startDate = DateTime(now.year, now.month - 1, 26);
    if (now.day >= 26) {
      startDate = DateTime(now.year, now.month, 26);
    }*/
    _startDateController.text = DateFormat('dd-MM-yyyy').format(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false)
          .clearAttendanceData();
    });
  }

  @override
  Widget build(BuildContext context) {
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

          // Attendance Type Dropdown
          /*Consumer<SalesOrderProvider>(
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
                        MandatoryText(
                            text: 'Report Type',
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
                      hint: Text('Select Report Type'),
                      items: _reportTypes
                          .map((type) => DropdownMenuItem<String>(
                                value: type == 'All' ? null : type,
                                child: Text(type),
                              ))
                          .toList(),
                      value: _selectedReportType,
                      onChanged: (value) {
                        setState(() {
                          _selectedReportType = value;
                        });
                      },
                    ),
                  ],
                ),
              );

              return Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.streetview,
                            color: ColorResources.getPrimary(
                                context),
                            size: 20),
                        const SizedBox(
                          width: Dimensions
                              .MARGIN_SIZE_EXTRA_SMALL,
                        ),
                        MandatoryText(
                            text: 'Leave Type',
                            mandatoryText: '*',
                            textStyle: titilliumRegular)
                      ],
                    ),
                    const SizedBox(
                        height: Dimensions.MARGIN_SIZE_SMALL),
                    CustomDropdownButton(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      dropdownWidth: width - 40,
                      hint: 'Select Leave Type',
                      //hintColor: Colors.black: null,
                      dropdownItems: leaveProvider.leaveTypes,
                      value: selectedLeaveType,
                      buttonBorderColor: isLeaveTypeFieldError
                          ? Colors.red
                          : Colors.black12,
                      onChanged: (value) {
                        setState(() {
                          selectedLeaveType = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),*/
          Consumer<SalesOrderProvider>(
            builder: (context, salesOrderProvider, child) {
              return Container(
                margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    // 🔹 First Dropdown (Report Type)
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
                        });
                      },
                    ),

                    const SizedBox(height: 20), // 🔹 Add spacing between dropdowns

                    // 🔹 Second Dropdown (Leave Type)
                    Row(
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
                      dropdownItems: salesOrderProvider.SpCustList, // Make sure leaveProvider is defined
                      value: selectedSpCustList,
                      buttonBorderColor: isSpCustListFieldError ? Colors.red : Colors.black12,
                      onChanged: (value) {
                        setState(() {
                          selectedSpCustList = value;
                        });
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
                final provider =
                    Provider.of<SalesOrderProvider>(context, listen: false);
                UserInfoModel? userInfoModel =
                    Provider.of<UserProvider>(context, listen: false)
                        .userInfoModel;
                provider.fetchSalesNotification(
                   /* '100002083',
                  '',
                  '2024-05-26',
                  '2024-06-30',
                    'Sales'*/
                    userInfoModel!.salesRepId!,
                    selectedSpCustList!.code as String,
                    _startDateController.text,
                    _endDateController.text,
                    _selectedReportType ?? ''
                );
                setState(() {
                  //print ('notification data :')
                  if (_selectedReportType == null) {
                    _showCustBalDialog("Select Report Type");
                  } else {
                    _showResult = true;
                  }

                  print('paramiter msdR $_startDateController');
                });
              },
              buttonText: 'SUBMIT',
            ),
          ),




          Expanded(
            child: Consumer<SalesOrderProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }else {
                  return ListView.builder(
                    itemCount: provider.salesNotification.length,
                    itemBuilder: (context, index) {
                      final approval = provider.salesNotification[index];
                      //_commentControllers.putIfAbsent(approval.salesorderMstId, () => TextEditingController());
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
                                top(context,approval),
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

  Widget top(BuildContext context,MsdReportModel msdReportModel) {

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
                      style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "${msdReportModel.msg}",
                      style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 18),
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
