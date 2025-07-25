import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/management_dashboard_model.dart';
import 'package:ssg_smart2/data/model/response/pf_ledger_model.dart';
import 'package:ssg_smart2/data/model/response/pf_ledger_summary_model.dart';

import '../../../provider/leave_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class PFLedgerPage extends StatefulWidget {
  final bool isBackButtonExist;
  const PFLedgerPage({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<PFLedgerPage> createState() => _PFLedgerPageState();
}

class _PFLedgerPageState extends State<PFLedgerPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  List<PfLedgerModel> _pfLedgerList = [];
  //List<PfLedgerSummaryModel> _pfLedgerSummaryList = [];

  PfLedgerSummaryModel? _pfSummary= PfLedgerSummaryModel(total_contribute: '',total_interest: '',total_loan: '',total_outstanding: '',total_recovered: '',total_balance: '');

  @override
  void initState() {
    super.initState();

    _intData();


  }

  _intData() async {
    _pfLedgerList =  await Provider.of<LeaveProvider>(context, listen: false).getPfLedgerData(context);
    _pfSummary =  await Provider.of<LeaveProvider>(context, listen: false).getPfLedgerSummaryData(context);
    print('pfLedgerList  ${_pfLedgerList?.length}');
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            CustomAppBar(
                title: 'PF Ledger Page',
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home,
                onActionPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const DashBoardScreen()));
                }),
            Center(child: Text('PF Ledger Summary',style: titilliumBold.copyWith(fontSize: 18))),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color:Colors.blueAccent.withOpacity(0.7),
                child: Table(
                  //defaultColumnWidth: IntrinsicColumnWidth(),
                  //defaultColumnWidth: FixedColumnWidth(),
                    columnWidths: {
                      //0:FractionColumnWidth(0.23),
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(1.0),

                    },
                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                    border: TableBorder.all(),
                    children: [
                      TableRow (
                          decoration: BoxDecoration(color:Colors.green.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('Total Contribution',style:titilliumRegular)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('${_pfSummary?.total_contribute}',style: titilliumRegular)),
                            ),

                          ]
                      ),
                      TableRow (
                          decoration: BoxDecoration(color:Colors.green.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('Total Profit / Interest',style:titilliumRegular)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('${_pfSummary?.total_interest}',style: titilliumRegular)),
                            ),


                          ]
                      ),

                      TableRow (
                          decoration: BoxDecoration(color:Colors.green.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('Total Loan Amount',style:titilliumRegular)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('${_pfSummary?.total_loan}',style: titilliumRegular)),
                            ),

                          ]
                      ),
                      TableRow (
                          decoration: BoxDecoration(color:Colors.green.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('Recovered Amount',style:titilliumRegular)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('${_pfSummary?.total_recovered}',style: titilliumRegular)),
                            ),

                          ]
                      ),

                      TableRow (
                          decoration: BoxDecoration(color:Colors.green.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('Outstanding Amount',style:titilliumRegular)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('${_pfSummary?.total_outstanding}',style: titilliumRegular)),
                            ),

                          ]
                      ),

                      TableRow (
                          decoration: BoxDecoration(color:Colors.green.shade50),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('Balance Amount',style:titilliumRegular)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
                              child: Center(child: Text('${_pfSummary?.total_balance}',style: titilliumRegular)),
                            ),

                          ]
                      ),

                    ]
                ),
              ),
            ),

            Center(child: Text('PF Ledger Details',style: titilliumBold.copyWith(fontSize: 18))),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          /*decoration: BoxDecoration(
                              color: ColorResources.getIconBg(context),
                              borderRadius: BorderRadius.only(
                                topLeft:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                topRight:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                              )),*/
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              color:Colors.white.withOpacity(0.5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  /* Header Row */
                                    columns: const [
                                      DataColumn(label: Text('Period',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      //DataColumn(label: Text('Customer Name', softWrap: true,style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Con. Employee',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Con. Employer',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Con. Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Pro. Employee',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('pro. Employeer',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('pro. Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Con With Profit',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Loan',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Recovery',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Outstanding',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Net Blance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                    ],
                                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                    border: TableBorder.all(),
                                    /* Data Row */
                                    rows: [
                                      for(PfLedgerModel modelItem in _pfLedgerList) _pfLedgerTableRow(modelItem),
                                    ]

                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  DataRow _pfLedgerTableRow (PfLedgerModel? pfLedgerModel){

    return DataRow (
        //decoration: BoxDecoration(color:Colors.green.shade50),
        cells: [

          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${pfLedgerModel?.period_name}',style: titilliumRegular)),
            ),
          ),
         // DataCell(Container(width: 130, child: Text(record.cust_name ?? '', softWrap: true))),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 1.0,left: 1.0,right: 1.0,bottom: 1.0),
              child: Center(child: Text('${pfLedgerModel?.con_employee}',style: titilliumRegular)),
            ),
          ),

          DataCell(
           Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.con_employer}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.con_total}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.pro_employee}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.pro_employer}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.pro_total}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.con_with_prof}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.loan_amt}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.recovery}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.outstanding}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${pfLedgerModel?.net_total}',style: titilliumRegular)),
            ),
          ),

        ]
    );

  }


}
