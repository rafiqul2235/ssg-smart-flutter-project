import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/response/attendance_sheet_model.dart';
import '../../../provider/attendance_provider.dart';
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  List<String> _attendanceTypes = ['Present', 'Absent', 'Late', 'Leave', 'Offday', 'Holiday'];
  String? _selectedAttendanceType;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                    builder: (BuildContext context) => const DashBoardScreen()));
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
                            color: ColorResources.getPrimary(context), size: 20),
                        const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        MandatoryText(text: 'Attendance Type', mandatoryText: '*', textStyle: titilliumRegular),
                      ],
                    ),
                    const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    DropdownButton2<String>(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      dropdownWidth: width - 40,
                      hint: Text('Select Attendance Type'),
                      items: _attendanceTypes
                          .map((type) => DropdownMenuItem<String>(
                        value: type,
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
                                color: ColorResources.getPrimary(context), size: 20),
                            const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(text: 'Start Date', mandatoryText: '*', textStyle: titilliumRegular),
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
                                color: ColorResources.getPrimary(context), size: 20),
                            const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            MandatoryText(text: 'End Date', mandatoryText: '*', textStyle: titilliumRegular),
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
              onTap: (){
                final provider = Provider.of<AttendanceProvider>(context, listen: false);
                provider.fetchAttendanceSheet(
                    '6928',
                    _startDateController.text,
                    _endDateController.text,
                    _selectedAttendanceType!
                );
              },
              buttonText: 'SUBMIT',
            ),
            ),
          Center(child: Text('Attendance Summary', style: titilliumBold.copyWith(fontSize: 18))),
          Center(child: Text('Attendance Details', style: titilliumBold.copyWith(fontSize: 18))),
          // Attendance Table
          Expanded(
            child: Consumer<AttendanceProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.attendanceRecords.isEmpty) {
                  return Center(child: Text('No records found'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('SL', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('In-Time', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Out-Time', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('W_Hours', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: provider.attendanceRecords.map((record) => DataRow(
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
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
