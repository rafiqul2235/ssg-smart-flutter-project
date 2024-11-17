import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class FileViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const FileViewScreen({
    Key? key,
    required this.url,
    this.title
  }): super(key: key);

  @override
  State<FileViewScreen> createState() => _FileViewScreenState();
}

class _FileViewScreenState extends State<FileViewScreen> {
  String? localPath;
  bool isLoading = true;
  bool hasError = false;
  late final FileType fileType;

  @override
  void initState() {
    super.initState();
    fileType = _getFileType(widget.url);
    print('file type: $fileType');
    _downLoadAndSaveFile();
  }

  FileType _getFileType(String url) {
    final extension = url.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return FileType.pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return FileType.image;
      default:
        return FileType.unknown;
    }
  }

  Future<void> _downLoadAndSaveFile() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) {
        throw Exception("Failed to download file");
      }

      // Get temporary directory
      final dir = await getTemporaryDirectory();
      final fileName = widget.url.split('/').last;
      final file = File('${dir.path}/$fileName');
      print("dir: $dir");
      print("File: $file");
      // Save file to temporary storage
      await file.writeAsBytes(response.bodyBytes);

      print("file: $file");

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading file: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Document Viewer'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)
        ),
        actions: [
          if (!isLoading && !hasError && localPath != null)
            IconButton(
                onPressed: _downLoadAndSaveFile,
                icon: Icon(Icons.refresh)
            )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16,),
            Text('Loading file...')
          ],
        ),
      );
    }
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red,),
            SizedBox(height: 16),
            Text('Failed to load file'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _downLoadAndSaveFile,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (localPath == null) {
      return Center(child: Text('Unable to load file'));
    }

    switch (fileType) {
      case FileType.pdf:
        return PDFView(
          filePath: localPath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          onError: (error) {
            setState(() {
              hasError = true;
            });
          },
          onPageError: (page, error){
            print('Error loading page $page: $error');
          },
        );
      case FileType.image:
        return PhotoView(
          imageProvider: FileImage(File(localPath!)),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        );
      case FileType.unknown:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
              SizedBox(height: 16),
              Text('Unsupported file type'),
            ],
          ),
        );
    }
  }
  @override
  void dispose() {
    // Clean up temporary file
    if (localPath != null) {
      File(localPath!).delete().catchError((e) => print('Error deleting temp file: $e'));
    }
    super.dispose();
  }
}


enum FileType {
  pdf,
  image,
  unknown
}
