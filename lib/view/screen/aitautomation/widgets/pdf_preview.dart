import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfPreviewPage extends StatelessWidget {
  final String fileName;
  final String filePath;
  const PdfPreviewPage({super.key, required this.fileName, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fileName),),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (er) {
          print('PDF View error: $er');
        },
      ),
    );
  }
}
