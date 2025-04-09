import 'dart:async';
import 'dart:io';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/helper/network_info.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/screen/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/screen/salesOrder/msd_sales_report.dart';
import '../../../provider/auth_provider.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/my_dialog.dart';
import '../apkdownload/apk_download_screen.dart';
import '../auth/auth_screen.dart';
import '../more/more_screen.dart';
import '../notification/notification_screen.dart';
import '../report/report_dashboard_screen.dart';


class DashBoardScreen extends StatefulWidget {

  final bool willAppearAppVersionUpdateDialog;
  final bool isSoftUpdate;

  const DashBoardScreen({Key? key,this.willAppearAppVersionUpdateDialog = false, this.isSoftUpdate = true}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  PageController _pageController = PageController();
  int _pageIndex = 0;
  List<Widget> _screens = [] ;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  int todayVisitCount = 0;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(context);

    String userGroup = Provider.of<AuthProvider>(context, listen: false).userGroup!;
    if(userGroup == 'CET') {
      _screens = [
        HomeScreen(),
        ReportDashboardScreen(isBackButtonExist: false),
        //MsdSalesReport(),
        NotificationScreen(isBackButtonExist: false),
        MoreScreen()
      ];
    }else {
      _screens = [
        HomeScreen(),
        //MsdSalesReport(),
        ReportDashboardScreen(isBackButtonExist: false),
        NotificationScreen(isBackButtonExist: false),
        MoreScreen()
      ];
    }
  }

  void _updateAppVersion (){
    Timer(const Duration(seconds: 1), () async {
        var status = await showAnimatedDialog(context, MyDialog(
          title: 'App Update Available',
          description: 'You can now update this app to new version.',
          rotateAngle: 0,
          negativeButtonTxt: widget.isSoftUpdate?'Later':'Exit',
          positionButtonTxt: 'Update',
        ), dismissible: false);

        if(status!){
          // will update
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ApkDownloadScreen(title: "Apk Downloader", platform: Theme.of(context).platform,)),
          );
        }else{
          if(!widget.isSoftUpdate){
            exit(0);
          }
        }
    });
  }

  void _updateBaseLocation (){
    Timer(const Duration(seconds: 1), () async {
      var status = await showAnimatedDialog(context, MyDialog(
        title: 'Set Base Location',
        description: 'You have to set your base location.',
        rotateAngle: 0,
        negativeButtonTxt: 'Logout',
        positionButtonTxt: 'Set',
      ), dismissible: false);

      if(status!){
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SetLocationAddress(actionName: 'SetBaseLocation',)),
        );*/
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (route) => false);
      }
    });
  }

  void _updateVisitBadge() async {
     /*todayVisitCount = await Provider.of<VisitProvider>(context,listen: false).getTodayPendingPlan(isFirstTime);
     setState(() {
     });*/
  }

  @override
  Widget build(BuildContext context) {

   // _updateVisitBadge();

    if(isFirstTime) {
      if(widget.willAppearAppVersionUpdateDialog) {
        _updateAppVersion();
      }/*else if(widget.isNeededUpdateBaseLocation) {
        _updateBaseLocation();
      }*/
      isFirstTime = false;
    }

    return WillPopScope(
      onWillPop: () async {
        print('_pageIndex $_pageIndex');

        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorResources.DARK_BLUE,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            _barItem(Images.home_image, getTranslated('home', context), 0,0),
           /* _barItem(Images.ic_dashboard, getTranslated('Dashboard', context), 1,0),*/
            _barItem(Images.ic_dashboard, getTranslated('Report', context), 1,0),
            _barItem(Images.message_image, getTranslated('Message', context), 2,0),
            _barItem(Images.more_image, getTranslated('more', context), 3,0),
          ],
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String label, int index, int badgeCount) {
    return BottomNavigationBarItem(
      tooltip: '$badgeCount',
      icon:Stack(
          children: <Widget>[
            Image.asset(
              //icon, color: index == _pageIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
              icon, color: index == _pageIndex ? Colors.white : Colors.grey,
              height: 25, width: 25,
            ),
            badgeCount > 0?
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  '$badgeCount',
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ):const SizedBox.shrink()
          ]
      ),
      /*icon: Image.asset(
        icon, color: index == _pageIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
        height: 25, width: 25,
      ),*/
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

}