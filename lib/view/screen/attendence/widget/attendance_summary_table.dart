import 'package:flutter/material.dart';

class AttendanceSummaryTable extends StatefulWidget {
  final Map<String, int> attendanceSummary;

  AttendanceSummaryTable({required this.attendanceSummary});

  @override
  _AttendanceSummaryTableState createState() => _AttendanceSummaryTableState();
}

class _AttendanceSummaryTableState extends State<AttendanceSummaryTable> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          _buildHeader(),
          _buildDataRow("Present", "Offday"),
          _buildDataRow("Late", "Leave"),
          _buildDataRow("Holiday", "Absent"),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.green[200],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(child: _buildHeaderCell("Status")),
            Expanded(child: _buildHeaderCell("Value")),
            Expanded(child: _buildHeaderCell("Status")),
            Expanded(child: _buildHeaderCell("Value")),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String status1, String status2) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(child: _buildDataCell(status1)),
            Expanded(child: _buildDataCell(widget.attendanceSummary[status1].toString())),
            Expanded(child: _buildDataCell(status2)),
            Expanded(child: _buildDataCell(widget.attendanceSummary[status2].toString())),
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
