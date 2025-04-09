import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';

class MoveOrderScreen extends StatefulWidget {
  final bool isBackButtonExist;

  const MoveOrderScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<MoveOrderScreen> createState() => _MoveOrderScreenState();
}

class _MoveOrderScreenState extends State<MoveOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: "Move Order",
            isBackButtonExist: widget.isBackButtonExist,
            icon: Icons.home,
            onActionPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen()));
            },
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MO List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMOItem(context, 'In-complete', Colors.grey.shade200),
                const SizedBox(height: 16),
                _buildMOItem(context, 'In-process', const Color(0xFFFFFF00)),
                const SizedBox(height: 16),
                _buildMOItem(context, 'Approved', const Color(0xFF90EE90)),
                const SizedBox(height: 16),
                _buildMOItem(context, 'Approved', const Color(0xFF90EE90)),
                const SizedBox(height: 16),
                _buildMOItem(context, 'Approved', const Color(0xFF90EE90)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMOItem(BuildContext context, String status, Color statusColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2DE),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MO: #472638',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '15-Jan-25',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '3 days ago',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == 'In-process' ? Colors.black : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
