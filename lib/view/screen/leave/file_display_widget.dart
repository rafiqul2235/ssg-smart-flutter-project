import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileDisplayWidget extends StatelessWidget {
  final String name;
  final String url;
  const FileDisplayWidget({required this.name, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    if (url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png')) {
      return Container(
          height: 150,
          child: Image.network(
            url,
            fit: BoxFit.cover,
          )
      );
    } else {
      return ElevatedButton(
          onPressed: () async {
            final filePath = await downloadFile(url, name);
            if (filePath != null) OpenFile.open(filePath);
          },
          child: Text("Open file"),
      );
    }
  }

  Future<String?> downloadFile(String url, String name) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$name';
      await Dio().download(url, filePath);
      return filePath;
    }catch (e) {
      print("Download error: $e");
      return null;
    }
  }

}
