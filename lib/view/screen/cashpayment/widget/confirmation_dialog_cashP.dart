import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';

class ConfirmationDialogCashP extends StatefulWidget {
  final String transactionId;
  final String action;
  final String empId;
  final bool isApprove;
  final Function(bool isSuccess, String message) onResult;

  const ConfirmationDialogCashP({
    Key? key,
    required this.transactionId,
    required this.action,
    required this.empId,
    required this.isApprove,
    required this.onResult
  }) : super(key: key);

  @override
  _ConfirmationDialogCashPState createState() => _ConfirmationDialogCashPState();
}

class _ConfirmationDialogCashPState extends State<ConfirmationDialogCashP> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text(
              getTranslated(widget.isApprove ? 'want_to_accept' : 'want_to_reject', context),
              style: robotoBold,
              textAlign: TextAlign.center),
        ),
        const Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [
          Expanded(child: InkWell(
            onTap: () => _handleConfirmation(context),
            //onTap: _handleYesButton,
            child: Container(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: ColorResources.RED, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('YES', context), style: titilliumBold.copyWith(color: ColorResources.WHITE)),
            ),
          )),
          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('NO', context), style: titilliumBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),
        ]),
      ]),
    );
  }

  Future<void> _handleConfirmation(BuildContext context) async {
    Navigator.pop(context);
    final cashProvider = Provider.of<CashPaymentProvider>(context, listen: false);
    await cashProvider.updateCashPaymentAkg(context, widget.transactionId, widget.action, widget.empId);
    print("working handle function");

    if (cashProvider.isSuccess != null) {
      widget.onResult(true, cashProvider.isSuccess!);
    } else if (cashProvider.error != null) {
      widget.onResult(false, cashProvider.error!);
    } else {
      widget.onResult(false, "An unknown error occurred");
    }

    /*if (mounted) {
      setState(() {
        if (cashProvider.isSuccess != null) {
          widget.onConfirmed();
          _showSuccessDialog(cashProvider.isSuccess!);
        } else if (cashProvider.error.isNotEmpty) {
          _showErrorDialog(cashProvider.error);
        } else {
          _showErrorDialog("An unknown error occurred");
        }
      });
    }*/
  }

}