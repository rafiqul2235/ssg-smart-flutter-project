import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/mo_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';

import '../../../../data/model/response/user_info_model.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utill/timeago_util.dart';
import '../../../basewidget/custom_app_bar.dart';
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
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
    String employeeNumber = userInfoModel?.employeeNumber ?? '';
    await Provider.of<MoveOrderProvider>(context, listen: false).fetchApproverMoList(employeeNumber);
  }

  // Method to retry loading data
  void _retry() {
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
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
            return const Center(child: CircularProgressIndicator());
          }
          // Check for error state
          else if (moProvider.error != null && moProvider.error!.isNotEmpty) {
            return _buildErrorWidget(moProvider.error!);
          }
          // Check for empty data
          else if (moProvider.moList.isEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          }
          // Show data
          else {
            return _buildDataWidget(moProvider);
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataWidget(MoveOrderProvider moProvider) {
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
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _retry();
                // Wait for the loading to complete
                while (moProvider.isLoading) {
                  await Future.delayed(const Duration(milliseconds: 100));
                }
              },
              child: ListView.builder(
                itemCount: moProvider.moList.length,
                itemBuilder: (context, index) {
                  final mo = moProvider.moList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApproverMoDetails(moveOrderItem: mo),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Card(
                      color: const Color(0xFFFFF2DE),
                      margin: const EdgeInsets.symmetric(vertical: 12),
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
                                      Text(
                                        'MO: #${mo.moveOrderNumber}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Org Name: ${mo.orgName}',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  TimeAgoUtils.formatTimeAgo(mo.lastUpdateDate!),
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${mo.dateRequired}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getColorAsStatus(mo.headerStatusName ?? ''),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
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
          ),
        ],
      ),
    );
  }
}