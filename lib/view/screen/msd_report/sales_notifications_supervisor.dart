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
import 'package:ssg_smart2/view/screen/msd_report/notification_summary_model.dart';
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
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_auto_complete.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/my_dialog.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../../basewidget/textfield/custom_textfield.dart';
import '../home/dashboard_screen.dart';

class SalesNotificationsSupervisor extends StatefulWidget {
  final bool isBackButtonExist;

  const SalesNotificationsSupervisor({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<SalesNotificationsSupervisor> createState() => _SalesNotificationsSupervisorState();
}

class _SalesNotificationsSupervisorState extends State<SalesNotificationsSupervisor> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  DropDownModel? selectedSpCustList;
  bool isSpCustListFieldError = false;

  List<CustomerDetails> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  UserInfoModel? userInfoModel;
  bool _showResult = false;
  String notifiCaSummary='';

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

  List<DropDownModel> _customersDropDown = [];
  DropDownModel? _selectedCustomerDropDown;
  TextEditingController? _customerController;
  String _custId = '';
  Customer? _selectedCustomer;

  bool _customerFieldError = false;

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
      Provider.of<SalesOrderProvider>(context, listen: false).clearSalesOrder();
    });
  }

  _intData() async {
    // Provider.of<UserProvider>(context, listen: false).resetLoading();
    Provider.of<SalesOrderProvider>(context, listen: false).clearSummaryData();
    userInfoModel =
        Provider.of<UserProvider>(context, listen: false).userInfoModel;
    print("userinfo: ${userInfoModel}");
    final provider = Provider.of<AttachmentProvider>(context, listen: false);
    provider.fetchAitEssentails(
        userInfoModel!.orgId!, userInfoModel!.salesRepId!);
    //provider.fetchAitEssentails('100002083','101');
    Provider.of<SalesOrderProvider>(context, listen: false)
        .getCollectionInformation(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalesOrderProvider>();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Supervisor Sales Report Page',
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
                        width: MediaQuery.of(context).size.width - 40,
                      ),
                      hint: Text('Select Report Type'),
                      items: _reportTypes
                          .map((type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
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
                            //top: Dimensions.MARGIN_SIZE_SMALL,
                            //: Dimensions.MARGIN_SIZE_DEFAULT,
                            //right: Dimensions.MARGIN_SIZE_DEFAULT,
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
                             /* const SizedBox(
                                  height: Dimensions
                                      .MARGIN_SIZE_SMALL),*/ // Spacing between rows
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
              onTap: () async {
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
                //notifiCaSummary = notifiSummary!.summary!;

                await provider.fetchSalesNotificationSupervisor(
                    userInfoModel!.userName!,
                    //userInfoModel!.salesRepId!,
                    '',
                    //'3138',
                    _selectedCustomer?.customerId ?? '',
                    userInfoModel!.orgId!,
                    //selectedSpCustList!.code ?? '',
                    _startDateController.text,
                    _endDateController.text,
                    _selectedReportType ?? '');
                await provider.fetchSalesNotiSummarySupervisor(
                    userInfoModel!.userName!,
                    //userInfoModel!.salesRepId!,
                    '',
                    //'3138',
                    _selectedCustomer?.customerId ?? '',
                    userInfoModel!.orgId!,
                    //selectedSpCustList!.code ?? '',
                    _startDateController.text,
                    _endDateController.text,
                    _selectedReportType ?? '');
                notifiCaSummary = provider.summaryModel!.summary;
                setState(() {
                  _showResult = true;
                });
              },
              buttonText: 'SUBMIT',
            ),
          ),
          /*Container(
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
                      text: 'Vehicle Information',
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
                        //controller: _cusPONoController,
                        hintText: 'Enter Vehicle Information ',
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
          ),*/

          Container(
            color: Colors.purple.withOpacity(0.2),
            padding: EdgeInsets.only(top: 5, bottom: 5,left: 20,right: 20),
            width: double.infinity,

            child: RichText(
              text: TextSpan(
                //text: 'Grant Total -- ',
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),
                children: <TextSpan>[
                  TextSpan(text: 'Summary'),
                  //'${Provider.of<SalesOrderProvider>(context, listen: true).getCalculatedTotalQty()}', style: TextStyle(fontWeight: FontWeight.bold)),

                  //'${Provider.of<SalesOrderProvider>(context, listen: true).getCalculatedTotalPrice()}'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

        Container(
          color: Colors.purple.withOpacity(0.2),
          padding: EdgeInsets.only(top: 5, bottom: 5,left: 20,right: 20),
          width: double.infinity,

          child: RichText(
            text: TextSpan(
              //text: 'Grant Total -- ',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),
              children: <TextSpan>[
                //TextSpan(text: '${provider.summaryModel?.summary}'),
                TextSpan(text: notifiCaSummary),

                //'${Provider.of<SalesOrderProvider>(context, listen: true).getCalculatedTotalQty()}', style: TextStyle(fontWeight: FontWeight.bold)),

                //'${Provider.of<SalesOrderProvider>(context, listen: true).getCalculatedTotalPrice()}'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
          Expanded(
            child: Consumer<SalesOrderProvider>(
              builder: (context, provider, child) {
                if (!_showResult) {
                  return SizedBox.shrink();
                } else if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.salesNotification.isEmpty) {
                  return NoInternetOrDataScreen(isNoInternet: false);
                } else {
                  return ListView.builder(
                    itemCount: provider.salesNotification.length,
                    itemBuilder: (context, index) {
                      final approval = provider.salesNotification[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
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
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    Text(
                      "${msdReportModel.msg}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black),
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
