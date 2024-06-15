import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/view/screen/empselfservice/widget/top_menu.dart';
import 'package:ssg_smart2/view/screen/leave/pf_ledger_screen.dart';
import '../../../data/model/response/self_service.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/custom_app_bar.dart';
import '../leave/leave_application_screen.dart';
import '../notification/notification_screen.dart';
import 'approval_history.dart';

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

    Provider.of<UserProvider>(context,listen: false).getApplicationList(context);

    _getMenuList();

  }

  _getMenuList(){
    _menuList = [];
    _menuList.add(TopMenuItem(image: Images.ic_communication_email, menuName: 'Attendance', navigateTo: NotificationScreen(),));
    _menuList.add(TopMenuItem(image: Images.ic_communication_email, menuName: 'Chuti', navigateTo: LeaveApplicationScreen(),));
    _menuList.add(TopMenuItem(image: Images.ic_communication_email, menuName: 'PaySlip', navigateTo: NotificationScreen(),));
    _menuList.add(TopMenuItem(image: Images.ic_communication_email, menuName: 'Salary Adv.', navigateTo: NotificationScreen(),));
    _menuList.add(TopMenuItem(image: Images.ic_communication_email, menuName: 'PF Loan', navigateTo: NotificationScreen(),));
    _menuList.add(TopMenuItem(image: Images.ic_communication_email, menuName: 'PF Ledger', navigateTo: PFLedgerPage(),));

  }


  @override
  Widget build(BuildContext context) {

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
               /* Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ApprovalHistory()));*/
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
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ApprovalHistory()));

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
