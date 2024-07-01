import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class ManagementDMenu extends StatefulWidget {
  final bool isBackButtonExist;
  const ManagementDMenu({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<ManagementDMenu> createState() => _ManagementDMenuState();
}

class _ManagementDMenuState extends State<ManagementDMenu> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();


  bool isLeaveTypeFieldError = false;

  @override
  void initState() {
    super.initState();

    _intData();


  }

  _intData() async {
   // _pfLedgerList =  await Provider.of<LeaveProvider>(context, listen: false).getAttendanceData(context);
    setState(() {});

  }

  void _onClickSubmit (){

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

            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.MARGIN_SIZE_LARGE,
                  vertical: Dimensions.MARGIN_SIZE_SMALL),
              child:
              !Provider.of<UserProvider>(context).isLoading
                  ? CustomButton(onTap: () {_onClickSubmit();},
                  buttonText: 'Day')
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.MARGIN_SIZE_LARGE,
                  vertical: Dimensions.MARGIN_SIZE_SMALL),
              child:
              !Provider.of<UserProvider>(context).isLoading
                  ? CustomButton(onTap: () {_onClickSubmit();},
                  buttonText: 'Month')
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: Dimensions.MARGIN_SIZE_LARGE,
                  vertical: Dimensions.MARGIN_SIZE_SMALL),
              child:
              !Provider.of<UserProvider>(context).isLoading
                  ? CustomButton(onTap: () {_onClickSubmit();},
                  buttonText: 'Year')
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ),

          ],
        ));
  }




}
