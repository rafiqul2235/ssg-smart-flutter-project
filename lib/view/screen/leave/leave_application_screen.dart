import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/body/leave_data.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:ssg_smart2/view/basewidget/mandatory_text.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/leave_balance.dart';
import '../../../helper/date_converter.dart';
import '../../../provider/leave_provider.dart';

import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/my_dialog.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../empselfservice/self_service.dart';
import '../home/dashboard_screen.dart';

class LeaveApplicationScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const LeaveApplicationScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  _LeaveApplicationScreenState createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _durationFocus = FocusNode();
  final FocusNode _leaveCommentsFocus = FocusNode();

  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _leaveCommentsController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String workingAreaName = '';

  DropDownModel? selectedLeaveType;

  bool isLeaveTypeFieldError = false;

  LeaveBalance? _leaveBalance =
      LeaveBalance(casual: 0, compensatory: 0, earned: 0.0, sick: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Provider.of<UserProvider>(context, listen: false).resetLoading();

    Provider.of<LeaveProvider>(context, listen: false).getLeaveType(context);

    _intData();
  }

  _intData() async {
    _leaveBalance = await Provider.of<LeaveProvider>(context, listen: false)
        .getLeaveBalance(context);
    setState(() {});
  }

  void _durationCalculation() {
    String _startDate = _startDateController.text!;
    String _endDate = _endDateController.text!;
    if (_startDate.isNotEmpty && _endDate.isNotEmpty) {
      int duration = DateConverter.differanceTwoDate(_startDate, _endDate) + 1;
      if (duration > 0) {
        _durationController.text = '$duration';
      }
    }
  }

  void _onClickSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedLeaveType == null) {
      _showErrorDialog("Please select a leave type");
      return;
    }

    if (!_isLeaveBalanceSufficient()) {
      _showErrorDialog("Unavailable leave balance");
      return;
    }

    UserInfoModel? userInfoModel =
        Provider
            .of<UserProvider>(context, listen: false)
            .userInfoModel;
    LeaveData leaveData = LeaveData(
        empName: userInfoModel?.fullName,
        empNumber: userInfoModel?.employeeNumber,
        department: userInfoModel?.department,
        designation: userInfoModel?.designation,
        orgId: userInfoModel?.orgId,
        orgName: userInfoModel?.orgName,
        personId: userInfoModel?.personId,
        workLocation: userInfoModel?.workLocation,
        leaveType: selectedLeaveType?.name,
        leaveId: selectedLeaveType?.code,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        duration: _durationController.text,
        comment: _leaveCommentsController.text);
    print("Leave data: $leaveData");
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    await leaveProvider.applyLeave(context, leaveData);
    if(!leaveProvider.isValidLeave){
      _showErrorDialog("Casual leave cannot exceed three days.");
    } else if (leaveProvider.isDuplicateLeave) {
      _showErrorDialog("Duplicate leave application detected");
    } else if (leaveProvider.isSingleOccasionLeave) {
      _showErrorDialog("Single occasion leave not allowed");
    } else if (leaveProvider.isProbationPeriodEnd) {
      _showErrorDialog("Casual leave not allowed during probation period");
    } else if (leaveProvider.isSuccess != null && leaveProvider.isSuccess!.isNotEmpty) {
      _showSuccessDialog(leaveProvider.isSuccess!);
    } else if (leaveProvider.error != null) {
      _showErrorDialog(leaveProvider.error!);
    } else {
      _showErrorDialog("An unknown error occurred habibi");
    }
  }

  bool _isLeaveBalanceSufficient() {
    int requestedDuration = int.tryParse(_durationController.text) ?? 0;
    print("leave duration: $requestedDuration");
    print("Selected leave: $selectedLeaveType");
    switch (selectedLeaveType?.code) {
      case '61': // Casual Leave
        return requestedDuration <= (_leaveBalance?.casual ?? 0);
      case '64': // Sick Leave
        return requestedDuration <= (_leaveBalance?.sick ?? 0);
      case '68': // Attendance Leave
        return true;
      case '70': // Late Leave
        return true;
      default:
        return false;
    }
  }

  String? _validateLeaveComments(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the leave comments';
    }
    return null;
  }

  String? _validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the leave duration';
    }
    return null;
  }

  String? _validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the leave start date';
    }
    return null;
  }

  String? _validateEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the leave end date';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            CustomAppBar(
                title: 'Leave Application',
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home,
                onActionPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const DashBoardScreen()));
                }),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          physics: BouncingScrollPhysics(),
                          children: [
                            /* Leave Balance */
                            Center(
                                child: Text('Leave Balance',
                                    style:
                                        titilliumBold.copyWith(fontSize: 20))),

                            Container(
                              color: Colors.blueAccent.withOpacity(0.7),
                              child: Table(
                                  //defaultColumnWidth: IntrinsicColumnWidth(),
                                  //defaultColumnWidth: FixedColumnWidth(),
                                  columnWidths: {
                                    //0:FractionColumnWidth(0.23),
                                    0: IntrinsicColumnWidth(),
                                    1: FlexColumnWidth(1.0),
                                    2: IntrinsicColumnWidth(),
                                    3: FlexColumnWidth(1.0),
                                  },
                                  //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                  border: TableBorder.all(),
                                  children: [
                                    /* Header Row */
                                    TableRow(
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('Leave Type',
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                            fontSize: 16))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('B/L',
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                            fontSize: 16))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('Leave Type',
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                            fontSize: 16))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('B/L',
                                                    style: titilliumSemiBold
                                                        .copyWith(
                                                            fontSize: 16))),
                                          ),
                                        ]),
                                    /* Data Row */
                                    TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade50),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('Casual Leave',
                                                    style: titilliumRegular)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text(
                                                    '${_leaveBalance?.casual}',
                                                    style: titilliumRegular)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('Comp. Leave',
                                                    style: titilliumRegular)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text(
                                                    '${_leaveBalance?.compensatory}',
                                                    style: titilliumRegular)),
                                          ),
                                        ]),
                                    TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade50),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('Sick Leave',
                                                    style: titilliumRegular)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text(
                                                    '${_leaveBalance?.sick}',
                                                    style: titilliumRegular)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text('Earned Leave',
                                                    style: titilliumRegular)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0),
                                            child: Center(
                                                child: Text(
                                                    '${_leaveBalance?.earned}',
                                                    style: titilliumRegular)),
                                          ),
                                        ])
                                  ]),
                            ),

                            /* Apply Leave */
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                  child: Text('Apply Your Leave',
                                      style: titilliumBold.copyWith(
                                          fontSize: 20))),
                            ),

                            // for leave type
                            Consumer<LeaveProvider>(
                                builder: (context, leaveProvider, child) {
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
                            }),

                            // Date Selection Row (Horizontal Layout)
                            Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Start Date
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.date_range,
                                                color:
                                                    ColorResources.getPrimary(
                                                        context),
                                                size: 20),
                                            const SizedBox(
                                                width: Dimensions
                                                    .MARGIN_SIZE_EXTRA_SMALL),
                                            MandatoryText(
                                                text: 'Start Date',
                                                mandatoryText: '*',
                                                textStyle: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        CustomDateTimeTextField(
                                          controller: _startDateController,
                                          focusNode: _startDateFocus,
                                          nextNode: _endDateFocus,
                                          textInputAction: TextInputAction.next,
                                          isTime: false,
                                          readyOnly: false,
                                          onChanged: (v) =>
                                              {_durationCalculation()},
                                          validator: _validateStartDate,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  // End Date
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.date_range,
                                                color:
                                                    ColorResources.getPrimary(
                                                        context),
                                                size: 20),
                                            const SizedBox(
                                                width: Dimensions
                                                    .MARGIN_SIZE_EXTRA_SMALL),
                                            MandatoryText(
                                                text: 'End Date',
                                                mandatoryText: '*',
                                                textStyle: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        CustomDateTimeTextField(
                                          controller: _endDateController,
                                          focusNode: _endDateFocus,
                                          textInputAction: TextInputAction.next,
                                          isTime: false,
                                          readyOnly: false,
                                          onChanged: (v) =>
                                              {_durationCalculation()},
                                          validator: _validateEndDate,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // for Duration
                            Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_filled,
                                          color: ColorResources.getPrimary(
                                              context),
                                          size: 20),
                                      const SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      MandatoryText(
                                          text: 'Leave Duration',
                                          mandatoryText: '*',
                                          textStyle: titilliumRegular)
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _durationController,
                                    focusNode: _durationFocus,
                                    nextNode: _leaveCommentsFocus,
                                    textInputType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                    validator: _validateDuration,
                                  ),
                                ],
                              ),
                            ),

                            // for  leave comment
                            Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.note_add,
                                          color: ColorResources.getPrimary(
                                              context),
                                          size: 20),
                                      const SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      MandatoryText(
                                          text: 'Leave Comments',
                                          mandatoryText: '*',
                                          textStyle: titilliumRegular)
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _leaveCommentsController,
                                    focusNode: _leaveCommentsFocus,
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    validator: _validateLeaveComments,
                                    // validatorMessage: _validateLeaveComments,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<LeaveProvider>(context).loading
                          ? CustomButton(
                              onTap: () {
                                _onClickSubmit();
                              },
                              buttonText: 'SUBMIT')
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor))),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ));
  }

  void _showSuccessDialog(String message) {
    showAnimatedDialog(
        context,
        MyDialog(
          icon: Icons.check,
          title: 'Success',
          description: message,
          rotateAngle: 0,
          positionButtonTxt: 'Go to Home',
          onPositiveButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SelfService(
                          isBackButtonExist: false,
                        )));
          },
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
