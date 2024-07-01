import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/management_dashboard_model.dart';
import 'package:ssg_smart2/data/model/response/pf_ledger_model.dart';

import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/attendance_sheet_model.dart';
import '../../../provider/leave_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class AttendanceSheetPage extends StatefulWidget {
  final bool isBackButtonExist;
  const AttendanceSheetPage({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<AttendanceSheetPage> createState() => _AttendanceSheetPageState();
}

class _AttendanceSheetPageState extends State<AttendanceSheetPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  List<String> _attendanceTypes = ['Present', 'Absent', 'Late', 'Leave','Offday','Holiday'];
  String? _selectedAttendanceType;


  AttendanceSheetModel? _attendanceSheetModel = AttendanceSheetModel();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();

  List<AttendanceSheetModel> _attendanceList = [];
  bool isLeaveTypeFieldError = false;

  @override
  void initState() {
    super.initState();

    _intData();

  }

  _intData() async {
    //_attendanceList =  await Provider.of<LeaveProvider>(context, listen: false).getAttendanceData(context,_startDateController.text,_endDateController.text,_attendanceTypes.first);
   // _attendanceList =  await Provider.of<LeaveProvider>(context, listen: false).getAttendanceData(context,'2024-06-01','2024-06-30','');
    print('attendanceList  ${_attendanceList.length}');
    setState(() {});

  }

  Future<void> _onClickSubmit () async {

    print("stardete: ${_startDateController.text} , endDate ${_endDateController.text} and type ${_attendanceTypes.first}");
    //_attendanceList =  await Provider.of<LeaveProvider>(context, listen: false).getAttendanceData(context,'2024-06-01','2024-06-30','Present');
    _attendanceList =  await Provider.of<LeaveProvider>(context, listen: false).getAttendanceData(context,_startDateController.text,_endDateController.text,_attendanceTypes.first);
    print("Attendance_value :$_attendanceList");
   // Provider.of<LeaveProvider>(context, listen: false).applyLeave(context, selectedLeaveType!.code!, _startDateController.text, _endDateController.text,
        //_durationController.text, _leaveCommentsController.text);

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
                title: 'Attendance Sheet Page',
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home,
                onActionPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const DashBoardScreen()));
                }),
           /* Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(child: Text('Apply Your Leave',style: titilliumBold.copyWith(fontSize: 20))),
            ),*/

            // for leave type
            Consumer<LeaveProvider>(
                builder: (context,leaveProvider,child){

                  return Container(
                    margin: EdgeInsets.only(top: 5.0,left: 10.0,right: 10.0),
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
                            MandatoryText(text: 'Attendance Type', mandatoryText: '*',
                                textStyle: titilliumRegular)
                          ],
                        ),

                        const SizedBox(
                            height: Dimensions.MARGIN_SIZE_SMALL),
                        DropdownButton2<String>(
                          buttonHeight: 45,
                          buttonWidth: double.infinity,
                          dropdownWidth: width - 40,
                          hint: Text('Select Attendance Type'),
                          //hintColor: Colors.black: null,
                          items: _attendanceTypes
                          ?.map((type) => DropdownMenuItem<String>(
                            value: type,
                              child: Text(type))).toList(),
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
                }
            ),

            //Date
            Padding(
              padding: EdgeInsets.only(top: 5.0,left: 10.0,right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //start_date
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5.0),
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
                            //onChanged: (v) => { _durationCalculation()},
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  // for End Date
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5.0),
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
                            //onChanged: (v) => { _durationCalculation()},
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.MARGIN_SIZE_LARGE,
                  vertical: Dimensions.MARGIN_SIZE_SMALL),
              child:
              !Provider.of<UserProvider>(context).isLoading
                  ? CustomButton(onTap: () {_onClickSubmit();},
                  buttonText: 'SUBMIT')

                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ),



            Center(child: Text('Attendance Summary',style: titilliumBold.copyWith(fontSize: 18))),


            Center(child: Text('Attendance Details',style: titilliumBold.copyWith(fontSize: 18))),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          /*decoration: BoxDecoration(
                              color: ColorResources.getIconBg(context),
                              borderRadius: BorderRadius.only(
                                topLeft:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                topRight:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                              )),*/
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              color:Colors.white.withOpacity(0.5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  /* Header Row */
                                    columns: const [
                                      DataColumn(label: Text('SL',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Date',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('In-Time',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Out-Time',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('W_Hours',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                    ],
                                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                    border: TableBorder.all(),
                                    /* Data Row */
                                    rows: [
                                      for(AttendanceSheetModel modelItem in _attendanceList) _attendanceTableRow (modelItem),
                                    ]

                             /*     rows: _attendanceList.map((e) {
                                    return DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(e.sl_num)),
                                          DataCell(Text(e.date))
                                          
                                        ],
                                    );
                                  }).toList(),*/
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  DataRow _attendanceTableRow (AttendanceSheetModel? pfLedgerModel){

    return DataRow (
        //decoration: BoxDecoration(color:Colors.green.shade50),
        cells: [

          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.sl_num}',style: titilliumRegular)),
            ),
          ),

          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.date}',style: titilliumRegular)),
            ),
          ),

          DataCell(
           Padding(
             padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.in_time}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.out_time}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.w_hours}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.status}',style: titilliumRegular)),
            ),
          ),

        ]
    );

  }


}
