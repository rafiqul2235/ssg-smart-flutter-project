import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/attachment/file_viewer_widget.dart';

import '../../../provider/user_provider.dart';
import '../empselfservice/self_service.dart';
import 'attachment_provider.dart';

class AttachmentScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const AttachmentScreen({this.isBackButtonExist = true,super.key});

  @override
  State<AttachmentScreen> createState() => _AttachmentScreenState();
}
class _AttachmentScreenState extends State<AttachmentScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling fetchAttachmentData during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttachments();
    });
  }

  void _loadAttachments() {
    final userInfo = Provider.of<UserProvider>(context, listen: false).userInfoModel;
    final employeeNumber = userInfo?.employeeNumber ?? '';
    print("emp info: $employeeNumber");
    Provider.of<AttachmentProvider>(context, listen: false)
        .fetchAttachmentData(employeeNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Leave Data",
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const SelfService(),
            ),
          );
        },
      ),
      body: Consumer<AttachmentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _loadAttachments,
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (provider.attachment.isEmpty) {
            return Center(child: Text("No attachments found"));
          }
          print("data: ${provider.attachment}");
          return RefreshIndicator(
            onRefresh: () async => _loadAttachments(),
            child: ListView.builder(
              itemCount: provider.attachment.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = provider.attachment[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(item.challanNo),
                        subtitle: Text('Employee: ${item.customerName}'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: FileViewerWidget(
                          name: item.challanNo,
                          url: item.imageUrl,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
