import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/screen/attachment/attachment_provider.dart';
import 'package:ssg_smart2/view/screen/attachment/file_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AitViewScreen extends StatefulWidget {
   final bool isBackButtonExist;

   const AitViewScreen({Key? key, this.isBackButtonExist = true})
       : super(key: key);

  @override
  State<AitViewScreen> createState() => _AitViewScreenState();
}

class _AitViewScreenState extends State<AitViewScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<AttachmentProvider>().fetchAitData(),
    );
  }

  Future<void> _openFile(String url, String fileName) async {
    final extension = url.toLowerCase().split('.').last;
    fileName = url.toLowerCase().split('/').last;

    final supportedImageFormats = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    if (extension == 'pdf' || supportedImageFormats.contains(extension)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FileViewScreen(
                url: url,
                title: fileName, // Or any other title you want to display
              )
          )
      );
    } else {
      // For other file types, use the url_launcher
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Couldn't open file")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIT Records'),
      ),
      body: Consumer<AttachmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error),
                  ElevatedButton(
                    onPressed: () => provider.fetchAitData(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchAitData(),
            child: ListView.builder(
              itemCount: provider.aitData.length,
              itemBuilder: (context, index) {
                final ait = provider.aitData[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Custoemr Name', ait.customerName),
                        _buildInfoRow('Challan No', ait.challanNo),
                        _buildInfoRow('Invoice Amount', ait.invoiceAmount),
                        _buildInfoRow('AIT Amount', ait.aitAmount),
                        _buildInfoRow('Challan Date', ait.challanDate),
                        if (ait.filePaths.isNotEmpty) ...[
                          ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Attached Files (${ait.filePaths.length})'
                                ),
                              ),
                            children: [
                              Wrap(
                                spacing: 8,
                                alignment: WrapAlignment.start,
                                children: ait.filePaths.map((path) {
                                  return ElevatedButton.icon(
                                    icon: Icon(Icons.attach_file),
                                    label: Text('View File'),
                                    onPressed: () => _openFile(path, 'File Name'),
                                  );
                                }).toList(),
                              ),
                            ]
                          ),
                        ],
                        _actionButtonWidget()
                      ],

                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  Widget _actionButtonWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {},
                child: Text('Reject')
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text('Approved')
            )
          ],
        ),
      ),
    );
  }
}

