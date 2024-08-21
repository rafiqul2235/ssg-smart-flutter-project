import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/screen/report/sample_list_screen.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../provider/auth_provider.dart';
import '../../basewidget/title_row.dart';
import '../home/dashboard_screen.dart';


// ignore: must_be_immutable
class ReportDashboardScreen extends StatefulWidget {

  final bool isBackButtonExist;

  ReportDashboardScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<ReportDashboardScreen> createState() => _ReportDashboardScreenState();

}

class _ReportDashboardScreenState extends State<ReportDashboardScreen> {
  bool isFirstTime = true;

  DropDownModel? selectedDealer;
  List<DropDownModel> dealerList = [/*DropDownModel(code: 'W393',name: 'Test'),DropDownModel(code: 'W392',name: 'Test2')*/];
  String dealerWCode = '';

  bool dealerError = false;
  TextEditingController? dealerController;

  @override
  void initState() {
    super.initState();
   /* Provider.of<DealerProvider>(context, listen: false).initDealerList(context);
    Provider.of<VisitProvider>(context, listen: false).getVisitPlanList(context);
    Provider.of<VisitProvider>(context, listen: false).getActionLogMailReceivers(context);*/
  }


  Widget _reportMenus(BuildContext context){
    String userGroup = Provider.of<AuthProvider>(context, listen: false).userGroup!;
    /*String userRole = Provider.of<AuthProvider>(context, listen: false).userRole;
    String userCode = Provider.of<AuthProvider>(context, listen: false).userCode;
    print(' userGroup $userGroup');
    print(' userRole $userRole');
    print(' userCode $userCode');*/

    return Column(
      children: [
        TitleCardBar(title: 'Stock Report (Self)',isBorder: false, navigateTo: SampleReportListScreen()),

      ],
    );

  }

  @override
  Widget build(BuildContext context) {

    if (isFirstTime) {
      //if(!isGuestMode) {
      // Provider.of<OrderProvider>(context, listen: false).initOrderList(context);
      //}
      isFirstTime = false;
    }

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Header
            CustomAppBar(
                title: getTranslated('Report', context),
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home, onActionPressed:(){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));}),
            const SizedBox(height: 10,),
            _reportMenus(context)
          ],
        ),
      ),
    );
  }
}

