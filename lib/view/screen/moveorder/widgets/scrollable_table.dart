import 'package:flutter/material.dart';

class ScrollableTable2 extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double fixedColumnWidth;
  final double scrollableColumnWidth;
  final double minRowHeight;
  final double? maxHeight;

  const ScrollableTable2({
    Key? key,
    required this.items,
    this.fixedColumnWidth = 150, // Increased for item names
    this.scrollableColumnWidth = 120, // Increased default width
    this.minRowHeight = 60, // Minimum height instead of fixed
    this.maxHeight,
  }) : super(key: key);

  @override
  State<ScrollableTable2> createState() => _ScrollableTable2State();
}

class _ScrollableTable2State extends State<ScrollableTable2> {
  final ScrollController headerController = ScrollController();
  final ScrollController bodyController = ScrollController();
  final ScrollController summaryController = ScrollController();

  // Define column configurations with different widths
  final Map<String, double> columnWidths = {
    'qty': 80,
    'unit': 100,
    'total': 110,
    'last_issue': 130, // Wider for dates/longer text
    'use_area': 110,
    'locator': 120, // Wider for location codes
  };

  @override
  void initState() {
    super.initState();
    _setupScrollControllers();
  }

  void _setupScrollControllers() {
    headerController.addListener(() {
      if (headerController.hasClients &&
          headerController.offset != bodyController.offset &&
          headerController.offset != summaryController.offset) {
        bodyController.jumpTo(headerController.offset);
        summaryController.jumpTo(headerController.offset);
      }
    });

    bodyController.addListener(() {
      if (bodyController.hasClients &&
          headerController.offset != bodyController.offset) {
        headerController.jumpTo(bodyController.offset);
        summaryController.jumpTo(bodyController.offset);
      }
    });

    summaryController.addListener(() {
      if (summaryController.hasClients &&
          headerController.offset != summaryController.offset &&
          bodyController.offset != summaryController.offset) {
        headerController.jumpTo(summaryController.offset);
        bodyController.jumpTo(summaryController.offset);
      }
    });
  }

  @override
  void dispose() {
    headerController.dispose();
    bodyController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  num _calculateTotal(String field) {
    return widget.items.fold<num>(0, (sum, item) {
      final value = num.tryParse(item[field]?.toString() ?? '0') ?? 0;
      return sum + value;
    });
  }

  // Calculate dynamic row heights based on content
  List<double> _calculateRowHeights() {
    List<double> heights = [];

    for (var item in widget.items) {
      double maxHeight = widget.minRowHeight;

      // Check each field for content length and calculate required height
      String itemName = item['name']?.toString() ?? '';
      String lastIssued = item['last_issue']?.toString() ?? '';
      String locator = item['locator']?.toString() ?? '';

      // Estimate height based on content length (rough calculation)
      double nameHeight = _estimateTextHeight(itemName, widget.fixedColumnWidth);
      double lastIssuedHeight = _estimateTextHeight(lastIssued, columnWidths['last_issue']!);
      double locatorHeight = _estimateTextHeight(locator, columnWidths['locator']!);

      maxHeight = [maxHeight, nameHeight, lastIssuedHeight, locatorHeight]
          .reduce((a, b) => a > b ? a : b);

      heights.add(maxHeight);
    }

    return heights;
  }

  // Rough estimation of text height based on content and width
  double _estimateTextHeight(String text, double width) {
    if (text.isEmpty) return widget.minRowHeight;

    // Rough calculation: ~12 characters per line at default font size
    int charsPerLine = (width / 8).floor();
    int lines = (text.length / charsPerLine).ceil();

    // Account for padding and line height
    return (lines * 20 + 24).toDouble().clamp(widget.minRowHeight, 120);
  }

  @override
  Widget build(BuildContext context) {
    int length = widget.items.length;
    List<double> rowHeights = _calculateRowHeights();
    double totalContentHeight = rowHeights.fold(0, (sum, height) => sum + height);

    double tableHeight = widget.maxHeight != null
        ? (totalContentHeight > widget.maxHeight! ? widget.maxHeight! : totalContentHeight)
        : totalContentHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Items Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total: $length items',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),

        // Table Container
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  _buildFixedHeaderCell("Item Name"),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: headerController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildHeaderCell('Req. Qty', columnWidths['qty']!),
                          _buildHeaderCell('Unit Price', columnWidths['unit']!),
                          _buildHeaderCell('Total Price', columnWidths['total']!),
                          _buildHeaderCell('Last Issued', columnWidths['last_issue']!),
                          _buildHeaderCell('Use Area', columnWidths['use_area']!),
                          _buildHeaderCell('Locator', columnWidths['locator']!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Table Body with Dynamic Heights
              SizedBox(
                height: tableHeight,
                child: Scrollbar(
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fixed Column with Dynamic Heights
                        SizedBox(
                          width: widget.fixedColumnWidth,
                          child: Column(
                            children: widget.items
                                .asMap()
                                .entries
                                .map((entry) => _buildFixedCell(
                                entry.value['name'],
                                entry.key,
                                rowHeights[entry.key]))
                                .toList(),
                          ),
                        ),

                        // Scrollable Columns with Dynamic Heights
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: bodyController,
                            child: Column(
                              children: widget.items
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final rowHeight = rowHeights[index];

                                return SizedBox(
                                  height: rowHeight,
                                  child: Row(
                                    children: [
                                      _buildTableCell(item['qty'], index, columnWidths['qty']!, rowHeight),
                                      _buildTableCell(item['unit'], index, columnWidths['unit']!, rowHeight),
                                      _buildTableCell(item['total'], index, columnWidths['total']!, rowHeight),
                                      _buildTableCell(item['last_issue'], index, columnWidths['last_issue']!, rowHeight),
                                      _buildTableCell(item['use_area'], index, columnWidths['use_area']!, rowHeight),
                                      _buildTableCell(item['locator'], index, columnWidths['locator']!, rowHeight),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Summary Row
              const Divider(height: 1),
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: widget.fixedColumnWidth,
                      child: Column(
                        children: [_buildFixedSummaryCell('Total')],
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: summaryController,
                          child: Row(
                            children: [
                              _buildSummaryCell('—', columnWidths['qty']!),
                              _buildSummaryCell('—', columnWidths['unit']!),
                              _buildSummaryCell(_calculateTotal('total').toString(), columnWidths['total']!),
                              _buildSummaryCell('—', columnWidths['last_issue']!),
                              _buildSummaryCell('—', columnWidths['use_area']!),
                              _buildSummaryCell('—', columnWidths['locator']!),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fixed Header Cell
  Widget _buildFixedHeaderCell(String text) {
    return Container(
      width: widget.fixedColumnWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 1.5),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Scrollable Header Cells with Custom Width
  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 1.5),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Fixed Cell with Dynamic Height and Proper Text Wrapping
  Widget _buildFixedCell(String? text, int index, double height) {
    return Container(
      width: widget.fixedColumnWidth,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: index.isEven ? const Color(0xFFE0F2F1) : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text ?? "",
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
      ),
    );
  }

  // Scrollable Cell with Dynamic Width and Height
  Widget _buildTableCell(String? text, int index, double width, double height) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: index.isEven ? const Color(0xFFE0F2F1) : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text ?? "",
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          softWrap: true,
        ),
      ),
    );
  }

  // Summary Cells
  Widget _buildFixedSummaryCell(String value) {
    return Container(
      width: widget.fixedColumnWidth,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildSummaryCell(String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}