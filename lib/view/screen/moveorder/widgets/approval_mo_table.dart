import 'package:flutter/material.dart';

class ScrollableTable extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double fixedColumnWidth;
  final double scrollableColumnWidth;
  final double rowHeight;
  final double? maxHeight; // Optional max height constraint

  const ScrollableTable({
    Key? key,
    required this.items,
    this.fixedColumnWidth = 120,
    this.scrollableColumnWidth = 100,
    this.rowHeight = 50,
    this.maxHeight, // Add this parameter
  }) : super(key: key);

  @override
  State<ScrollableTable> createState() => _ScrollableTableState();
}

class _ScrollableTableState extends State<ScrollableTable> {
  final ScrollController headerController = ScrollController();
  final ScrollController bodyController = ScrollController();
  final ScrollController summaryController = ScrollController();

  @override
  void initState() {
    super.initState();
    bodyController.addListener(() {
      if (headerController.hasClients && headerController.offset != bodyController.offset) {
        headerController.jumpTo(bodyController.offset);
        summaryController.jumpTo(bodyController.offset);
      }
    });
    summaryController.addListener(() {
      if(headerController.hasClients && headerController.offset != summaryController.offset && bodyController.offset != summaryController.offset) {
        headerController.jumpTo(summaryController.offset);
        bodyController.jumpTo(summaryController.offset);
      }
    });
  }
  @override
  void dispose() {
    headerController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  num _calculateTotal(String field) {
    return widget.items.fold<num>(0, (sum, item) {
      final value = num.tryParse(item[field]?.toString() ?? '0') ?? 0;
      return sum + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    int length = widget.items.length;
    print('table screen');
    print('length: ${length}');

    // Calculate content height based on number of items
    double contentHeight = widget.rowHeight * length;

    // Apply max height constraint if provided
    double tableHeight = widget.maxHeight != null
        ? (contentHeight > widget.maxHeight! ? widget.maxHeight! : contentHeight)
        : contentHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Items Section Header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total: $length items',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
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
                  // Fixed "Item Name" Column Header
                  _buildFixedHeaderCell("Item Name"),

                  // Scrollable Headers
                  Expanded(
                    child: SingleChildScrollView(
                      controller: headerController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildHeaderCell('R Qty'),
                          _buildHeaderCell('Unit Price'),
                          _buildHeaderCell('Total Price'),
                          _buildHeaderCell('Last Issue'),
                          _buildHeaderCell('Use Area'),
                          _buildHeaderCell('Locator'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Table Body with Dynamic Height
              SizedBox(
                height: tableHeight,
                child: Scrollbar(
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fixed Column
                        SizedBox(
                          width: widget.fixedColumnWidth,
                          child: Column(
                            children: widget.items
                                      .asMap()
                                       .entries
                                      .map((entry) => _buildFixedCell(entry.value['name'], entry.key)).toList(),
                          ),
                        ),
                        // Scrollable Column
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
                                      return SizedBox(
                                        height: widget.rowHeight,
                                        child: Row(
                                          children: [
                                            _buildTableCell(item['qty'], index),
                                            _buildTableCell(item['unit'], index),
                                            _buildTableCell(item['total'], index),
                                            _buildTableCell(item['last_issue'], index),
                                            _buildTableCell(item['use_area'], index),
                                            _buildTableCell(item['locator'], index),
                                          ],
                                        ),
                                      );
                                }).toList()
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 1,),
              Container(
                color: Colors.grey.shade100,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: widget.fixedColumnWidth,
                      child: Column(
                        children: [
                          _buildFixedSummaryCell('Total')
                        ],
                      )
                    ),
                    Expanded(
                        child: Scrollbar(
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: summaryController,
                            child: Row(
                              children: [
                                _buildSummaryCell('_'),
                                _buildSummaryCell('_'),
                                _buildSummaryCell(_calculateTotal('total').toString()),
                                _buildSummaryCell('_'),
                                _buildSummaryCell('_'),
                                _buildSummaryCell('_'),
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // Fixed "Item Name" Header
  Widget _buildFixedHeaderCell(String text) {
    return Container(
      width: widget.fixedColumnWidth,
      // height: 50,
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

  // Scrollable Header Cells
  Widget _buildHeaderCell(String text) {
    return Container(
      width: widget.scrollableColumnWidth,
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

  // Fixed "Item Name" Data Cells
  Widget _buildFixedCell(String? text, int index) {
    return Container(
      width: widget.fixedColumnWidth,
      height: widget.rowHeight,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: index.isEven ? const Color(0xFFE0F2F1) : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        text ?? "",
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Scrollable Data Cells
  Widget _buildTableCell(String? text, int index) {
    return Container(
      width: widget.scrollableColumnWidth,
      height: widget.rowHeight,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: index.isEven ? const Color(0xFFE0F2F1) : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        text ?? "",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFixedSummaryCell(String value) {
    return Container(
      width: widget.fixedColumnWidth,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
  Widget _buildSummaryCell(String value) {
    return Container(
      width: widget.scrollableColumnWidth,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

}