import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';
import 'package:ssg_smart2/data/model/response/cashpayment_model.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/approval/widget/confirmation_dialog.dart';
import 'package:ssg_smart2/view/screen/cashpayment/widget/confirmation_dialog_cashP.dart';
import 'package:ssg_smart2/view/screen/managementdashboard/managemrnt_d_menu.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/images.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/my_dialog.dart';
import '../home/dashboard_screen.dart';
import 'cash_pay_akg_history_screen.dart';

class AitApprovalPage extends StatefulWidget {
  final bool isBackButtonExist;
  const AitApprovalPage({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<AitApprovalPage> createState() => _AitApprovalPageState();
}

class _AitApprovalPageState extends State<AitApprovalPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  // final TextEditingController _commentController = TextEditingController();
  final Map<String, TextEditingController> _commentControllers = {};

  @override
  void initState() {
    super.initState();
    _intData();
  }

  void _reloadPage() {
    setState(() {
      _intData();
    });
  }
  @override
  void dispose() {
    _commentControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  _intData() async {
    setState(() {});
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    String employeeNumber = userInfoModel?.employeeNumber ?? '';
    Provider.of<CashPaymentProvider>(context, listen: false).fetchCashPayData(employeeNumber);
  }



  void _showResultDialog(BuildContext context, bool isSuccess, String message) {
    showAnimatedDialog(
      context,
      MyDialog(
        icon: isSuccess ? Icons.check : Icons.error,
        title: isSuccess ? 'Success' : 'Error',
        description: message,
        rotateAngle: 0,
        positionButtonTxt: 'Ok',
      ),
      dismissible: false,
    );
  }

  void _handleApprovalAction(BuildContext context, CashPaymentModel cashPayment, bool isApprove) {
    print("Handle data: $cashPayment");
    String transactionId = cashPayment.transactionId;
    String empId = cashPayment.employeeNumber;
    String action = isApprove ? "Accepted" : "Rejected";
    showAnimatedDialog(
      context,
      ConfirmationDialogCashP(
          transactionId: transactionId,
          action: action,
          empId: empId,
          isApprove: isApprove,
          onResult: (isSuccess, message) {
            _showResultDialog(context, isSuccess, message);
            _reloadPage();
          }
      ),
      isFlip: true,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
          title: 'AIT Approval List',
          isBackButtonExist: widget.isBackButtonExist,
          icon: Icons.history,

          onActionPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const CashPaymentHistory()));
          }
      ),


      body: Consumer<CashPaymentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.error.isNotEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          } else {
            return ListView.builder(
              itemCount: provider.cashPaymentModel.length,
              itemBuilder: (context, index) {
                final approval = provider.cashPaymentModel[index];
                //_commentControllers.putIfAbsent(approval.notificationId, () => TextEditingController());
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.blue,
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.1),
                      onTap: () {
                        debugPrint("Card is pressed");
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          top(context,approval),
                          bottom(approval),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget top(BuildContext context,CashPaymentModel cashPayModel) {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[50]!, Colors.orange[50]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Name: ABC Building Products Ltd",
                      //"${cashPayModel.reportType}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange[800]),
                    ),
                    Text(
                      //"iExpense",
                      //"TransId: ${cashPayModel.transactionId}",
                      "Challan No : 2425-00047965931",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange[800]),
                    ),
                    Text(
                      //"iExpense",
                      //"TransId: ${cashPayModel.transactionId}",
                      "Invoice Amount : 990000",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange[800]),
                    ),
                    Text(
                      //"iExpense",
                      //"TransId: ${cashPayModel.transactionId}",
                      "AIT Amount : 17000",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 14),
                    Text(
                     // "Sent Date : ${cashPayModel.sentTime}",
                      "Challan Date : 01-Sep-2024",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                 //"৳${cashPayModel.amount}",
                  "Attach view",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          /*Text(
            "Invoice Number: ${cashPayModel.invoice_num}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
          ),*/
          SizedBox(height: 6),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _leaveTypeBox("Casual", approvalFlow.casual)),
              SizedBox(width: 8),
              Expanded(child: _leaveTypeBox("Sick", approvalFlow.sick)),
              SizedBox(width: 8),
              Expanded(child: _leaveTypeBox("Earn", approvalFlow.earn)),
              SizedBox(width: 8),
              Expanded(child: _leaveTypeBox("Comp.", approvalFlow.compensatory)),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget bottom(CashPaymentModel cashPayment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[30],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   /* Text(
                      '',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),*/
                    SizedBox(height: 4),
                    Text(
                      "Note : Enter your Note",

                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              /*Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${approvalFlow.status}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _handleApprovalAction(context, cashPayment, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Rejected ',
                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _handleApprovalAction(context, cashPayment, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Approved',
                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

