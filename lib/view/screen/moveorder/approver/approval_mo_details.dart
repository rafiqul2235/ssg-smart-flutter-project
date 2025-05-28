import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/moveorder/approver/mo_for_approver.dart';
import 'package:ssg_smart2/view/screen/moveorder/test_table.dart';

import '../../../../data/model/body/approver.dart';
import '../../../../data/model/body/mo_list.dart';
import '../../../../provider/mo_provider.dart';
import '../../../basewidget/custom_app_bar.dart';
import '../../home/dashboard_screen.dart';
import '../widgets/approval_mo_table.dart';

class ApproverMoDetails extends StatefulWidget {
  final MoveOrderItem moveOrderItem;
  final bool isBackButtonExist;

  const ApproverMoDetails({
    Key? key,
    required this.moveOrderItem,
    this.isBackButtonExist = true,
  }) : super(key: key);

  @override
  _ApproverMoDetailsState createState() => _ApproverMoDetailsState();
}

class _ApproverMoDetailsState extends State<ApproverMoDetails> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<MoveOrderProvider>(context, listen: false).fetchMoDetails(
      widget.moveOrderItem.orgId,
      widget.moveOrderItem.moveOrderNumber,
    );
  }

  void _onClickSubmit(bool isApproved) async {
    String? notificationId = widget.moveOrderItem.notificationId;
    String action = isApproved ? "APPROVED" : "REJECTED";
    String applicationType = "MOVEORDER";
    String comment = _commentController.text;
    final provider = context.read<MoveOrderProvider>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(),)
    );
    await provider.handleMoveOrder(applicationType, notificationId!, action, comment);
    // Close the loading indicator
    Navigator.of(context).pop();

    if (provider.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.of(context).pop(); // Close the dialog
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ApprovalMoveOrderScreen(
                isBackButtonExist: true,
              )));
      // Navigator.pop(context);
    }else{
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Approval Failed'),
            content: Text(provider.error!),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Approval MO List',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          );
        },
      ),
      body: Consumer<MoveOrderProvider>(
        builder: (context, moProvider, child) {
          if (moProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (moProvider.error != null && moProvider.error!.isNotEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          }

          // Convert MoveOrderDetails objects to Map<String, dynamic>
          final items = moProvider.moDetails.map((detail) => {
            'name': detail.description,
            'qty': '${detail.quantityRequired} ${detail.uom}',
            'unit': detail.mtActualCost,
            'total': detail.totalValue,
            'last_issue': detail.lastIssueInfo,
            'use_area': detail.useOfArea,
            'locator': detail.itemLocator,
          }).toList();

          // Calculate available height for the table
          // This is a smart approach to limit the table height based on content
          // while still maintaining reasonable screen proportions
          final screenHeight = MediaQuery.of(context).size.height;
          final maxTableHeight = screenHeight * 0.5; // 50% of screen height max

          return Column(
            children: [
              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.moveOrderItem.orgName != null)
                                Text(
                                  widget.moveOrderItem.orgName!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              const SizedBox(height: 5),
                              Text(
                                'Requester Name: ${widget.moveOrderItem.fullName ?? "N/A"}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'MO: ${widget.moveOrderItem.moveOrderNumber}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Request Date: ${widget.moveOrderItem.dateRequired}'),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Pending',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Scrollable Table with dynamic height
                        ScrollableTable(
                          items: items,
                          maxHeight: maxTableHeight, // Set maximum height constraint
                        ),

                        const SizedBox(height: 20),
                        // Approval history
                        _buildSectionHeader("Approver History"),
                        const SizedBox(height: 10.0),
                        _buildApproverHistoryList(moProvider.approverList),

                        // Comment Section
                        const Text(
                          'Add Comment:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _commentController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Write your comment here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Approve action
                          _onClickSubmit(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Approve', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Reject action
                          _onClickSubmit(false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reject', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildApproverHistoryList(List<ApproverDetail> approverList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: approverList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final history = approverList[index];
          return ListTile(
            title: Text(history.responderName),
            subtitle: Text(history.note),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  history.action,
                  style: TextStyle(
                      color: _getStatusColor(history.action),
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  ),
                ),
                Text(
                  history.actionDate,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Initiated':
        return Colors.amber;
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}