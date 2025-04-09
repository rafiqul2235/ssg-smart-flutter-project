import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/attendence/widget/attendance_summary_table.dart';
import 'package:ssg_smart2/view/screen/msd_report/delivery_info_model.dart';
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

class DeliveryInfoScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const DeliveryInfoScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<DeliveryInfoScreen> createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  DropDownModel? selectedSrTripList;
  bool isSpCustListFieldError = false;

  bool _showResult = false;

  String _tripList='';

  //late String cust_id;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Provider.of<SalesOrderProvider>(context, listen: false).getTripNumberSr(context);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalesOrderProvider>(context, listen: false)
          .clearSalesOrder();
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
              title: 'Delivery Info Page',
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



                    const SizedBox(height: 20),

                    // 🔹 Second Dropdown (Customer Name)
                    Row(
                      children: [
                        Icon(Icons.streetview, color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Trip Number', mandatoryText: '*', textStyle: titilliumRegular),
                      ],
                    ),

                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    CustomDropdownButton(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      dropdownWidth: MediaQuery.of(context).size.width - 40,
                      hint: 'Select Trip Number',
                      dropdownItems: salesOrderProvider.TripNumSrList,
                      value: selectedSrTripList,
                      buttonBorderColor: isSpCustListFieldError ? Colors.red : Colors.black12,
                      onChanged: (value) {
                        setState(() {
                          selectedSrTripList = value;
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

          // Date Inputs

          // Submit Button

          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.MARGIN_SIZE_LARGE,
              vertical: Dimensions.MARGIN_SIZE_SMALL,
            ),
            child: CustomButton(
              onTap: () {

                /*if (_selectedReportType == null) {
                  _showErrorDialog('Please select a Report Type');
                  return;
                }*/
                /*if (selectedSpCustList == null) {
                  _showErrorDialog('Please select a Customer');
                  return;
                }*/

                final provider = Provider.of<SalesOrderProvider>(context, listen: false);
                UserInfoModel? userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;

                // Clear previous data before fetching new data
                provider.clearSalesOrder();

                provider.fetchDeliveryInfoData(
                    userInfoModel!.salesRepId!,
                    selectedSrTripList?.code??''

                   // '11621757'
                );
                print('data from submit btn: ${provider.dlvInfo}');
                setState(() {
                  _showResult = true;
                });
                print("Fetch Triggered: _showResult = $_showResult");
              },
              buttonText: 'SUBMIT',
            ),
          ),

          Expanded(
            child: Consumer<SalesOrderProvider>(
              builder: (context, provider, child) {
                print('Delivery data: ${provider.dlvInfo}');
                if (!_showResult) {
                  return SizedBox.shrink();
                }
                else if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                else if (provider.dlvInfo.isEmpty) {
                  return NoInternetOrDataScreen(isNoInternet: false);
                }
                else {
                  return ListView.builder(
                    itemCount: provider.dlvInfo.length,
                    itemBuilder: (context, index) {
                      final approval = provider.dlvInfo[index];
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

  Widget top(BuildContext context, DeliveryInfoModel dlvInfoModel) {
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
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "${dlvInfoModel.trip_info}",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "Event Time",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "${dlvInfoModel.event_time}",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "Additional Info",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "${dlvInfoModel.additiontion_info}",
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