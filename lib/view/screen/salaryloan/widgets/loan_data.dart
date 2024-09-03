import 'package:flutter/material.dart';

class LoanData extends StatelessWidget {
  final double totalLoan = 100000;
  final double paidLoan = 50000;
  final int totalInstallment = 10;

  final Color paidColor = Colors.green;
  final Color dueColor = Colors.orange;

  const LoanData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.cyan[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SemicircularIndicator(
              totalLoan: totalLoan,
              paidLoan: paidLoan,
              totalInstallment: totalInstallment,
              radius: 120,
              paidColor: paidColor,
              dueColor: dueColor,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountDisplay("\৳ ${paidLoan.toStringAsFixed(2)}", "Paid Loan", paidColor),
                _buildAmountDisplay("\৳ ${(totalLoan - paidLoan).toStringAsFixed(2)}", "Due Loan", dueColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDisplay(String amount, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class SemicircularIndicator extends StatelessWidget {
  final double totalLoan;
  final double paidLoan;
  final int totalInstallment;
  final double radius;
  final Color paidColor;
  final Color dueColor;

  const SemicircularIndicator({
    Key? key,
    required this.totalLoan,
    required this.paidLoan,
    required this.totalInstallment,
    required this.radius,
    required this.paidColor,
    required this.dueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = paidLoan / totalLoan;
    final remainingInstallments = ((totalLoan - paidLoan) / (totalLoan / totalInstallment)).ceil();

    return Stack(
      alignment: Alignment.center,
      children: [
        SemicircularPercentIndicator(
          radius: radius,
          lineWidth: 10.0,
          percent: progress,
          paidColor: paidColor,
          dueColor: dueColor,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$remainingInstallments/10",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const Text(
              "left installment",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class SemicircularPercentIndicator extends StatelessWidget {
  final double radius;
  final double lineWidth;
  final double percent;
  final Color paidColor;
  final Color dueColor;

  const SemicircularPercentIndicator({
    Key? key,
    required this.radius,
    required this.lineWidth,
    required this.percent,
    required this.paidColor,
    required this.dueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius),
      painter: _SemicircleCustomPainter(
        lineWidth: lineWidth,
        percent: percent,
        paidColor: paidColor,
        dueColor: dueColor,
      ),
    );
  }
}

class _SemicircleCustomPainter extends CustomPainter {
  final double lineWidth;
  final double percent;
  final Color paidColor;
  final Color dueColor;

  _SemicircleCustomPainter({
    required this.lineWidth,
    required this.percent,
    required this.paidColor,
    required this.dueColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint duePaint = Paint()
      ..color = dueColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint paidPaint = Paint()
      ..color = paidColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double center = size.width / 2;
    Rect rect = Rect.fromCircle(center: Offset(center, size.height), radius: size.height - lineWidth / 2);

    // Draw the full semicircle in the due color
    canvas.drawArc(rect, 3.14159, 3.14159, false, duePaint);
    // Draw the paid portion over it
    canvas.drawArc(rect, 3.14159, 3.14159 * percent, false, paidPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}