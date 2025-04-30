import 'package:flutter/material.dart';

class ScrollableTable extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double fixedColumnWidth;
  final double scrollableColumnWidth;
  final double rowHeight;

  const ScrollableTable({
    Key? key,
    required this.items,
    this.fixedColumnWidth = 120,
    this.scrollableColumnWidth = 100,
    this.rowHeight = 50,
  }) : super(key: key);

  @override
  State<ScrollableTable> createState() => _ScrollableTableState();
}

class _ScrollableTableState extends State<ScrollableTable> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int length = widget.items.length;

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
                      controller: _horizontalController,
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

              // Table Body with Fixed Height
              SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed Column
                    SizedBox(
                      width: widget.fixedColumnWidth,
                      child: ListView.builder(
                        controller: _verticalController,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          var item = widget.items[index];
                          return _buildFixedCell(item['name'], index);
                        },
                      ),
                    ),

                    // Scrollable Columns
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: widget.scrollableColumnWidth * 6, // 6 columns
                          child: ListView.builder(
                            controller: _verticalController,
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              var item = widget.items[index];
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
                            },
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
}