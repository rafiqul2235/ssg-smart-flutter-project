import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:ssg_smart2/view/basewidget/mandatory_text.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../helper/date_converter.dart';
import '../../../utill/app_constants.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/custom_text.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
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
  final TextEditingController _leaveCommentsController =
      TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  File? file;
  final _picker = ImagePicker();
  bool firstTime = true;

  String workingAreaName = '';

  DropDownModel? selectedLeaveType;
  List<DropDownModel> _leaveTypes = [] ;

  bool isLeaveTypeFieldError = false;


  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).resetLoading();

    _leaveTypes = [DropDownModel(code: '61',name: 'Casual Leave'),
      DropDownModel(code: '64',name: 'Sick Leave'),
      DropDownModel(code: '68',name: 'Attendance Leave'),
      DropDownModel(code: '70',name: 'Late Leave'),
    ];

  }

  void _durationCalculation() {

    String _startDate = _startDateController.text!;
    String _endDate = _endDateController.text!;
    if(_startDate.isNotEmpty && _endDate.isNotEmpty){
      int duration = DateConverter.differanceTwoDate(_startDate, _endDate);
      print('_durationCalculation $_startDate - $_endDate , $duration');
      if(duration > 0) {
        _durationController.text = '${duration+1}';
      }
    }
  }

  void _onClickSubmit (){
    print('_onClickSubmit');
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
              padding: EdgeInsets.only(top: 55),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorResources.getIconBg(context),
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                            topRight:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                          )),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [

                          Center(child: Text('Leave Balance',style: titilliumBold.copyWith(fontSize: 20))),
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(1.9),
                              1: FlexColumnWidth(3.1),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    color: ColorResources.DARK_BLUE2.withOpacity(0.9),
                                    child: Align( alignment: Alignment.centerLeft,child: Text(' Product Code ', style: titilliumSemiBold.copyWith(color: Colors.white))),
                                  ),
                                  Container(
                                    height: 32,
                                    color: ColorResources.LightDayBlue,
                                    child: Align( alignment: Alignment.centerLeft,child: Text('  {widget.shelflifeReqModel.productCode}', style: titilliumSemiBold)),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    color: ColorResources.DARK_BLUE2.withOpacity(0.9),
                                    child: Align( alignment: Alignment.centerLeft,child: Text(' Product Name ', style: titilliumSemiBold.copyWith(color: Colors.white))),
                                  ),
                                  Container(
                                    height: 32,
                                    color: ColorResources.LightDayBlue,
                                    child: Align( alignment: Alignment.centerLeft,child: Text(' {widget.shelflifeReqModel.productName}', style: titilliumSemiBold)),
                                  ),
                                ],
                              ),

                            ],
                          ),

                          Center(child: Text('Apply Your Leave',style: titilliumBold.copyWith(fontSize: 20))),

                          // for leave type
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.streetview,
                                        color:
                                        ColorResources.getPrimary(context),
                                        size: 20),
                                    const SizedBox(
                                      width: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                                    ),
                                    MandatoryText(text: 'Leave Type', mandatoryText: '*',
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
                                  dropdownItems: _leaveTypes,
                                  value: selectedLeaveType,
                                  buttonBorderColor: isLeaveTypeFieldError?Colors.red:Colors.black12,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLeaveType = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          // for Start Date
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        color:
                                            ColorResources.getPrimary(context),
                                        size: 20),
                                    const SizedBox(
                                      width: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                                    ),
                                    MandatoryText(text: 'Start Date', mandatoryText: '*',
                                        textStyle: titilliumRegular)
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomDateTimeTextField(
                                  controller: _startDateController,
                                  focusNode: _startDateFocus,
                                  nextNode: _endDateFocus,
                                  textInputAction: TextInputAction.next,
                                  isTime: false,
                                  readyOnly: false,
                                  onChanged: (v) => { _durationCalculation()},
                                ),

                              ],
                            ),
                          ),

                          // for End Date
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        color:
                                            ColorResources.getPrimary(context),
                                        size: 20),
                                    const SizedBox(
                                        width:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    MandatoryText(text: 'End Date', mandatoryText: '*',
                                        textStyle: titilliumRegular)
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomDateTimeTextField(
                                  controller: _endDateController,
                                  focusNode: _endDateFocus,
                                  //nextNode: _toDateFocus,
                                  textInputAction: TextInputAction.next,
                                  isTime: false,
                                  readyOnly: false,
                                  onChanged: (v) => { _durationCalculation()},
                                ),
                              ],
                            ),
                          ),

                          // for Duration
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time_filled,
                                        color:
                                            ColorResources.getPrimary(context),
                                        size: 20),
                                    const SizedBox(
                                        width:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    MandatoryText(text: 'Leave Duration', mandatoryText: '*',
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
                                ),
                              ],
                            ),
                          ),

                          // for  leave comment
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.note_add,
                                        color:
                                            ColorResources.getPrimary(context),
                                        size: 20),
                                    const SizedBox(
                                        width:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    MandatoryText(text: 'Leave Comments', mandatoryText: '*',
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
                    child: !Provider.of<UserProvider>(context).isLoading
                        ? CustomButton(onTap: () {_onClickSubmit();}, buttonText: 'SUBMIT')
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor))),
                  ),
                ],
              ),
            ))
          ],
        ));
  }
}
