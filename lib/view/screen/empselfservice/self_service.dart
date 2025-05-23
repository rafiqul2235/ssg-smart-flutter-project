import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/view/screen/empselfservice/loan_approval_history.dart';
import 'package:ssg_smart2/view/screen/empselfservice/widget/top_menu.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';
import 'package:ssg_smart2/view/screen/leave/leave_application_screen.dart';
import 'package:ssg_smart2/view/screen/payslip/pay_slip.dart';
import 'package:ssg_smart2/view/screen/pfledger/pf_ledger_screen.dart';
import 'package:ssg_smart2/view/screen/pfloan/pf_loan.dart';
import 'package:ssg_smart2/view/screen/salaryloan/salary_loan.dart';
import 'package:ssg_smart2/view/screen/wppfledger/wppf_ledger_screen.dart';
import '../../../data/model/response/self_service.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/custom_app_bar.dart';
import '../attendence/attendance_sheet_screen.dart';
import '../home/web_view_screen.dart';
import 'leave_approval_history.dart';

class SelfService extends StatefulWidget {
  final bool isBackButtonExist;
  const SelfService({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<SelfService> createState() => _SelfServiceState();
}

class _SelfServiceState extends State<SelfService> {

  late List<TopMenuItem> _menuList;

  @override
  void initState() {
    super.initState();
    _getMenuList();

  }

  _getMenuList(){
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    _menuList = [];
    _menuList.add(TopMenuItem(image: Images.attendance, menuName: 'Attendance', navigateTo: AttendanceSheetPage(),));
    _menuList.add(TopMenuItem(image: Images.leave, menuName: 'Chuti', navigateTo: LeaveApplicationScreen(),));
    _menuList.add(TopMenuItem(image: Images.pay_slip, menuName: 'PaySlip', navigateTo: PayslipScreen(),));
    // Allow *Salary Adv* for OFC employee
    if (userInfoModel!.employmentCategory!.contains("OFC")) {
      _menuList.add(TopMenuItem(image: Images.salary_advance, menuName: 'Salary Adv.', navigateTo: SalaryAdvanceScreen(),));
    }
    _menuList.add(TopMenuItem(image: Images.pf_loan, menuName: 'PF Loan', navigateTo: PfLoanScreen(),));
    _menuList.add(TopMenuItem(image: Images.pf_ledger, menuName: 'PF Ledger', navigateTo: PFLedgerPage(),));
    _menuList.add(TopMenuItem(image: Images.wppf_ledger1, menuName: 'WPPF Ledger', navigateTo: WppfLedgerScreen()));
    _menuList.add(TopMenuItem(image: Images.visiting_card, menuName: 'Requisition Visiting Card', navigateTo: WebViewScreen(
      title:'Apply Form for Visiting Card',
      url: 'https://apps.powerapps.com/play/e/default-acaaa1ae-6712-466b-8710-039ed61261a4/a/d9152109-d432-4b3b-8e2a-8b8e97e84e7c?tenantId=acaaa1ae-6712-466b-8710-039ed61261a4&hint=b24b6e27-69c3-4454-995c-04c08e77d595&sourcetime=1725943252723',
    )));
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
              title: 'Emp Self Service',
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

                Padding(
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
                                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  ApprovalHistoryScreen(invoiceId: application.reportHeaderId!)));
                                  }else {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  LoanApprovalHistoryScreen(applicationType: application.applicationType!, headerId: application.reportHeaderId!)));
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
                )
            ],
          ),)),
        ],
      ),
    );
  }
}
