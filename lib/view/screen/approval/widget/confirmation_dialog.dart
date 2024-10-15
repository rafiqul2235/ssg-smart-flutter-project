import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';

import '../../../basewidget/animated_custom_dialog.dart';
import '../../../basewidget/my_dialog.dart';

class ConfirmationDialog extends StatelessWidget {
  final String notificationId;
  final String action;
  final String comment;
  final bool isApprove;
  final Function(bool isSuccess, String message) onResult;

  const ConfirmationDialog({
    Key? key,
    required this.notificationId,
    required this.action,
    required this.comment,
    required this.isApprove,
    required this.onResult
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text(
              getTranslated(isApprove ? 'want_to_approve' : 'want_to_reject', context),
              style: robotoBold,
              textAlign: TextAlign.center),
        ),
        const Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [
          Expanded(child: InkWell(
            onTap: () => _handleConfirmation(context),
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
    final approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
    await approvalProvider.handleApproval(context, notificationId, action, comment);

    if (approvalProvider.isSuccess != null) {
      onResult(true, approvalProvider.isSuccess!);
    } else if (approvalProvider.error != null) {
      onResult(false, approvalProvider.error!);
    } else {
      onResult(false, "An unknown error occurred");
    }
  }

  void _showResultDialog(BuildContext context, bool isSuccess, String message) {
    print("Show result dialog is working.");
    if (context.mounted) {
      showAnimatedDialog(
        context,
        MyDialog(
          icon: isSuccess ? Icons.check : Icons.error,
          title: isSuccess ? 'Success' : 'Error',
          description: message,
          rotateAngle: 0,
          positionButtonTxt: 'Ok',
        ),
        dismissible: false,
      );
    }
  }
}