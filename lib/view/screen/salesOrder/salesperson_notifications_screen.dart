import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';
import 'package:ssg_smart2/data/model/response/cashpayment_model.dart';
import 'package:ssg_smart2/data/model/response/rsm_approval_flow_model.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/approval/widget/confirmation_dialog.dart';
import 'package:ssg_smart2/view/screen/cashpayment/widget/confirmation_dialog_cashP.dart';
import 'package:ssg_smart2/view/screen/managementdashboard/managemrnt_d_menu.dart';
import 'package:ssg_smart2/view/screen/salesOrder/confirmation_dialog_soBooked.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/images.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/my_dialog.dart';
import '../cashpayment/cash_pay_akg_history_screen.dart';

class SalespersonNotificationScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const SalespersonNotificationScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<SalespersonNotificationScreen> createState() => _SalespersonNotificationScreenState();
}

class _SalespersonNotificationScreenState extends State<SalespersonNotificationScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  String? employeeNumber;

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
    employeeNumber = userInfoModel?.employeeNumber ?? '';
    Provider.of<CashPaymentProvider>(context, listen: false).fetchRsmApprovalListData(employeeNumber!);
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

  void _handleApprovalAction(BuildContext context, RsmApprovalFlowModel rsmApproval, bool isApprove) {
    print("Handle data: $rsmApproval");
    String salesOrderId = rsmApproval.salesorderMstId;
    String commit = "Notok com pio";
    String lastUpdatedBy = employeeNumber!;
    String messageAtt3 = "Booked from SMART Apps";
    String status = isApprove ? "S" : "N";
    showAnimatedDialog(
      context,
      ConfirmationDialogSoBooked(
          salesOrderId: salesOrderId,
          status: status,
          commet: _commentControllers[salesOrderId]!.text,
          lastUpdatedBy: lastUpdatedBy,
          messageAtt3: messageAtt3,
          isApprove: isApprove,
          onResult: (isSuccess, message) {
            _showResultDialog(context, isSuccess, message);
            _reloadPage();
            _commentControllers[salesOrderId]!.clear();
          }
      ),
      isFlip: true,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Approval for SO Booked ',
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
          }
         else if (provider.error.isNotEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          }
          else {
            return ListView.builder(
              itemCount: provider.rsmApprovalFlowModel.length,
              itemBuilder: (context, index) {
                final approval = provider.rsmApprovalFlowModel[index];
                _commentControllers.putIfAbsent(approval.salesorderMstId, () => TextEditingController());
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
                          bottom(approval,_commentControllers[approval.salesorderMstId]!),
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

  Widget top(BuildContext context,RsmApprovalFlowModel rsmApprovalModel) {

    return Container(
      padding: const EdgeInsets.all(5),
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
                      "Ref. Number : ${rsmApprovalModel.salesorderMstId}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "Creation Date : ${rsmApprovalModel.creationDate}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      //"iExpense",
                      "${rsmApprovalModel.customerName}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange[800]),
                    ),
                    Text(
                      "Ship to Site : ${rsmApprovalModel.shipTositeName}",
                      style: TextStyle(fontSize: 16, color: Colors.orange[800]),
                    ),
                    Text(
                      //"iExpense",
                      "${rsmApprovalModel.srName}",
                      style: TextStyle(fontSize: 14, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      //"iExpense",
                      "Balance : ${rsmApprovalModel.custBalance}",
                      style: TextStyle(fontSize: 14, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      //"iExpense",
                      "Item Name : ${rsmApprovalModel.itemName}",
                      style: TextStyle(fontSize: 14, color: Colors.orange[800]),
                    ),
                    /*Text(
                      //"iExpense",
                      "Freight Tarm : ${rsmApprovalModel.freight}",
                      style: TextStyle(fontSize: 14, color: Colors.orange[800]),
                    ),*/
                  ],
                ),
              ),
             // SizedBox(height: 18),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.circular(20),
                ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Request Qty.",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14),
      ),
      Text(
        "${rsmApprovalModel.itemQty} - (${rsmApprovalModel.freight}-${rsmApprovalModel.itemUom})",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14),
      ),
      Text(
        "Order Total: ${rsmApprovalModel.orderTotal}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 14),
      ),
    ]
    )

              )
            ],
          ),
          SizedBox(height: 8),

          //SizedBox(height: 1),
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

  Widget bottom(RsmApprovalFlowModel rsmApproval,TextEditingController _commentController) {
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
                    /*Text(
                      "Accept to proceed payment, else Reject please",
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    ),*/
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
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Enter comment...',
                      hintStyle: TextStyle(fontSize: 14),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _handleApprovalAction(context, rsmApproval, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _handleApprovalAction(context, rsmApproval, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'SO Booked',
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

