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
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class CashPaymentAkgPage extends StatefulWidget {
  final bool isBackButtonExist;
  const CashPaymentAkgPage({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<CashPaymentAkgPage> createState() => _CashPaymentAkgPageState();
}

class _CashPaymentAkgPageState extends State<CashPaymentAkgPage> {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Payment Acknowledgment',
          isBackButtonExist: widget.isBackButtonExist,
          icon: Icons.home,

          onActionPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const ManagementDMenu()));
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
                      //"iExpense",
                      "${cashPayModel.reportType}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange[800]),
                    ),
                    Text(
                      //"iExpense",
                      "TransId: ${cashPayModel.transactionId}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Sent Date : ${cashPayModel.sentTime}",
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
                 "৳${cashPayModel.amount}",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Invoice Number: ${cashPayModel.invoice_num}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
          ),
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

  Widget _leaveTypeBox(String leaveType, String days) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        children: [
          Text(
            leaveType,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
  Widget bottom(CashPaymentModel approvalFlow) {
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
                      "Accept to proceed payment, else Reject please",
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
              // Expanded(
              //   flex: 2,
              //   child: SizedBox(
              //     height: 36,
              //     child: TextField(
              //      // controller: _commentController,
              //       decoration: InputDecoration(
              //         hintText: 'Enter comment...',
              //         hintStyle: TextStyle(fontSize: 14),
              //         fillColor: Colors.white,
              //         filled: true,
              //         contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  String notificationId = approvalFlow.transactionId;
                  String empId = approvalFlow.employeeNumber;
                  showAnimatedDialog(
                      context,
                      ConfirmationDialogCashP(
                        notificationId: notificationId,
                        action: "Rejected",
                        empId: empId,
                        isApprove: false,
                        onConfirmed: () {
                          _reloadPage();
                          _commentControllers[notificationId]!.clear();
                        },
                      ),
                      isFlip: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Reject',
                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  String notificationId = approvalFlow.transactionId;
                  String empId = approvalFlow.employeeNumber;
                  showAnimatedDialog(
                      context,
                      ConfirmationDialogCashP(
                        notificationId: notificationId,
                        action: "Accepted",
                        empId: empId,
                        //comment: _commentControllers[notificationId]!.text,
                        isApprove: true,
                        onConfirmed: () {
                          _reloadPage();
                          _commentControllers[notificationId]!.clear();
                        },
                      ),
                      isFlip: true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Accept',
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

