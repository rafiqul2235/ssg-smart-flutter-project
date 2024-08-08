import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PayslipGenerator {
  Future<File> generatePayslip() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          // crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildEmployeeInfo(),
            pw.SizedBox(height: 10,),
            _buildEarningsDeductions(),
            _buildTotalAndSignature(),
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

  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('Payslip', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text('Zoonodle Inc'),
        pw.Text('21023 Pearson Point Road'),
        pw.Text('Gateway Avenue'),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildEmployeeInfo() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Date of Joining: 2018-06-23'),
            pw.Text('Pay Period: August 2021'),
            pw.Text('Worked Days: 26'),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Employee name: Sally Harley'),
            pw.Text('Designation: Marketing Executive'),
            pw.Text('Department: Marketing'),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildEarningsDeductions() {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Text('Earnings', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Deductions', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
        _buildTableRow('Basic', '10000', 'Provident Fund', '1200'),
        _buildTableRow('Incentive Pay', '1000', 'Professional Tax', '500'),
        _buildTableRow('House Rent Allowance', '400', 'Loan', '400'),
        _buildTableRow('Meal Allowance', '200', '', ''),
        _buildTableRow('Total Earnings', '11600', 'Total Deductions', '2100'),
      ],
    );
  }

  pw.TableRow _buildTableRow(String earning, String earningAmount, String deduction, String deductionAmount) {
    return pw.TableRow(
      children: [
        pw.Text(earning),
        pw.Text(earningAmount),
        pw.Text(deduction),
        pw.Text(deductionAmount),
      ],
    );
  }

  pw.Widget _buildTotalAndSignature() {
    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Text('Net Pay: 9500'),
        pw.Text('Nine Thousand Five Hundred'),
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