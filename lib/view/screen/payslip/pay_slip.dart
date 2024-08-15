import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/payslip_model.dart';
import 'package:ssg_smart2/provider/payslip_provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/payslip/payslip_generator.dart';

import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';
import '../home/dashboard_screen.dart';

class PayslipScreen extends StatefulWidget {
  final bool isBackButtonExist;

  const PayslipScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<PayslipScreen> createState() => _PayslipScreen();
}

class _PayslipScreen extends State<PayslipScreen> {

  bool showSalary = false;
  UserInfoModel? userInfoModel;

  @override
  void initState() {
    super.initState();
    _intData();
  }

  void _intData() async{
    userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    String employeeNumber = userInfoModel?.employeeNumber ?? '';
    Provider.of<PaySlipProvider>(context, listen: false).loadEmployeePaySlip(employeeNumber);
  }
  void _toggleSalary() {
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
                builder: (BuildContext context) => const DashBoardScreen()));
          }),
      body: Consumer<PaySlipProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.error.isNotEmpty) {
            return Center(
              child: Text(provider.error),
            );
          } else if (provider.employeePaySlip != null) {
            EmployeePaySlip employeePaySlip = provider.employeePaySlip!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCircularChart(employeePaySlip),
                    SizedBox(height: 20),
                    _buildActionButtons(employeePaySlip, userInfoModel!),
                    SizedBox(height: 20),
                    _buildEarningsSection(employeePaySlip),
                    SizedBox(height: 20),
                    _buildDeductionsSection(employeePaySlip),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('No pay slip data available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildCircularChart(EmployeePaySlip employeePaySlip) {
    String netPay = employeePaySlip.netPayable;
    int earnings = int.parse(employeePaySlip.totalEarning.replaceAll(',', ''));
    int deductions = int.parse(employeePaySlip.totalDeduction.replaceAll(',', ''));
    double percent = earnings / (earnings + deductions);
    final formatter = NumberFormat('#,###');
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 20.0,
      percent: percent,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '৳$netPay',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text('Net Pay'),
        ],
      ),
      progressColor: Colors.purple[200],
      backgroundColor: Colors.deepOrange,
      circularStrokeCap: CircularStrokeCap.round,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Text(
          '${employeePaySlip.payrollMonth}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('${employeePaySlip.totalEarning}', Colors.purple[200]!, 'Earnings'),
            SizedBox(width: 20),
            _buildLegend('${employeePaySlip.totalDeduction}', Colors.deepOrange, 'Deductions'),
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
            Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(EmployeePaySlip employeePaySlip, UserInfoModel userInfoModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Text(
              'Download',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final file = await PayslipGenerator(
                employeePaySlip: employeePaySlip,
                userInfoModel: userInfoModel
              ).generatePayslip();
              OpenFile.open(file.path);
            },
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
            child: Text(showSalary ? '${employeePaySlip.grossSal}' : 'Gross Salary'),
            onPressed: _toggleSalary,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsSection(EmployeePaySlip employeePaySlip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Earnings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildEarningItem('Basic', '৳${employeePaySlip.basic}'),
        _buildEarningItem('House Rent', '৳${employeePaySlip.houseRent}'),
        _buildEarningItem('Medical Allowance', '৳${employeePaySlip.medicalAllowance}'),
        _buildEarningItem('Conveyance', '৳${employeePaySlip.conveyance}'),
        _buildEarningItem('Entertainment', '৳${employeePaySlip.entertainment}'),
        _buildEarningItem('Others Allowance', '৳${employeePaySlip.otherAllowance}'),
        _buildEarningItem('TA and TD', '৳${employeePaySlip.taAndTD}'),
        _buildEarningItem('Other Payment', '৳${employeePaySlip.otherPayment}')
      ],
    );
  }

  Widget _buildDeductionsSection(EmployeePaySlip employeePaySlip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deductions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildDeductionItem('Income Tax', '৳${employeePaySlip.incomeTax}'),
        _buildDeductionItem('Loan Installation', '৳${employeePaySlip.loanInstallment}'),
        _buildDeductionItem('Mobile Bill Adjustment', '৳${employeePaySlip.excessMobileBill}'),
        _buildDeductionItem('PF Recovery', '৳${employeePaySlip.pfLoanRecovery}'),
        _buildDeductionItem('PF Contribution', '৳${employeePaySlip.pfEmployee}'),
        _buildDeductionItem('Other Deduction', '৳${employeePaySlip.otherDeduction}'),
        Divider(color: Colors.grey),
        _buildDeductionItem('Gross Deductions', '৳${employeePaySlip.totalDeduction}', isTotal: true),
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

  Widget _buildDeductionItem(String title, String amount,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(amount,
              style:
                  TextStyle(color: isTotal ? Colors.deepOrange : Colors.black)),
        ],
      ),
    );
  }
}
