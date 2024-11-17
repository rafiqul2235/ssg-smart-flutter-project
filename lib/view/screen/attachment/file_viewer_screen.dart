import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileViewerScreen extends StatefulWidget {
  final String url;
  const FileViewerScreen({required this.url});


  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  String? localPath;
  bool isPdf = false;

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }
  @override
  void didUpdateWidget(covariant FileViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the file URL changes, prepare the new file
    if (oldWidget.url != widget.url) {
      _prepareFile();
    }
  }

  Future<void> _prepareFile() async {
    setState(() {
      localPath = null;
    });
    isPdf = widget.url.toLowerCase().endsWith('.pdf');

    // Download the file
    final response = await http.get(Uri.parse(widget.url));
    final bytes = response.bodyBytes;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${isPdf ? 'temp.pdf' : 'temp_image'}');

    await file.writeAsBytes(bytes);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPdf ? 'PDF Viewer' : 'Image Viewer'),
      ),
      body: localPath != null
          ? isPdf
              ? PDFView(
                  filePath: localPath,
                )
              :  Center(
                child: InteractiveViewer(
                  panEnabled: true, // Enable panning
                  minScale: 0.5,     // Minimum scale level
                  maxScale: 5.0,     // Maximum scale level for zoom
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.file(File(localPath!))
                  ),
                ),
              )
          : Center(child: CircularProgressIndicator(),)
    );
  }
}
