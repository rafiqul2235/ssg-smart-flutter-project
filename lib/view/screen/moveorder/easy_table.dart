import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class EasyFixedHeaderTable extends StatelessWidget {
  final List<String> fixedColumn = List.generate(19, (i) => 'F_R_${i + 1}');
  final List<String> scrollableHeaders = List.generate(15, (i) => 'S_C_${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Easy Fixed Header Table")),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 80.0 * scrollableHeaders.length,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: fixedColumn.length,
        rowSeparatorWidget: Divider(height: 1, color: Colors.black),
        leftHandSideColBackgroundColor: Colors.grey.shade200,
        rightHandSideColBackgroundColor: Colors.white,
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> titles = [
      _buildHeaderCell("F_C_0"),
    ];
    titles.addAll(scrollableHeaders.map((e) => _buildHeaderCell(e)).toList());
    return titles;
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return _buildCell(fixedColumn[index], isHeader: false);
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int rowIndex) {
    return Row(
      children: List.generate(5, (colIndex) {
        return _buildCell("S_R_${rowIndex + 1}");
      }),
    );
  }

  Widget _buildCell(String label, {bool isHeader = false}) {
    return Container(
      alignment: Alignment.center,
      width: 80,
      height: 50,
      color: isHeader ? Colors.grey[300] : null,
      child: Text(
        label,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _buildHeaderCell(String label) => _buildCell(label, isHeader: true);
}
