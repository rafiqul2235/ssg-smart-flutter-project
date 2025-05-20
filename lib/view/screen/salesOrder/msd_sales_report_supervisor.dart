import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/view/screen/empselfservice/loan_approval_history.dart';
import 'package:ssg_smart2/view/screen/empselfservice/widget/top_menu.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';
import 'package:ssg_smart2/view/screen/msd_report/cust_balance_confirmation.dart';
import 'package:ssg_smart2/view/screen/msd_report/cust_target_vs_achiv.dart';
import 'package:ssg_smart2/view/screen/msd_report/delivery_info_screen.dart';
import 'package:ssg_smart2/view/screen/msd_report/sales_notifications_supervisor.dart';
import 'package:ssg_smart2/view/screen/msd_report/sales_summary.dart';
import 'package:ssg_smart2/view/screen/payslip/pay_slip.dart';
import 'package:ssg_smart2/view/screen/pfledger/pf_ledger_screen.dart';
import 'package:ssg_smart2/view/screen/pfloan/pf_loan.dart';
import 'package:ssg_smart2/view/screen/salaryloan/salary_loan.dart';
import 'package:ssg_smart2/view/screen/salesOrder/msd_notification_screen.dart';
import 'package:ssg_smart2/view/screen/wppfledger/wppf_ledger_screen.dart';
import 'package:ssg_smart2/view/screen/wppfledger/wppf_ledger_screen1.dart';
import '../../../data/model/response/self_service.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/custom_app_bar.dart';
import '../attendence/attendance_sheet_screen.dart';
import '../home/web_view_screen.dart';
import '../leave/leave_application_screen.dart';
import '../msd_report/item_wise_pending.dart';
import '../msd_report/sales_notifications.dart';


class MsdSalesReportSupervisor extends StatefulWidget {
  final bool isBackButtonExist;
  const MsdSalesReportSupervisor({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<MsdSalesReportSupervisor> createState() => _MsdSalesReportSupervisorState();
}

class _MsdSalesReportSupervisorState extends State<MsdSalesReportSupervisor> {

  late List<TopMenuItem> _menuList;

  @override
  void initState() {
    super.initState();
    _getMenuList();

  }

  _getMenuList(){
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    _menuList = [];
    //_menuList.add(TopMenuItem(image: Images.attendance, menuName: 'Notification', navigateTo: MsdNotificationScreen(),));
    _menuList.add(TopMenuItem(image: Images.notification_sales, menuName: 'Notification', navigateTo: SalesNotificationsSupervisor(),));
    //MsdNotificationScreen
    _menuList.add(TopMenuItem(image: Images.sales_sammary, menuName: 'Sales Summary', navigateTo: SalesSummary(),));
    _menuList.add(TopMenuItem(image: Images.pay_slip, menuName: 'Balanc Conf.', navigateTo: CustBalanceConfirmation(),));
    _menuList.add(TopMenuItem(image: Images.cust_target_achivement, menuName: 'Target vs Achievement', navigateTo: CustTargetVsAchiv()));
    _menuList.add(TopMenuItem(image: Images.item_pending, menuName: 'ItemWPending', navigateTo: ItemWisePending(),));
    _menuList.add(TopMenuItem(image: Images.delivery_info, menuName: 'Delivery Info', navigateTo: DeliveryInfoScreen(),));

  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context,listen: false).getApplicationList(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
              title: 'MSD Sales Report',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
              }),

            Expanded(child: SingleChildScrollView(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 8.0, right : 8.0, top: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio:1.36,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16
                ),
                itemCount: _menuList.length,
                itemBuilder: (BuildContext ctx, index) {
                  return _menuList[index];
                }
              ),

                /*Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 10.0 ),
                  child: Text('Application List',style: titilliumBold,),
                ),

                Consumer<UserProvider>(
                    builder: (context,userProvider,child){

                      List<SelfServiceModel> _applicationList = userProvider.applicationList;

                        return ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: _applicationList.length,
                            itemBuilder: (context,index){

                              SelfServiceModel application = _applicationList[index];

                              return InkWell(
                                onTap: (){
                                  print(' On Click Application Item $index');
                                  if ( application.applicationType!.contains("Leave")){
                                    //Navigator.push(context, MaterialPageRoute(builder: (_) =>  ApprovalHistoryScreen(invoiceId: application.reportHeaderId!)));
                                  }else {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  LoanApprovalHistoryScreen(headerId: application.reportHeaderId!)));
                                  }

                                },
                                child: Padding (
                                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 10.0),
                                  child: Container(
                                    color: ColorResources.getGrey(context),
                                    padding:  EdgeInsets.all( Dimensions.PADDING_SIZE_SMALL),
                                    child: Column (

                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${application.applicationType}',style: titilliumRegular,),
                                            Text('${application.realTime}',style: titilliumRegular,)
                                          ],),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${application.createdDate}',style: titilliumRegular,),
                                            Container(
                                                color: application.statusFlg! == 'In-Process'?Colors.blue : application.statusFlg! == 'Approved'?Colors.green:Colors.red,
                                                child: Text('${application.statusFlg}',style: titilliumRegular,))
                                          ],)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );

                    }
                )*/
            ],
          ),)),
        ],
      ),
    );
  }
}
