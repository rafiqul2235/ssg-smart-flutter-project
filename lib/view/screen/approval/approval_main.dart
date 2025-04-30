import 'package:flutter/material.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/approval/approval_screen.dart';
import 'package:ssg_smart2/view/screen/moveorder/approver/mo_for_approver.dart';


class ApprovalScreen extends StatelessWidget {
  final List<_ApprovalType> approvalTypes = [
    _ApprovalType(name: 'Leave', icon: Icons.beach_access, color: Colors.blue),
    _ApprovalType(name: 'Move Order', icon: Icons.swap_horiz, color: Colors.orange),
    // _ApprovalType(name: 'Loan', icon: Icons.attach_money, color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Approval',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: approvalTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // two cards per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final approval = approvalTypes[index];
            return GestureDetector(
              onTap: () {
                if (approval.name == 'Leave'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApprovalListPage(),
                    ),
                  );
                } else if ( approval.name == 'Move Order') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApprovalMoveOrderScreen(),
                    ),
                  );
                }

              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: approval.color.withOpacity(0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: approval.color.withOpacity(0.1),
                      child: Icon(approval.icon, color: approval.color, size: 30),
                      radius: 30,
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${approval.name} Approval',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ApprovalType {
  final String name;
  final IconData icon;
  final Color color;

  _ApprovalType({required this.name, required this.icon, required this.color});
}
