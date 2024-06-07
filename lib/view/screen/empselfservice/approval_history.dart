import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/view/screen/empselfservice/widget/info_row.dart';
import '../../../data/model/response/self_service.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';


class ApprovalHistory extends StatefulWidget {
  final bool isBackButtonExist;
  const ApprovalHistory({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<ApprovalHistory> createState() => _ApprovalHistoryState();
}

class _ApprovalHistoryState extends State<ApprovalHistory> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getApplicationList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Approval History',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const DashBoardScreen()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(context),
              SizedBox(height: 16),
              _buildDataTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InfoRow(label: 'Emp Id:', value: '12345'),
            InfoRow(label: 'Name:', value: 'John Doe'),
            InfoRow(label: 'Department:', value: 'HR'),
            InfoRow(label: 'Location:', value: 'New York'),
            InfoRow(label: 'Header Id:', value: '98765'),
            InfoRow(label: 'Leave type:', value: 'Sick Leave'),
            InfoRow(label: 'Start Date:', value: '2024-06-01'),
            InfoRow(label: 'End Date:', value: '2024-06-07'),
            InfoRow(label: 'Duration:', value: '7 days'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('SL')),
              DataColumn(label: Text('Approver Name')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Note')),
              DataColumn(label: Text('Date Time')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Alice Smith')),
                DataCell(Text('Approved')),
                DataCell(Text('Approved quickly')),
                DataCell(Text('2024-06-01 09:00')),
              ]),
              DataRow(cells: [
                DataCell(Text('2')),
                DataCell(Text('Bob Johnson')),
                DataCell(Text('Pending')),
                DataCell(Text('Waiting for review')),
                DataCell(Text('2024-06-02 10:30')),
              ]),
              DataRow(cells: [
                DataCell(Text('3')),
                DataCell(Text('Charlie Brown')),
                DataCell(Text('Rejected')),
                DataCell(Text('Not sufficient reasons')),
                DataCell(Text('2024-06-03 11:00')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}


