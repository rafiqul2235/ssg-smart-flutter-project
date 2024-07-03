import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/approval_list_model.dart';
import '../../../provider/leave_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../empselfservice/approval_history.dart';
import '../home/dashboard_screen.dart';

class ApprovalListPage extends StatefulWidget {
  final bool isBackButtonExist;
  const ApprovalListPage({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<ApprovalListPage> createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  List<ApprovalListModel> _approvalListModel = [];

  @override
  void initState() {
    super.initState();

    _intData();


  }

  _intData() async {
    //_approvalListModel =  await Provider.of<LeaveProvider>(context, listen: false).getApprovalListData(context);
    Provider.of<LeaveProvider>(context,listen: false).getApprovalListData(context);
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
              title: 'Approval List ',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const DashBoardScreen()));
              }
              ),

          Expanded(child: SingleChildScrollView(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             /* GridView.builder(
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
              ),*/

              Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 10.0 ),
                //child: Text('Approval List',style: titilliumBold,),
              ),

              Consumer<LeaveProvider>(
                  builder: (context,userProvider,child){

                    List<ApprovalListModel> _approvalList = userProvider.approvalList;
                    print('approvaList  ${_approvalList.length}');

                    return ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: _approvalList.length,
                        itemBuilder: (context,index){

                          ApprovalListModel approval = _approvalList[index];

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
                                       Text('Notification Id : ${approval.notificationId}',style: titilliumRegular,),
                                        //Text('${approval.subject}',style: titilliumRegular,)
                                      ],),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${approval.subject}',style: titilliumRegular,),
                                        Container(
                                            //color: application.statusFlg! == 'In-Process'?Colors.blue : application.statusFlg! == 'Approved'?Colors.green:Colors.red,
                                           // child: Text('${approval.notificationId}',style: titilliumRegular,)
                                          )
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
