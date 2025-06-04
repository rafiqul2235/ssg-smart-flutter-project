import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/mo_list.dart';
import 'package:ssg_smart2/provider/mo_provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/moveorder/user/user_move_order.dart';

import '../../../../data/model/body/approver.dart';
import '../../../basewidget/no_internet_screen.dart';

class MoveOrderDetail extends StatefulWidget {
  final MoveOrderItem moveOrderItem;
  final bool isBackButtonExist;

  MoveOrderDetail(
      {Key? key, required this.moveOrderItem, this.isBackButtonExist = true})
      : super(key: key);

  @override
  _MoveOrderDetailState createState() => _MoveOrderDetailState();
}

class _MoveOrderDetailState extends State<MoveOrderDetail> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoveOrderProvider>(context, listen: false)
          .fetchMoDetails(widget.moveOrderItem.orgId, widget.moveOrderItem.moveOrderNumber);
    });
  }


  // void _onClickSubmit() async {
  //   final provider = context.read<MoveOrderProvider>();
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) => const Center(child: CircularProgressIndicator(),)
  //   );
  //   await provider.submitMoveOrder(widget.moveOrderItem.headerId);
  //
  //   // Close the loading indicator
  //   Navigator.of(context).pop();
  //
  //   if (provider.isSuccess) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text(provider.error!),
  //           backgroundColor: Colors.green,
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //       ),
  //     );
  //     Navigator.of(context).pop(); // Close the dialog
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => UserMoveOrderScreen(
  //               isBackButtonExist: true,
  //             )));
  //     // Navigator.pop(context);
  //   }else{
  //     showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: Text('Submission Failed'),
  //           content: Text(provider.error!),
  //         )
  //     );
  //   }
  // }
  void _onClickSubmit() async {
    final provider = context.read<MoveOrderProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await provider.submitMoveOrder(widget.moveOrderItem.headerId);

      // Always close the loading dialog first
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (provider.isSuccess) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Move order submitted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate back to move order list
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserMoveOrderScreen(
              isBackButtonExist: true,
            ),
          ),
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Submission Failed'),
            content: Text(provider.error ?? 'An error occurred during submission'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error dialog for exceptions
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('An unexpected error occurred: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MO Details'),
      body: Consumer<MoveOrderProvider>(builder: (context, moProvider, child) {
        int itemLength = moProvider.moDetails.length;
        double sum = 0;
        if (moProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (moProvider.error!.isNotEmpty) {
          return NoInternetOrDataScreen(isNoInternet: false);
        } else {
          return Column(
            children: [
              // Content area (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Info Card
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.moveOrderItem.orgName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'MO: ${widget.moveOrderItem.moveOrderNumber}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Request Date: ${widget.moveOrderItem.dateRequired}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEB3B),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${widget.moveOrderItem.status}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Items Section Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total: ${itemLength} items',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Table
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Column(
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Item Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'R Qty',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Unit Price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Total Price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...List.generate(moProvider.moDetails.length, (index) {
                                  sum = sum + double.parse(moProvider.moDetails[index].totalValue!);
                                  return _buildTableRow(
                                    moProvider.moDetails[index].description!,
                                    '${moProvider.moDetails[index].quantityRequired} ${moProvider.moDetails[index].uom}',
                                    moProvider.moDetails[index].mtActualCost!,
                                    moProvider.moDetails[index].totalValue!,
                                    index % 2 == 0
                                        ? const Color(0xFFE0F2F1)
                                        : Colors.white,
                                  );
                                }),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '_',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '_',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${sum}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (['In-Process','Approved'].contains(moProvider.moDetails[0].status)) ...[
                          const SizedBox(height: 20.0),
                          // Approval History header - now aligned to the left
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildSectionHeader("Approver History"),
                          ),
                          const SizedBox(height: 10.0),
                          _buildApproverHistoryList(moProvider.approverList),
                        ],
                      ],

                    ),
                  ),
                ),
              ),

              // Bottom Buttons
              if(moProvider.moDetails[0].headerStatusName == 'Incomplete' &&
                  moProvider.moDetails[0].status != 'In-Process'
                  )...[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _onClickSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Submit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Cancel', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]

            ],
          );
        }
      }),
    );
  }

  Widget _buildTableRow(String item, String qty, String unitPrice,
      String totalPrice, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(item),
          ),
          Expanded(
            flex: 2,
            child: Text(qty),
          ),
          Expanded(
            flex: 2,
            child: Text(unitPrice),
          ),
          Expanded(
            flex: 2,
            child: Text(totalPrice),
          ),
        ],
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
