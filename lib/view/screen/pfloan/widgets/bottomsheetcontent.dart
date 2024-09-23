import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/saladv_info.dart';
import 'package:ssg_smart2/data/model/body/salary_data.dart';
import 'package:ssg_smart2/provider/salaryAdv_provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';

class BottomSheetContent extends StatefulWidget {
  final SalaryAdvInfo salaryAdvInfo;

  const BottomSheetContent({Key? key, required this.salaryAdvInfo}) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TextEditingController _loanAmountController;
  late double _loanAmount;
  int _installmentNumber = 4;

  @override
  void initState() {
    super.initState();
    _loanAmount = widget.salaryAdvInfo.maxLoanAmount.clamp(
        0, widget.salaryAdvInfo.maxLoanAmount);
    _loanAmountController =
        TextEditingController(text: _loanAmount.round().toString());
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _loanAmountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom),
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
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildDragHandle(),
                    const SizedBox(height: 20),
                    _buildLoanAmountSection(),
                    const SizedBox(height: 20),
                    _buildInstallmentSection(),
                    const SizedBox(height: 20),
                    _buildReasonSection(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
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
        const SizedBox(height: 10),
        TextFormField(
          controller: _loanAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            prefixText: '৳ ',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final parsedValue = double.tryParse(value);
            if (parsedValue == null || parsedValue <= 0) {
              return 'Enter a valid loan amount';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _loanAmount = double.tryParse(value) ?? 0;
              _loanAmount =
                  _loanAmount.clamp(0, widget.salaryAdvInfo.maxLoanAmount);
              _loanAmountController.text = _loanAmount.round().toString();
            });
          },
          onTap: () => _scrollToField(0),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('৳0', style: TextStyle(color: Colors.grey)),
            Text(
              '৳${widget.salaryAdvInfo.maxLoanAmount.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Slider(
          value: _loanAmount,
          min: 0,
          max: widget.salaryAdvInfo.maxLoanAmount,
          divisions: widget.salaryAdvInfo.maxLoanAmount.round(),
          label: '৳${_loanAmount.round()}',
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
        TextFormField(
          controller: _reasonController,
          decoration: const InputDecoration(
            hintText: 'Reason',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a reason';
            }
            return null;
          },
          onTap: () => _scrollToField(1),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Consumer<SalaryAdvProvider>(
      builder: (context, salProvider, child) {
        final userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                SalaryAdvanceData salaryAdvanceData = SalaryAdvanceData(
                    empId: userInfoModel!.employeeNumber!,
                    empName: userInfoModel.fullName!,
                    designation: userInfoModel.designation!,
                    department: userInfoModel.department!,
                    location: userInfoModel.workLocation!,
                    eligibilityStatus: salProvider.salaryEligibleInfo!.eligibilityStatus,
                    eligibilityAmount: salProvider.salaryEligibleInfo!.eligibilityAmount,
                    amount: _loanAmount,
                    installment: _installmentNumber,
                    reason: _reasonController.text,
                    applicationType: "SALLOAN",
                    statusFlg: "Initiated",
                    lastUpdateBy: userInfoModel.employeeNumber!,
                    lastUpdateLogin: userInfoModel.employeeNumber!
                );
                await salProvider.submitData(
                  salaryAdvanceData
                );
                Navigator.pop(context); // Close bottom sheet after submission
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _scrollToField(int fieldIndex) {
    final targetPosition = fieldIndex == 0 ? 0.0 : _scrollController.position
        .maxScrollExtent;
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
