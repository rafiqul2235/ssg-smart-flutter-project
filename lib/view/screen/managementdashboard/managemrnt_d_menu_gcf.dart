import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/screen/managementdashboard/management_dashbboard_screen.dart';
import 'package:ssg_smart2/view/screen/managementdashboard/management_dashbboard_screen_gcf.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class ManagementDMenuGCF extends StatefulWidget {
  final bool isBackButtonExist;
  const ManagementDMenuGCF({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<ManagementDMenuGCF> createState() => _ManagementDMenuGCFState();
}

class _ManagementDMenuGCFState extends State<ManagementDMenuGCF> {
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

  void _onClickSubmit (BuildContext context, String value){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagementDashboardGCF(data: value,)
        )
    );
  }

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
                  ? CustomButton(onTap: () {_onClickSubmit(context,"Daily");},
                  buttonText: 'Business Status :: Day')
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
                  ? CustomButton(onTap: () {_onClickSubmit(context, "Monthly");},
                  buttonText: 'Business Status :: Month')
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
                  ? CustomButton(onTap: () {_onClickSubmit(context, "Yearly");},
                  buttonText: 'Business Status :: Year')
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ),

          ],
        ));
  }


}
