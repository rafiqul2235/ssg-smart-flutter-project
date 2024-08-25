import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/management_dashboard_model.dart';
import 'package:ssg_smart2/data/model/response/management_dashboard_model_gcf.dart';

import '../../../provider/leave_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';


class ManagementDashboardGCF extends StatefulWidget {
  final bool isBackButtonExist;
  final String data;


  const ManagementDashboardGCF({Key? key, this.isBackButtonExist = true, required this.data})
      : super(key: key);
  @override
  State<ManagementDashboardGCF> createState() => _ManagementDashboardGCFState();
}


class _ManagementDashboardGCFState extends State<ManagementDashboardGCF> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  //late final String source;

  ManagementDashboardModelGCF? _dashboardModel = ManagementDashboardModelGCF(
    insert_date: '',month_date: '',year_date: '',date: '',
    scbl_call: '',sscml_call: '',sscil_call: '',gcf_call:'',sspil_call: '',
    so_amt_scbl:'',so_amt_sscml:'',so_amt_sscil:'',so_amt_gcf:'',so_amt_sspil:'',
    scbl_received:'',sscml_received:'',sscil_received:'',gcf_received:'',sspil_received:'',
    so_scbl:'',so_sscml:'',so_sscil:'',so_gcf:'',so_sspil:'',
    total_call:'',total_so_amt:'',total_so:'',total_call_per:'',
    target_scbl:'',target_sscml:'',target_sscil:'',target_gcf:'',total_mon:'',
    delivery_scbl:'',delivery_sscml:'',delivery_sscil:'',delivery_gcf:'',total_delivery:'',
    achi_scbl:'',achi_sscml:'',achi_sscil:'',achi_gcf:'',total_achi:'',
    pending_scbl:'',pending_sscml:'',pending_sscil:'',pending_gcf:'',total_pending:'',
    pro_scbl:'',pro_sscml:'',pro_sscil:'',pro_gcf:'',total_pro:'',
    capa_scbl:'',capa_sscml:'',capa_sscil:'',capa_gcf:'',total_capa:'',
    uit_scbl:'',uit_sscml:'',uit_sscil:'',uit_gcf:'',total_uit:'',
  );


  @override
  void initState() {
    super.initState();
    _intData();
  }

  _intData() async {
    print("Pass value: ${widget.data}");
    _dashboardModel =  await Provider.of<LeaveProvider>(context, listen: false).getManageDashbDataGcf(context,widget.data);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<LeaveProvider>(context).loading;
    return Scaffold(
        key: _scaffoldKey,
        body:Column(
          children: [
            CustomAppBar(
                title: 'Snapshot : ${_dashboardModel?.date}',
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
                                              child: Center(child: Text('SCBL',style:titilliumSemiBold.copyWith(fontSize: 14))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCML',style:titilliumSemiBold.copyWith(fontSize: 12))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSCIL',style:titilliumSemiBold.copyWith(fontSize: 14))),
                                            ),

                                            /*Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SSPIL',style:titilliumSemiBold.copyWith(fontSize: 12))),
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Total',style:titilliumSemiBold.copyWith(fontSize: 14))),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('GCF',style:titilliumSemiBold.copyWith(fontSize: 14))),
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
                                              child: Center(child: Text('${_dashboardModel?.so_amt_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_sscil}',style: titilliumRegular)),
                                            ),

                                            /*Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_month_sspil}',style: titilliumRegular)),
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_so_amt}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_amt_gcf}',style: titilliumRegular)),
                                            ),

                                          ]
                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Collecttion(core)',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.scbl_call}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_call}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_call}',style: titilliumRegular)),
                                            ),

                                            /* Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sspil_call_mon}',style: titilliumRegular)),
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_call}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.gcf_call}',style: titilliumRegular)),
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
                                              child: Center(child: Text('${_dashboardModel?.scbl_received}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscml_received}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sscil_received}',style: titilliumRegular)),
                                            ),

                                            /* Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.sspil_received_mon}',style: titilliumRegular)),
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_received}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.gcf_received}',style: titilliumRegular)),
                                            ),

                                          ]

                                      ),

                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('SO Qty. (MT)',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_sscil}',style: titilliumRegular)),
                                            ),

                                            /*Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_mon_sspil}',style: titilliumRegular)),
                                            ),*/
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_so}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.so_gcf}',style: titilliumRegular)),
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
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('GCF',style:titilliumSemiBold.copyWith(fontSize: 16))),
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
                                              child: Center(child: Text('Target',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.target_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.target_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.target_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.target_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_mon}',style: titilliumRegular)),
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
                                              child: Center(child: Text('${_dashboardModel?.delivery_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.delivery_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.delivery_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.delivery_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_delivery}',style: titilliumRegular)),
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
                                              child: Center(child: Text('${_dashboardModel?.achi_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.achi_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.achi_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.achi_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_achi}',style: titilliumRegular)),
                                            ),

                                          ]

                                      ),
                                      TableRow (
                                          decoration: BoxDecoration(color:Colors.green.shade50),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('Pending SO',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pending_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pending_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pending_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pending_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_pending}',style: titilliumRegular)),
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
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('GCF',style:titilliumSemiBold.copyWith(fontSize: 16))),
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
                                              child: Center(child: Text('Capacity',style:titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.capa_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.capa_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.capa_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.capa_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_capa}',style: titilliumRegular)),
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
                                              child: Center(child: Text('${_dashboardModel?.pro_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pro_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pro_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.pro_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_pro}',style: titilliumRegular)),
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
                                              child: Center(child: Text('${_dashboardModel?.uit_scbl}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.uit_sscml}',style: titilliumRegular)),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.uit_sscil}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.uit_gcf}',style: titilliumRegular)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0,bottom: 8.0),
                                              child: Center(child: Text('${_dashboardModel?.total_uit}',style: titilliumRegular)),
                                            ),

                                          ]

                                      ),

                                    ]
                                ),

                              ),
                              Text('*Currency AED For GCF',style: titilliumRegular.copyWith(fontSize: 12)),
                              Text('*Figure in Thousand',style: titilliumRegular.copyWith(fontSize: 12)),
                              Text('*UOM -- MT',style: titilliumRegular.copyWith(fontSize: 12)),
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
