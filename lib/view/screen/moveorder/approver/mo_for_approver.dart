import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/mo_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';
import 'package:ssg_smart2/view/screen/moveorder/test_table.dart';

import '../../../../data/model/response/user_info_model.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utill/timeago_util.dart';
import '../../../basewidget/custom_app_bar.dart';
import '../easy_table.dart';
import 'approval_mo_details.dart';

class ApprovalMoveOrderScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const ApprovalMoveOrderScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  _ApprovalMoveOrderScreenState createState() => _ApprovalMoveOrderScreenState();
}

class _ApprovalMoveOrderScreenState extends State<ApprovalMoveOrderScreen> {

  Color getColorAsStatus(String status) {
    switch (status) {
      case 'In-complete':
        return Colors.grey;
      case 'In-process':
        return Colors.yellow;
      case 'Approved':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
    _intData();
  }

  _intData() async {
    setState(() {});
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    String employeeNumber = userInfoModel?.employeeNumber ?? '';
    Provider.of<MoveOrderProvider>(context, listen: false).fetchApproverMoList(employeeNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Approval MO List',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const DashBoardScreen()
          ));
        },
      ),
      body: Consumer<MoveOrderProvider>(
        builder: (context, moProvider, child) {
          if (moProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (moProvider.approverList.isEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'MO list',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total: ${moProvider.moList.length} items',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: moProvider.moList.length,
                      itemBuilder: (context, index) {
                        final mo = moProvider.moList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ApproverMoDetails(moveOrderItem: mo,)
                                  // builder: (context) => FixedHeaderTable(),
                                )
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Card(
                            color: const Color(0xFFFFF2DE),
                            margin: EdgeInsets.symmetric(vertical: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
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
                                            Text('MO: #${mo.moveOrderNumber}', style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text(
                                              'Org Name: ${mo.orgName}',
                                              style: TextStyle(fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                          ],
                                        ),
                                      ),
                                      Text(TimeAgoUtils.formatTimeAgo(mo.lastUpdateDate!), style: TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${mo.dateRequired}', style: TextStyle(color: Colors.black54)),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: getColorAsStatus(mo.headerStatusName!),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Pending',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
