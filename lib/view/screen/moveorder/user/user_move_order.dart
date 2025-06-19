import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/mo_list.dart';
import 'package:ssg_smart2/provider/mo_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';
import 'package:ssg_smart2/view/screen/moveorder/approver/approval_mo_details.dart';
import 'package:ssg_smart2/view/screen/moveorder/user/mo_details.dart';

import '../../../../data/model/response/user_info_model.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utill/timeago_util.dart';
import '../../../basewidget/custom_app_bar.dart';

class UserMoveOrderScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const UserMoveOrderScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  _UserMoveOrderScreenState createState() => _UserMoveOrderScreenState();
}

class _UserMoveOrderScreenState extends State<UserMoveOrderScreen> {

  Color getColorAsStatus(String status) {
    switch (status) {
      case 'In-complete':
        return Colors.grey;
      case 'In-Process':
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
    final provider = Provider.of<MoveOrderProvider>(context, listen: false);
    // Reset the provider state before fetching new data
    provider.resetState();
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
    String employeeNumber = userInfoModel?.employeeNumber ?? '';
    await provider.fetchMoList(employeeNumber);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Move Order',
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
          } else if (moProvider.moList.isEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
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
                        MoveOrderItem mo = moProvider.moList[index];
                        String status = mo.status == null || mo.status!.isEmpty ? mo.headerStatusName : mo.status!;
                        mo.status = status;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoveOrderDetail(moveOrderItem: mo)
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
                                          color: getColorAsStatus(status),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          status,
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
