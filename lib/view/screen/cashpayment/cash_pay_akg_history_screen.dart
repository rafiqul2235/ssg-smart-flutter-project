import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/cashpayment_model.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class CashPaymentHistory extends StatefulWidget {
  final bool isBackButtonExist;
  const CashPaymentHistory({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<CashPaymentHistory> createState() => _CashPaymentHistoryState();
}

class _CashPaymentHistoryState extends State<CashPaymentHistory> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  List<CashPaymentModel> _cashPayHistory = [];

  @override
  void initState() {
    super.initState();

    _intData();


  }

  _intData() async {
    _cashPayHistory =  await Provider.of<CashPaymentProvider>(context, listen: false).getPaymentHistory(context);
    //_pfSummary =  await Provider.of<LeaveProvider>(context, listen: false).getPfLedgerSummaryData(context);
    print('cashPayList  ${_cashPayHistory?.length}');
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            CustomAppBar(
                title: 'History Page',
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home,
                onActionPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const DashBoardScreen()));
                }),

       //     Center(child: Text('PF Ledger Details',style: titilliumBold.copyWith(fontSize: 18))),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(1.0),
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

                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              color:Colors.white.withOpacity(0.5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Report Type',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Invoice Number',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Period Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Sent Time',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Accepted Time',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                      DataColumn(label: Text('Amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))),
                                    ],
                                    //border: TableBorder.all(color: Colors.grey.shade200, width: 5),
                                    border: TableBorder.all(),
                                    rows: [
                                      for(CashPaymentModel modelItem in _cashPayHistory)  _cashPayTableRow (modelItem),
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

  DataRow _cashPayTableRow (CashPaymentModel? cashPayModel){

    return DataRow (
        //decoration: BoxDecoration(color:Colors.green.shade50),
        cells: [

          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 0.0,left: 0.0,right: 0.0,bottom: 0.0),
              child: Center(child: Text('${cashPayModel?.reportType}',style: titilliumRegular)),
            ),
          ),

          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 1.0,left: 1.0,right: 1.0,bottom: 1.0),
              child: Center(child: Text('${cashPayModel?.status}',style: titilliumRegular)),
            ),
          ),

          DataCell(
           Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${cashPayModel?.invoice_num}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${cashPayModel?.periodName}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${cashPayModel?.sentTime}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${cashPayModel?.acceptedTime}',style: titilliumRegular)),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 2.0,left: 2.0,right: 2.0,bottom: 2.0),
              child: Center(child: Text('${cashPayModel?.amount}',style: titilliumRegular)),
            ),
          ),

        ]
    );

  }


}
