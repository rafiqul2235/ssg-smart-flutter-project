
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/attendence/widget/attendance_summary_table.dart';
import '../../../data/model/response/user_info_model.dart';
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

class AttendanceSheetPage extends StatefulWidget {
  final bool isBackButtonExist;
  const AttendanceSheetPage({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<AttendanceSheetPage> createState() => _AttendanceSheetPageState();
}

class _AttendanceSheetPageState extends State<AttendanceSheetPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<
      ScaffoldMessengerState>();

  bool _showResult = false;

  List<String> _attendanceTypes = [
    'All',
    'Present',
    'Absent',
    'Late',
    'Leave',
    'Offday',
    'Holiday'
  ];
  String? _selectedAttendanceType;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    _endDateController.text = DateFormat('dd-MM-yyyy').format(now);
    DateTime startDate = DateTime(now.year, now.month - 1, 26);
    if (now.day >= 26) {
      startDate = DateTime(now.year, now.month, 26);
    }
    _startDateController.text = DateFormat('dd-MM-yyyy').format(startDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false)
          .clearAttendanceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Attendance Sheet Page',
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
                        Icon(Icons.streetview,
                            color: ColorResources.getPrimary(context),
                            size: 20),
                        const SizedBox(
                            width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Attendance Type',
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
                      hint: Text('Select Attendance Type'),
                      items: _attendanceTypes
                          .map((type) => DropdownMenuItem<String>(
                        value: type == 'All' ? null : type,
                        child: Text(type),
                      ))
                          .toList(),
                      value: _selectedAttendanceType,
                      onChanged: (value) {
                        setState(() {
                          _selectedAttendanceType = value;
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
                final provider = Provider.of<AttendanceProvider>(
                    context, listen: false);
                UserInfoModel? userInfoModel = Provider
                    .of<UserProvider>(context, listen: false)
                    .userInfoModel;
                provider.fetchAttendanceSheet(
                    userInfoModel!.employeeNumber!,
                    _startDateController.text,
                    _endDateController.text,
                    _selectedAttendanceType ?? ''
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
                child: Consumer<AttendanceProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (provider.attendanceRecords.isEmpty) {
                          // return Center(child: Text('No records found'));
                          return NoInternetOrDataScreen(isNoInternet: false);
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(child: Text("Attendance Summary", style: TextStyle(fontSize: 18),)),
                                AttendanceSummaryTable(attendanceSummary: provider.attendanceSummary),
                                Center(child: Text("Attendance Details", style: TextStyle(fontSize: 18),)),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('SL', style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Date', style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('In-Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Out-Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('W_Hours',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Status', style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                                    ],
                                    rows: provider.attendanceRecords.map((record) =>
                                        DataRow(
                                          cells: [
                                            DataCell(Text(record.srlNum ?? '')),
                                            DataCell(Text(record.workingDate ?? '')),
                                            DataCell(Text(record.actInTime ?? '')),
                                            DataCell(Text(record.actOutTime ?? '')),
                                            DataCell(Text(record.wHour ?? '')),
                                            DataCell(Text(record.status ?? '')),
                                          ],
                                        )).toList(),
                                  ),
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