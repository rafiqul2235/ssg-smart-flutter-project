import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/empselfservice/self_service.dart';
import 'package:ssg_smart2/view/screen/attachment/attachment_provider.dart';
import 'package:ssg_smart2/view/screen/attachment/file_display_widget.dart';

import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';

class FetchAttachment extends StatefulWidget {
  final bool isBackButtonExist;

  const FetchAttachment({
    this.isBackButtonExist = true,
    super.key,
  });

  @override
  _FetchAttachmentState createState() => _FetchAttachmentState();
}

class _FetchAttachmentState extends State<FetchAttachment> {
  @override
  void initState() {
    super.initState();

    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    String employeeNumber = userInfoModel?.employeeNumber ?? '';

    // Fetch data from attachmentProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttachmentProvider>(context, listen: false).fetchAttachmentData(employeeNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final attachmentProvider = Provider.of<AttachmentProvider>(context);
    print("Attachment data: ${attachmentProvider.attachment}");

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Leave Data',
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
      body: attachmentProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: attachmentProvider.attachment.length,
        itemBuilder: (context, index) {
          final item = attachmentProvider.attachment[index];
          return Card(
            child: ListTile(
              title: Text(item.challanNo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${item.customerName}"),
                  Text("Leave Type: ${item.challanNo}"),
                  FileDisplayWidget(name: item.challanNo, url: item.imageUrl)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
