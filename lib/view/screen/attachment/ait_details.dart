import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/ait_details.dart';
import 'package:ssg_smart2/data/model/body/approver.dart';
import 'package:ssg_smart2/view/screen/attachment/ait_view.dart';
import 'package:ssg_smart2/view/screen/attachment/attachment_provider.dart';
import 'package:ssg_smart2/view/screen/attachment/file_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/my_dialog.dart';
import '../approval/widget/confirmation_dialog.dart';
import '../home/dashboard_screen.dart';

class AitDetailsScreen extends StatefulWidget {
  final bool isBackButtonExist;
  final String headerId;
  final String notificationId;

  const AitDetailsScreen(
      {Key? key,
      this.isBackButtonExist = true,
      required this.headerId,
      required this.notificationId})
      : super(key: key);

  @override
  _AitDetailsScreenState createState() => _AitDetailsScreenState();
}

class _AitDetailsScreenState extends State<AitDetailsScreen> {
  final TextEditingController _remarksController = TextEditingController();
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttachmentProvider>(context, listen: false)
          .fetchAitDetails(widget.headerId);
    });
  }

  void _approveOrReject(String action, bool isApprove) {
    if (_remarksController.text.isEmpty) {
      _showCustomSnackBar(
        context,
        "Please provide remarks before ${action.toLowerCase()}ing!",
        isError: true,
      );
      return;
    }
    print('NotificatinId: ${widget.notificationId} and action: ${action}');
    showAnimatedDialog(
      context,
      ConfirmationDialog(
          applicationType: 'AIT',
          notificationId: widget.notificationId,
          action: action,
          comment: _remarksController.text,
          isApprove: isApprove,
          onResult: (isSuccess, message) {
            _showResultDialog(context, isSuccess, message);
          },
      ),
      isFlip: true,
    );
    setState(() {
      _statusMessage =
          "Successfully ${action}ed with remarks: ${_remarksController.text}";
      _remarksController.clear(); // Clear the remarks field
    });

    _showCustomSnackBar(
      context,
      "Project ${action}ed successfully!",
    );
  }

  void _showResultDialog(BuildContext context, bool isSuccess, String message) {
    showAnimatedDialog(
      context,
      MyDialog(
        icon: isSuccess ? Icons.check : Icons.error,
        title: isSuccess ? 'Success' : 'Error',
        description: message,
        rotateAngle: 0,
        positionButtonTxt: 'Ok',
        onPositiveButtonPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AitView())
          );
        },
      ),
      dismissible: false,
    );
  }

  // Custom SnackBar method for better visual feedback
  void _showCustomSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            CustomAppBar(
              title: 'AIT Approval Details',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const DashBoardScreen(),
                ));
              },
            ),
            Expanded(
              child: Consumer<AttachmentProvider>(
                builder: (context, aitProvider, child) {
                  if (aitProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final aitDetails = aitProvider.aitDetails;
                  final approverList = aitProvider.approverList;
                  print("Approver list in screen: ${approverList}");
                  // Check if the list is empty
                  if (aitDetails == null) {
                    return Center(
                      child: Text('No AIT details available'),
                    );
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AIT Project Details Card
                        _buildProjectDetailsCard(aitDetails),

                        const SizedBox(height: 20.0),

                        // Attachments Section
                        _buildAttachmentsSection(aitDetails.filePaths),

                        const SizedBox(height: 20.0),

                        // Approver History Section
                        _buildSectionHeader("Approver History"),
                        const SizedBox(height: 10.0),
                        _buildApproverHistoryList(approverList),

                        const SizedBox(height: 20.0),

                        // Remarks Section
                        _buildSectionHeader("Remarks"),
                        const SizedBox(height: 10.0),
                        _buildRemarksTextField(),

                        const SizedBox(height: 20.0),

                        // Approve/Reject Buttons
                        _buildActionButtons(),

                        // Status Message
                        if (_statusMessage != null) _buildStatusMessage(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(List<String> filePaths) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Attachments"),
        const SizedBox(height: 10.0),

        // Attachments grid
        filePaths.isEmpty
            ? _buildEmptyAttachmentPlaceholder()
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0),
                itemCount: filePaths.length,
                itemBuilder: (context, index) {
                  return _buildAttachmentThumbnail(filePaths[index]);
                },
              ),
      ],
    );
  }

  Widget _buildEmptyAttachmentPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        "No attachments available",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildAttachmentThumbnail(String filePath) {
    final fileName = filePath.split('/').last;
    final isPdf = fileName.endsWith('.pdf');

    return GestureDetector(
      // onTap: () => _openFile(filePath),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FileViewScreen(url: filePath, title: fileName,)
            )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPdf
                ? const Icon(
                    Icons.picture_as_pdf,
                    size: 50,
                    color: Colors.red,
                  )
                : Image.network(
                    filePath,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                ),
            const SizedBox(height: 8,),
            Text(
              isPdf ? 'PDF File' : 'Image File',
              style: const TextStyle(fontSize: 12),
            )
          ],
        )
      ),
    );
  }

  // Project Details Card with Enhanced Design
  Widget _buildProjectDetailsCard(AitDetail aitDetails) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AIT Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50),
                  ),
            ),
            const SizedBox(height: 15),
            _buildDetailRow('Customer Name', '${aitDetails.customerName}'),
            _buildDetailRow('Challan No', '${aitDetails.challanNo}'),
            _buildDetailRow('Challan Date', '${aitDetails.challanDate}'),
            _buildDetailRow('Financial Year', '${aitDetails.financialYear}'),
            _buildDetailRow('Invoice Amount', '${aitDetails.invoiceAmount}'),
            _buildDetailRow('AIT Amount', '${aitDetails.aitAmount}'),
          ],
        ),
      ),
    );
  }

  // sl: 2
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
// sl:3
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2C3E50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildApproverHistoryList(List<ApproverDetail> approverList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: approverList.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final history = approverList[index];
          return ListTile(
            title: Text(history.responderName),
            subtitle: Text(history.note),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  history.action,
                  style: TextStyle(
                    color: _getStatusColor(history.action),
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),
                Text(
                  history.actionDate,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRemarksTextField() {
    return TextField(
      controller: _remarksController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Enter your remarks here...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _approveOrReject('APPROVED', true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
                'Approve',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _approveOrReject('REJECTED', false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
                'Reject',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        _statusMessage!,
        style: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _openFile(String filePath) async {
    final Uri fileUri = Uri.parse(filePath);
    if ( await canLaunchUrl(fileUri)) {
      await launchUrl(fileUri, mode: LaunchMode.externalApplication);
    }else {
      _showCustomSnackBar(context, 'Could not open the file.');
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Initiated':
        return Colors.amber;
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
