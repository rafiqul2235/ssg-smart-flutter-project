import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';

import '../../../data/model/response/leaveapproval/application_info.dart';
import '../../../data/model/response/leaveapproval/leave_approval.dart';
import '../../../provider/approval_hisotry_provider.dart';
import '../../basewidget/no_internet_screen.dart';
import '../home/dashboard_screen.dart';

class ApprovalHistoryScreen extends StatefulWidget {
  final bool isBackButtonExist;
  final String invoiceId;

  const ApprovalHistoryScreen(
      {Key? key,
        this.isBackButtonExist = true,
        required this.invoiceId})
      : super(key: key);

  @override
  _ApprovalHistoryScreenState createState() => _ApprovalHistoryScreenState();
}

class _ApprovalHistoryScreenState extends State<ApprovalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ApprovalHistoryProvider>(context, listen: false)
        .fetchLeaveApprovalHistory(widget.invoiceId);
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
      body: Consumer<ApprovalHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
            return NoInternetOrDataScreen(isNoInternet: false);
          } else if (provider.leaveApprovalHistory != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                      provider.leaveApprovalHistory!.applicationInfo[0]),
                  SizedBox(height: 16),
                  Expanded(
                    child: _buildDataTable(provider.leaveApprovalHistory!.pendingSO),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(ApplicationInfo applicationInfo) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Leave Type', applicationInfo.leaveType),
            _buildInfoRow('Start Date', applicationInfo.leaveStartDate),
            _buildInfoRow('End Date', applicationInfo.leaveEndDate),
            _buildInfoRow('Duration', applicationInfo.leaveDuration),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<PendingSO> pendingSOList) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ListView.builder(
        itemCount: pendingSOList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }
          final pendingSO = pendingSOList[index - 1];
          return _buildDataRow(pendingSO);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildHeaderCell("SL")),
            Expanded(flex: 3, child: _buildHeaderCell("Approver\nName")),
            Expanded(flex: 2, child: _buildHeaderCell("Status")),
            Expanded(flex: 2, child: _buildHeaderCell("Note")),
            Expanded(flex: 2, child: _buildHeaderCell("Date &\nTime"))
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(PendingSO pendingSO) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildDataCell(pendingSO.srlNum.toString())),
            Expanded(flex: 3, child: _buildDataCell(pendingSO.approverName!)),
            Expanded(flex: 2, child: _buildDataCell(pendingSO.approverAction!)),
            Expanded(flex: 2, child: _buildDataCell(pendingSO.note!)),
            Expanded(flex: 2, child: _buildDataCell(pendingSO.actionDate!)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}