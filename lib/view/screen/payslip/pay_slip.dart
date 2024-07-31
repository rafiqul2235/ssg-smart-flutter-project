import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';

import '../home/dashboard_screen.dart';

class PayslipScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const PayslipScreen({Key? key, this.isBackButtonExist = true}): super(key: key);

  @override
  State<PayslipScreen> createState() => _PayslipScreen();
}

class _PayslipScreen extends State<PayslipScreen> {
  int salary = 50000;

  bool showSalary = false;

  int earnings = 55000;
  int deductions = 10;

  void _toggleSalary(){
    setState(() {
      showSalary = !showSalary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'PaySlip',
          isBackButtonExist: widget.isBackButtonExist,
          icon: Icons.home,
          onActionPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (
                    BuildContext context) => const DashBoardScreen()));
          }),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCircularChart(),
              SizedBox(height: 20),
              _buildActionButtons(),
              SizedBox(height: 20),
              _buildEarningsSection(),
              SizedBox(height: 20),
              _buildDeductionsSection(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularChart() {
    int netPay = earnings - deductions;
    double percent = earnings / (earnings + deductions);
    final formatter = NumberFormat('#,###');
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 15.0,
      percent: percent, // 67500 / (67500 + 5500)
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatter.format(netPay),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('Net Pay'),
        ],
      ),
      progressColor: Colors.purple[200],
      backgroundColor: Colors.deepOrange,
      circularStrokeCap: CircularStrokeCap.round,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Payroll Month : Mar-2024',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('$earnings', Colors.purple[200]!, 'Earnings'),
            SizedBox(width: 20),
            _buildLegend('$deductions', Colors.deepOrange, 'Deductions'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String value, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
  // Widget _buildLegend(String value, Color color, String label) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,  // Align items to the top
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.only(top: 4),  // Adjust this value as needed
  //         child: Container(
  //           width: 15,
  //           height: 15,
  //           decoration: BoxDecoration(
  //             color: color,
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //       SizedBox(width: 10),
  //       Align(
  //         alignment: Alignment.topLeft,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             Text(label, style: TextStyle(fontSize: 12)),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildActionButtons() {
    return Row(
      children: [

        Expanded(
          child: ElevatedButton(
            child: Text('Download', style: TextStyle(color: Colors.white),),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            child: Text(showSalary ? '$salary':'Gross Salary'),
            onPressed: _toggleSalary,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black, side: BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildEarningItem('Basic', '₹30,000.00'),
        _buildEarningItem('Leave Encashment', '₹2,980.00'),
        _buildEarningItem('HRA', '₹15,000.00'),
        _buildEarningItem('Other Allowance', '₹10,000.00'),
        _buildEarningItem('SPL Allowance', '₹15,000.00'),
      ],
    );
  }

  Widget _buildDeductionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deductions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildDeductionItem('Employee PF Contribution', '₹3,000.00'),
        _buildDeductionItem('Income Tax', '₹1,000.00'),
        _buildDeductionItem('Insurance', '₹1,500.00'),
        Divider(color: Colors.grey),
        _buildDeductionItem('Gross Deductions', '₹5,500.00', isTotal: true),
      ],
    );
  }

  Widget _buildEarningItem(String title, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(amount),
        ],
      ),
    );
  }

  Widget _buildDeductionItem(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(amount, style: TextStyle(color: isTotal ? Colors.deepOrange : Colors.black)),
        ],
      ),
    );
  }
}