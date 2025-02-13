import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/approval/widget/confirmation_dialog.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/my_dialog.dart';
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
    Provider.of<ApprovalProvider>(context, listen: false).fetchApprovalFlow(employeeNumber);
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

  void _handleApprovalAction(BuildContext context, ApprovalFlow approvalFlow, bool isApprove) {
    String notificationId = approvalFlow.notificationId;
    String action = isApprove ? "APPROVED" : "REJECTED";
    showAnimatedDialog(
        context,
        ConfirmationDialog(
            applicationType: 'LEAVE',
            notificationId: notificationId,
            action: action,
            comment: _commentControllers[notificationId]!.text,
            isApprove: isApprove,
            onResult: (isSuccess, message) {
              _showResultDialog(context, isSuccess, message);
              _reloadPage();
              _commentControllers[notificationId]!.clear();
            }
        ),
      isFlip: true,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Approval',
          isBackButtonExist: widget.isBackButtonExist,
          icon: Icons.home,
          onActionPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const DashBoardScreen()));
          }
      ),
      body: Consumer<ApprovalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.error.isNotEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          } else {
            return ListView.builder(
              itemCount: provider.approvalFlows.length,
              itemBuilder: (context, index) {
                final approval = provider.approvalFlows[index];
                _commentControllers.putIfAbsent(approval.notificationId, () => TextEditingController());
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
                          top(context, approval),
                          bottom(approval, _commentControllers[approval.notificationId]!),
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

  Widget top(BuildContext context, ApprovalFlow approvalFlow) {
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
                      "${approvalFlow.leaveType}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${approvalFlow.leaveDuration} day  •  ${approvalFlow.leaveStartDate} - ${approvalFlow.leaveEndDate}",
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
                  "${approvalFlow.statusFlg}",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Leave Balance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
          ),
          SizedBox(height: 6),
          Row(
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
          ),
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
          Text(
            "$days",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
          ),
        ],
      ),
    );
  }
  Widget bottom(ApprovalFlow approvalFlow, TextEditingController _commentController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100],
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
                    Text(
                      '${approvalFlow.employeeName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${approvalFlow.designation}(${approvalFlow.employeeNumber})",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                      "${approvalFlow.reason}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
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
                onPressed: () => _handleApprovalAction(context, approvalFlow, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Reject',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _handleApprovalAction(context, approvalFlow, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: Size(0, 36),
                ),
                child: const Text(
                  'Approve',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

