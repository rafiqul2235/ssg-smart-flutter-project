import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveTable(),
    );
  }
}

class PendingSO {
  final int srlNum;
  final String ntfResponder;
  final String approverName;
  final String approverAction;
  final String note;
  final String actionDate;

  PendingSO({
    required this.srlNum,
    required this.ntfResponder,
    required this.approverName,
    required this.approverAction,
    required this.note,
    required this.actionDate,
  });
}

class ResponsiveTable extends StatelessWidget {
  final List<PendingSO> pendingSOList = [
    PendingSO(
      srlNum: 1,
      ntfResponder: "Mr. MD. RAFIQUL ISLAM (Sr.Executive-SSG Global ERP and Digitalization)",
      approverName: "Mr. MD. RAFIQUL ISLAM (Sr.Executive-SSG Global ERP and Digitalization)",
      approverAction: "Initiated",
      note: "Approval Initiated",
      actionDate: "14-MAY-24 09:40",
    ),
    PendingSO(
      srlNum: 2,
      ntfResponder: "475",
      approverName: "Mr. MD MASUM MANZIL (Dy. Manager-SSG Global ERP and Digitalization)",
      approverAction: "Pending",
      note: "",
      actionDate: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Summary')),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: pendingSOList.length + 1, // +1 for header row
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildHeader();
            }
            final pendingSO = pendingSOList[index - 1];
            return _buildDataRow(pendingSO);
          },
        ),
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
            Expanded(flex: 3, child: _buildDataCell(pendingSO.approverName)),
            Expanded(flex: 2, child: _buildDataCell(pendingSO.approverAction)),
            Expanded(flex: 2, child: _buildDataCell(pendingSO.note)),
            Expanded(flex: 2, child: _buildDataCell(pendingSO.actionDate)),
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
