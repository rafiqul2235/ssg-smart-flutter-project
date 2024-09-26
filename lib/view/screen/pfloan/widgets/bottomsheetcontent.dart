import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/pfloan_data.dart';
import 'package:ssg_smart2/data/model/body/pfloan_info.dart';
import 'package:ssg_smart2/provider/pfloan_provider.dart';
import 'package:ssg_smart2/view/screen/empselfservice/self_service.dart';

import '../../../../data/model/body/salary_data.dart';
import '../../../../data/model/response/user_info_model.dart';
import '../../../../provider/salaryAdv_provider.dart';
import '../../../../provider/user_provider.dart';
import '../../../basewidget/animated_custom_dialog.dart';
import '../../../basewidget/my_dialog.dart';


class BottomSheetContentForPF extends StatefulWidget {
  final PfLoanInfo pfLoanInfo;

  const BottomSheetContentForPF({Key? key, required this.pfLoanInfo}) : super(key: key);

  @override
  _BottomSheetContentForPFState createState() => _BottomSheetContentForPFState();
}

class _BottomSheetContentForPFState extends State<BottomSheetContentForPF> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TextEditingController _loanAmountController;
  late double _loanAmount;
  int _installmentNumber = 4;
  bool _isSubmitting = false;
  late DateTime _realizationDate;

  @override
  void initState() {
    super.initState();
    _loanAmount = widget.pfLoanInfo.maxLoanAmount.clamp(0, widget.pfLoanInfo.maxLoanAmount);
    _loanAmountController = TextEditingController(text: _loanAmount.round().toString());
    _calculateRealizationDate();
  }

  void _calculateRealizationDate() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1);
    final payrollEndDate = DateTime(nextMonth.year, nextMonth.month, 25);
    _realizationDate = payrollEndDate;
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    _buildRealizationDateSection(),
                    const SizedBox(height: 20,),
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
          decoration: InputDecoration(
            prefixText: '৳ ',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            suffixIcon: Tooltip(
              message: 'Enter the loan amount you need',
              child: Icon(Icons.info_outline),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final parsedValue = double.tryParse(value);
            if (parsedValue == null || parsedValue <= 0) {
              return 'Enter a valid loan amount';
            }
            if (parsedValue > widget.pfLoanInfo.maxLoanAmount) {
              return 'Amount exceeds maximum limit';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _loanAmount = double.tryParse(value) ?? 0;
              _loanAmount = _loanAmount.clamp(0, widget.pfLoanInfo.maxLoanAmount);
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
              '৳${widget.pfLoanInfo.maxLoanAmount.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Slider(
          value: _loanAmount,
          min: 0,
          max: widget.pfLoanInfo.maxLoanAmount,
          divisions: widget.pfLoanInfo.maxLoanAmount.round(),
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
        Row(
          children: [
            const Text(
              'Select Installment Number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Tooltip(
              message: 'Choose the number of installments for repayment',
              child: Icon(Icons.info_outline, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.pfLoanInfo.maxInstallments,
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
                    color: _installmentNumber == index + 1 ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _installmentNumber == index + 1 ? Colors.white : Colors.black,
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

  Widget _buildRealizationDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Realization Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Tooltip(
              message: 'The date when the loan will be realized',
              child: Icon(Icons.info_outline, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            DateFormat('MMMM dd, yyyy').format(_realizationDate),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Reason',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Tooltip(
              message: 'Briefly explain why you need this loan',
              child: Icon(Icons.info_outline, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _reasonController,
          decoration: const InputDecoration(
            hintText: 'Reason for loan application',
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
    return Consumer<PfLoanProvider>(
      builder: (context, pfProvider, child) {
        final userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isSubmitting ) ? null : () async {
              if (_formKey.currentState!.validate()) {
                bool success = await _submitApplication(context, pfProvider, userInfoModel!);
                if (success) {
                  Navigator.of(context).pop();
                  await _showSuccessDialog(context, "Salary adv. application submitted successfully!");
                } else {
                  _showErrorDialog(context, "${pfProvider.error}");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _isSubmitting
                ? CircularProgressIndicator(color: Colors.blue)
                : Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // void _showConfirmationDialog(BuildContext context, SalaryAdvProvider salProvider, UserInfoModel userInfoModel) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirm Submission'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Please confirm the following details:'),
  //             SizedBox(height: 10),
  //             Text('Loan Amount: ৳${_loanAmount.round()}'),
  //             Text('Installments: $_installmentNumber'),
  //             Text('Reason: ${_reasonController.text}'),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Confirm'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _submitApplication(context, salProvider, userInfoModel);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<bool> _submitApplication(BuildContext context, PfLoanProvider pfLoanProvider, UserInfoModel userInfoModel) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      PfLoanData pfLoanData = PfLoanData(
          empId: userInfoModel.employeeNumber!,
          empName: userInfoModel.fullName!,
          designation: userInfoModel.designation!,
          department: userInfoModel.department!,
          location: userInfoModel.workLocation!,
          eligibilityStatus: pfLoanProvider.pfEligibleInfo!.eligibilityStatus,
          eligibilityAmount: pfLoanProvider.pfEligibleInfo!.eligibilityAmount,
          amount: _loanAmount,
          installment: _installmentNumber,
          realizationDate: _realizationDate.toString(),
          reason: _reasonController.text,
          applicationType: "PFLOAN",
          statusFlg: "Initiated",
          lastUpdateBy: userInfoModel.employeeNumber!,
          lastUpdateLogin: userInfoModel.employeeNumber!,
      );

      await pfLoanProvider.submitData(pfLoanData);
      // Navigator.of(context).pop();
      // _showSuccessDialog(context,'Salary Adv submitted successfully');
      return true;

    } catch (e) {
      // Navigator.of(context).pop();
      // _showErrorDialog(context, 'Error occurred');
      return false;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _scrollToField(int fieldIndex) {
    final targetPosition = fieldIndex == 0 ? 0.0 : _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _showSuccessDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Your request has been submitted successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('Go Home'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SelfService(isBackButtonExist: false,))
                );
              },
            ),
          ],
        );
      },
    );
    // return showAnimatedDialog(context, MyDialog(
    //   icon: Icons.check,
    //   title: 'Success',
    //   description: message,
    //   rotateAngle: 0,
    //   positionButtonTxt: 'Go to Home',
    //   onPositiveButtonPressed: () {
    //     Navigator.of(context).pop(); // Close the dialog
    //     Navigator.of(context).pop();
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => SelfService(isBackButtonExist: false,))
    //     );
    //   },
    // ), dismissible: false);
  }
  void _showErrorDialog(BuildContext context, String message) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Error'),
    //       content: Text(message),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('OK'),
    //           onPressed: () {
    //             Navigator.of(context).pop(); // Close the dialog
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
    showAnimatedDialog(context, MyDialog(
      icon: Icons.error,
      title: 'Error',
      description: message,
      rotateAngle: 0,
      positionButtonTxt: 'Ok',
    ), dismissible: false);
  }
}
