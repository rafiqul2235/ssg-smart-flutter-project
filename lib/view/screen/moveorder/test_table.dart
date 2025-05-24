import 'package:flutter/material.dart';

class FixedHeaderTable extends StatefulWidget {
  @override
  _FixedHeaderTableState createState() => _FixedHeaderTableState();
}

class _FixedHeaderTableState extends State<FixedHeaderTable> {
  final ScrollController headerScrollController = ScrollController();
  final ScrollController bodyScrollController = ScrollController();

  // Exclude 'name' here
  final List<String> columnHeaders = [
    'qty', 'unit', 'total', 'last_issue', 'use_area', 'locator'
  ];

  final List<Map<String, String>> items = List.generate(15, (index) => {
    'name': 'Item ${index + 1}',
    'qty': '${(index + 1) * 2} PCS',
    'unit': (5.0 + index).toStringAsFixed(2),
    'total': ((index + 1) * 2 * (5.0 + index)).toStringAsFixed(2),
    'last_issue': '2025-05-${(index % 28 + 1).toString().padLeft(2, '0')}',
    'use_area': 'Area ${(index % 5) + 1}',
    'locator': 'Rack ${(index % 3) + 1}',
  });

  @override
  void initState() {
    super.initState();
    bodyScrollController.addListener(() {
      if (headerScrollController.hasClients &&
          headerScrollController.offset != bodyScrollController.offset) {
        headerScrollController.jumpTo(bodyScrollController.offset);
      }
    });
    headerScrollController.addListener(() {
      if (bodyScrollController.hasClients &&
          bodyScrollController.offset != headerScrollController.offset) {
        bodyScrollController.jumpTo(headerScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    headerScrollController.dispose();
    bodyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fixed Name Column Table")),
      body: Column(
        children: [
          // Header Row
          Row(
            children: [
              _buildCell("name", isHeader: true),
              Expanded(
                child: SingleChildScrollView(
                  controller: headerScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: columnHeaders
                        .map((e) => _buildCell(e, isHeader: true))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed name column
                  Column(
                    children: items
                        .map((item) => _buildCell(item['name'] ?? '',
                        isFixedColumn: true))
                        .toList(),
                  ),
                  // Scrollable data columns
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (_) => true,
                      child: SingleChildScrollView(
                        controller: bodyScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: items.map((item) {
                            return Row(
                              children: columnHeaders.map((key) {
                                return _buildCell(item[key] ?? '');
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCell(String text,
      {bool isHeader = false, bool isFixedColumn = false}) {
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.all(0.5),
      color: isHeader
          ? Colors.grey[300]
          : isFixedColumn
          ? Colors.grey[200]
          : Colors.white,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
