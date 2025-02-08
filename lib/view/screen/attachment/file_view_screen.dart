import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileViewScreen extends StatelessWidget {
  final String url;
  final String? title;

  const FileViewScreen({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  // Future<void> _launchURL(BuildContext context) async {
  //   final Uri uri = Uri.parse(url);
  //
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     _showErrorDialog(context);
  //   }
  // }
  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Keeps it in an external browser
      );

      if (!launched) {
        _showErrorDialog(context);
      }
    } else {
      _showErrorDialog(context);
    }
  }


  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text('Could not open the document. Please check the URL.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Document Viewer'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchURL(context),
          child: Text('Open Document in Browser'),
        ),
      ),
    );
  }
}
