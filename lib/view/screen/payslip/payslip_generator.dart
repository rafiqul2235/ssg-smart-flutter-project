import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ssg_smart2/data/model/response/payslip_model.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';


class PayslipGenerator {
  final EmployeePaySlip employeePaySlip;
  final UserInfoModel userInfoModel;

  PayslipGenerator({required this.employeePaySlip, required this.userInfoModel});

  Future<File> generatePayslip() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          // crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(userInfoModel),
            _buildEmployeeInfo(employeePaySlip, userInfoModel),
            pw.SizedBox(height: 10,),
            _buildEarningsDeductions(employeePaySlip),
            _buildTotalAndSignature(employeePaySlip),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/payslip.pdf');
    await file.writeAsBytes(await pdf.save());
    print('PDF is opening successfully');
    return file;
  }

  pw.Widget _buildHeader(UserInfoModel userInfoModel) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('Payslip', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text('${userInfoModel.orgName}'),
        pw.Text('${userInfoModel.workLocation}'),
        // pw.Text('Gulshan North C/A'),
        // pw.Text('Gulshan Circle-2 Dhaka-1212, Bangladesh'),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildEmployeeInfo(EmployeePaySlip employeePaySlip, UserInfoModel userInfoModel) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Employee name: ${employeePaySlip.empNameId}'),
              pw.Text('Designation: ${employeePaySlip.designation}'),
              pw.Text('Department: ${employeePaySlip.departmentSection}'),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Date of Joining: ${employeePaySlip.doj}'),
              pw.Text('${employeePaySlip.payrollMonth}'),
              // pw.Text('Worked Days: 26'),
            ],
          ),
        )

      ],
    );
  }

  pw.Widget _buildEarningsDeductions(EmployeePaySlip employeePaySlip) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.all(3),
              child: pw.Text('Earnings', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(3),
              child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(3),
              child: pw.Text('Deductions', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.all(3),
              child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        ),
        _buildTableRow('Basic', '${employeePaySlip.basic}', 'Income Tax', '${employeePaySlip.incomeTax}'),
        _buildTableRow('House Rent Allowance', '${employeePaySlip.houseRent}', 'Loan Instalment', '${employeePaySlip.loanInstallment}'),
        _buildTableRow('Medical Allowance', '${employeePaySlip.medicalAllowance}', 'Mobile Bill Adjustment', '${employeePaySlip.excessMobileBill}'),
        _buildTableRow('Conveyance', '${employeePaySlip.conveyance}', 'Revenue Stamp', '0.00'),
        _buildTableRow('Entertainment', '${employeePaySlip.entertainment}', 'Other Deduction', '${employeePaySlip.otherDeduction}'),
        _buildTableRow('Others Allowance', '${employeePaySlip.otherAllowance}', 'PF Employee Contribution', '${employeePaySlip.pfEmployee}'),
        _buildTableRow('Suspension Allowance', '0.00', 'PF Loan Recovery', '${employeePaySlip.pfLoanRecovery}'),
        _buildTableRow('Food Allowance', '${employeePaySlip.foodAllowance}', 'Welfare Fund Subscription', '0.00'),
        _buildTableRow('Bonus', '0.00', '',''),
        _buildTableRow('TA & OT', '${employeePaySlip.taAndTD}', '',''),
        _buildTableRow('Other Payment', '${employeePaySlip.otherPayment}', '',''),
        _buildTableRow('Total Earnings', '${employeePaySlip.totalEarning}', 'Total Deductions', '${employeePaySlip.totalDeduction}'),
      ],
    );
  }

  pw.TableRow _buildTableRow(String earning, String earningAmount, String deduction, String deductionAmount) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(3), // Adjust the padding value as needed
          child: pw.Text(earning),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3),
          child: pw.Text(earningAmount),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3),
          child: pw.Text(deduction),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.all(3),
          child: pw.Text(deductionAmount),
        ),
      ],
    );
  }

  pw.Widget _buildTotalAndSignature(EmployeePaySlip employeePaySlip) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Text('Net Pay: ${employeePaySlip.netPayable}'),
        pw.Text('${employeePaySlip.inWord}'),
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Employer Signature'),
                pw.SizedBox(height: 20),
                pw.Container(width: 100, height: 1, color: PdfColors.black),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Employee Signature'),
                pw.SizedBox(height: 20),
                pw.Container(width: 100, height: 1, color: PdfColors.black),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text('This is system generated payslip', style: pw.TextStyle(fontSize: 8)),
      ],
    );
  }

}