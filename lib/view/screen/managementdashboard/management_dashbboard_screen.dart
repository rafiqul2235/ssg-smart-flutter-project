import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/management_dashboard_model.dart';

import '../../../provider/leave_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class ManagementDashboard extends StatefulWidget {
  final bool isBackButtonExist;
  const ManagementDashboard({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<ManagementDashboard> createState() => _ManagementDashboardState();
}

class _ManagementDashboardState extends State<ManagementDashboard> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  ManagementDashboardModel? _dashboardModel = ManagementDashboardModel(
      scbl_call_mon: 0,sscml_call_mon: 0,sscil_call_mon: 0,
      so_amt_month_scbl:0,so_amt_month_sscml:0,so_amt_month_sscil:0,
      scbl_received_mon:'',sscml_received_mon:'',sscil_received_mon:'',
      so_mon_scbl:0,so_mon_sscml:0,so_mon_sscil:0
  );

  @override
  void initState() {
    super.initState();

    _intData();

  }

  _intData() async {
    _dashboardModel =  await Provider.of<LeaveProvider>(context, listen: false).getManageDashbData(context);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            CustomAppBar(
                title: 'Management Dashboard',
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home,
                onActionPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const DashBoardScreen()));
                }),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorResources.getIconBg(context),
                              borderRadius: BorderRadius.only(
                                topLeft:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                topRight:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                              )),
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            physics: BouncingScrollPhysics(),
                            children: [

                              /* Leave Balance */
                              Center(child: Text('Sales VS Collection',style: titilliumBold.copyWith(fontSize: 20))),

                              Container(
                                color:Colors.blueAccent.withOpacity(0.7),
                                child: Table(
                                  //defaultColumnWidth: IntrinsicColumnWidth(),
                                  //defaultColumnWidth: FixedColumnWidth(),
                                    columnWidths: {
                                      //0:FractionColumnWidth(0.23),
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(1.0),
                                      2: FlexColumnWidth(1.0),
                                      3: FlexColumnWidth(1.0),
                                      4: FlexColumnWidth(1.0),

                                    },
                                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                    border: TableBorder.all(),
                                    children: [
                                      /* Header Row */
                                      TableRow (
                                          decoration: const BoxDecoration(color: Colors.transparent),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SCBL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCML',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCIL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSPIL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Total',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),


                                          ]
                                      ),
                                      /* Data Row */
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Revenue (core)',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscil}',style: titilliumRegular)),
                                            ),

                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Collecttion (core)',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.scbl_call_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_call_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_call_mon}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_call_mon}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_call_mon}',style: titilliumRegular)),
                                            ),
                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Receivable (%)',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                                child: Center(child: Text('${_dashboardModel?.scbl_received_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_received_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_received_mon}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_received_mon}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_received_mon}',style: titilliumRegular)),
                                            ),

                                          ]

                                      ),

                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.orange.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SO Qty. (MT)',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sscil}',style: titilliumRegular)),
                                            ),

                                          ]
                                      ),

                                    ]
                                ),
                              ),
                              Center(child: Text('Target VS Achievement',style: titilliumBold.copyWith(fontSize: 20))),
                              Container(
                                color:Colors.blueAccent.withOpacity(0.7),
                                child: Table(
                                  //defaultColumnWidth: IntrinsicColumnWidth(),
                                  //defaultColumnWidth: FixedColumnWidth(),
                                    columnWidths: {
                                      //0:FractionColumnWidth(0.23),
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(1.0),
                                      2: IntrinsicColumnWidth(),
                                      3: FlexColumnWidth(1.0),
                                    },
                                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                    border: TableBorder.all(),
                                    children: [
                                      /* Header Row */
                                      TableRow (
                                          decoration: const BoxDecoration(color: Colors.transparent),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SCBL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCML',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCIL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),


                                          ]
                                      ),
                                      /* Data Row */
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Target',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscil}',style: titilliumRegular)),
                                            ),

                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Delivered',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.scbl_call_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_call_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_call_mon}',style: titilliumRegular)),
                                            ),
                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Achievement',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.scbl_received_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_received_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_received_mon}',style: titilliumRegular)),
                                            ),

                                          ]

                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.orange.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Pending SO',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sscil}',style: titilliumRegular)),
                                            ),


                                          ]
                                      ),
                                    ]
                                ),
                              ),
                              Center(child: Text('Capacity VS Production',style: titilliumBold.copyWith(fontSize: 20))),
                              Container(
                                color:Colors.blueAccent.withOpacity(0.7),
                                child: Table(
                                  //defaultColumnWidth: IntrinsicColumnWidth(),
                                  //defaultColumnWidth: FixedColumnWidth(),
                                    columnWidths: {
                                      //0:FractionColumnWidth(0.23),
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(1.0),
                                      2: IntrinsicColumnWidth(),
                                      3: FlexColumnWidth(1.0),
                                      4: IntrinsicColumnWidth()
                                    },
                                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                    border: TableBorder.all(),
                                    children: [
                                      /* Header Row */
                                      TableRow (
                                          decoration: const BoxDecoration(color: Colors.transparent),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SCBL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCML',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCIL',style:titilliumSemiBold.copyWith(fontSize: 16))),
                                            ),


                                          ]
                                      ),
                                      /* Data Row */
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Capacity',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sscil}',style: titilliumRegular)),
                                            ),

                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Production',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.scbl_call_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_call_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_call_mon}',style: titilliumRegular)),
                                            ),
                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Utilization',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.scbl_received_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_received_mon}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_received_mon}',style: titilliumRegular)),
                                            ),

                                          ]

                                      ),

                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
