import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/screen/managementdashboard/management_dashbboard_screen.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class ManagementDMenu extends StatefulWidget {
  final bool isBackButtonExist;
  final String source='Monthly';
  const ManagementDMenu({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<ManagementDMenu> createState() => _ManagementDMenuState();
}

class _ManagementDMenuState extends State<ManagementDMenu> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();


  bool isLeaveTypeFieldError = false;

  get source => '';

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManagementDashboard(
          intentData:source)
        ),
      );

    // Provider.of<LeaveProvider>(context, listen: false).applyLeave(context, selectedLeaveType!.code!, _startDateController.text, _endDateController.text,
    //_durationController.text, _leaveCommentsController.text);

  }

/**/

  //day: Daily, Month: Monthly, Year: Yearly

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            CustomAppBar(
                title: 'Business Status',
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
/*  @override
  Widget build(BuildContext context) {
    const defaultPadding = 16.0;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Styles.primaryColor,
        title: Text(" Business Info. for Management "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Get.toNamed(Routes.REPORT,arguments: 'Daily');
              },
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.2),
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.calendar_today_rounded, color: Colors.black54),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            'Business Status : Daily Basis',
                            maxLines: 3,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.black38)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            InkWell(
              onTap: (){
                Get.toNamed(Routes.REPORT,arguments: 'Monthly');
              },
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.2),
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.calendar_today_rounded, color: Colors.black54),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            'Business Status : Monthly Basis',
                            maxLines: 3,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.black38)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            InkWell(
              onTap: (){
                Get.toNamed(Routes.REPORT, arguments: 'Yearly');
              },
              child: Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(.2),
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.calendar_today_rounded, color: Colors.black54),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            'Business Status : Yearly Basis',
                            maxLines: 3,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.black38)
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }*/




}

class IntentData {
  final String value;

  IntentData(this.value);
}
