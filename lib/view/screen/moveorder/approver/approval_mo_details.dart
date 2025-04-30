import 'package:flutter/material.dart';

import '../widgets/approval_mo_table.dart';


class ApproverMoDetails extends StatelessWidget {
  ApproverMoDetails({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> items = [
    {
      "name": "Umbrella",
      "qty": "1 pcs",
      "unit": "500",
      "total": "550",
      "last_issue": "2024-03-01",
      "use_area": "Outdoor",
      "locator": "Rack A1"
    },
    {
      "name": "Toilet Tissue",
      "qty": "6 rol",
      "unit": "18",
      "total": "96",
      "last_issue": "2024-02-15",
      "use_area": "Restroom",
      "locator": "Rack B3"
    },
    {
      "name": "A4 Paper",
      "qty": "1 rim",
      "unit": "249.82",
      "total": "249.82",
      "last_issue": "2024-04-10",
      "use_area": "Office",
      "locator": "Rack C2"
    },
    {
      "name": "Ball Pen",
      "qty": "10 pcs",
      "unit": "3.90",
      "total": "39",
      "last_issue": "2024-01-20",
      "use_area": "Office",
      "locator": "Rack D4"
    },
    {
      "name": "Gel Pen",
      "qty": "5 pcs",
      "unit": "10",
      "total": "50",
      "last_issue": "2024-05-05",
      "use_area": "Office",
      "locator": "Rack E5"
    },
  ];

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          Container(
            color: Colors.red,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 10,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'MO Approval Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info Card
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seven Circle Bangladesh Ltd CPD',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Req. by: Md. Assaduzzan', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 5),
                          Text('MO: #234729', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Request Date: 15-Jan-2024'),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Pending',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Scrollable Table
                    ScrollableTable(items: items),

                    SizedBox(height: 20),

                    // Comment Section
                    Text(
                      'Add Comment:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _commentController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Write your comment here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),



          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Approve', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Reject', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
