import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssg_smart2/data/model/body/saladv_info.dart';



class BottomSheetContent extends StatefulWidget {
  final SalaryAdvInfo salaryAdvInfo;

  const BottomSheetContent({Key? key, required this.salaryAdvInfo}) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late double _loanAmount;
  int _installmentNumber = 4;
  final _reasonController = TextEditingController();
  late TextEditingController _loanAmountController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loanAmount = widget.salaryAdvInfo.maxLoanAmount.clamp(0, widget.salaryAdvInfo.maxLoanAmount);
    _loanAmountController = TextEditingController(text: _loanAmount.round().toString());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: controller,
                children: [
                  _buildDragHandle(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLoanAmountSection(),
                        const SizedBox(height: 20),
                        _buildInstallmentSection(),
                        const SizedBox(height: 20),
                        _buildReasonSection(),
                        const SizedBox(height: 20),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 4,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLoanAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Loan Amount',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('Enter or move the slider to select your loan amount'),
        const SizedBox(height: 10),
        TextField(
          controller: _loanAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            prefixText: '\৳ ',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          onChanged: (value) {
            setState(() {
              _loanAmount = double.tryParse(value) ?? 0;
              _loanAmount = _loanAmount.clamp(0, widget.salaryAdvInfo.maxLoanAmount);
              _loanAmountController.text = _loanAmount.round().toString();
            });
          },
          onTap: () => _scrollToField(0),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\৳0', style: TextStyle(color: Colors.grey[600])),
            Text('\৳${widget.salaryAdvInfo.maxLoanAmount.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Slider(
          value: _loanAmount,
          min: 0,
          max: widget.salaryAdvInfo.maxLoanAmount,
          divisions: (widget.salaryAdvInfo.maxLoanAmount / 100).round(),
          label: '\৳${_loanAmount.round()}',
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
          onChanged: (value) {
            setState(() {
              _loanAmount = value;
              _loanAmountController.text = value.round().toString();
            });
          },
        ),
      ],
    );
  }
  Widget _buildInstallmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Installment Number',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('Slide to select the number of installments'),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.salaryAdvInfo.maxInstallments,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _installmentNumber = index + 1;
                  });
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: _installmentNumber == index + 1
                        ? Colors.blue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _installmentNumber == index + 1
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provide Reason',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _reasonController,
          decoration: const InputDecoration(
            hintText: 'Reason',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          onTap: () => _scrollToField(1),
        ),
      ],
    );
  }


  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          // Handle form submission
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  void _scrollToField(int fieldIndex) {
    final targetPosition = fieldIndex == 0 ? 0.0 : _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}