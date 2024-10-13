import 'package:flutter/material.dart';

class WppfLedgerScreen extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      'fiscalYear': '2018-2019',
      'disbursement': '17,858.73',
      'distributed': '11,310.53',
      'investment': '5,655.26',
      'profit': '0.00',
      'payable': '5,655.26',
    },
    {
      'fiscalYear': '2019-2020',
      'disbursement': '15,166.91',
      'distributed': '9,605.72',
      'investment': '4,802.86',
      'profit': '0.00',
      'payable': '4,802.86',
    },
    {
      'fiscalYear': '2020-2021',
      'disbursement': '24,800.06',
      'distributed': '16,533.38',
      'investment': '8,266.69',
      'profit': '0.00',
      'payable': '8,266.69',
    },
    {
      'fiscalYear': '2021-2022',
      'disbursement': '13,949.87',
      'distributed': '9,299.92',
      'investment': '4,649.96',
      'profit': '0.00',
      'payable': '4,649.96',
    },
    {
      'fiscalYear': '2022-2023',
      'disbursement': '30,606.42',
      'distributed': '18,363.85',
      'investment': '10,202.14',
      'profit': '0.00',
      'payable': '10,202.14',
    },
    {
      'fiscalYear': 'Total',
      'disbursement': '102,382.00',
      'distributed': '65,113.39',
      'investment': '33,576.91',
      'profit': '0.00',
      'payable': '33,576.91',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WPPF Ledger Report'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ExpansionTile(
              title: Text(
                data[index]['fiscalYear']!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Disbursement Amount', data[index]['disbursement']),
                      _buildDetailRow('Distributed Amount', data[index]['distributed']),
                      _buildDetailRow('Investment', data[index]['investment']),
                      _buildDetailRow('Profit from Investment', data[index]['profit']),
                      _buildDetailRow('Total Payable', data[index]['payable']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value ?? ''),
        ],
      ),
    );
  }
}
