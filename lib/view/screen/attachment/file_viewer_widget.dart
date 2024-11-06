import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileViewerWidget extends StatelessWidget {
  final String name;
  final String url;
  const FileViewerWidget({
    required this.name,
    required this.url,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return url.toLowerCase().endsWith('.jpg') ||
           url.toLowerCase().endsWith('.jpeg') ||
           url.toLowerCase().endsWith('.png')
        ? _buildImageViewer()
        : _buildFileButton(context);
  }
  
  Widget _buildImageViewer() {
    return Container(
      height: 200,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red,),
                SizedBox(height: 8,),
                Text("Failed to load iamge")
              ],
            ),
          );
        },
      ),
    );    
  }
  
  Widget _buildFileButton(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => _handleFileOpen(context),
        icon: Icon(Icons.file_present),
        label: Text('Open file'),
    );
  }

  Future<void> _handleFileOpen(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      final filePath = await _downloadFile();

      // Hide loading indicator
      Navigator.pop(context);

      if (filePath != null) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          throw Exception(result.message);
        }
      }
    } catch (e) {
      // Hide loading indicator if still showing
      Navigator.maybeOf(context)?.pop();

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to open file: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<String?> _downloadFile() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$name';

      // Check if file already exists
      if (await File(filePath).exists()) {
        return filePath;
      }

      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      print('Download error: $e');
      return null;
    }
  }
}
