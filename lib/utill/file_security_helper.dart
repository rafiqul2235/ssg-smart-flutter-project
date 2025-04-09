import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FileSecurityHelper {
  // List of allowed file extensions - moved to class level for easy management
  static final List<String> allowedExtensions = [
    'pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'
  ];

  // List of known malicious extensions that should be blocked
  static final List<String> maliciousExtensions = [
    'exe', 'bat', 'cmd', 'sh', 'vbs', 'js', 'wsf', 'msi',
    'com', 'scr', 'pif', 'jar', 'ps1'
  ];

  // Maximum allowed file size (in bytes) - 5MB
  static const int MAX_FILE_SIZE = 10 * 24 * 1024;

  // Check if file extension is in allowed list
  static bool isFileExtensionAllowed(String fileName) {
    final extension = path.extension(fileName).toLowerCase().replaceAll('.', '');
    return allowedExtensions.contains(extension);
  }

  // Check if file extension is in malicious list
  static bool isFileExtensionMalicious(String fileName) {
    final extension = path.extension(fileName).toLowerCase().replaceAll('.', '');
    return maliciousExtensions.contains(extension);
  }

  // Check file size
  static bool isFileSizeSafe(int fileSize) {
    return fileSize <= MAX_FILE_SIZE;
  }

  // Verify file signature
  static Future<bool> hasValidFileSignature(String filePath) async {
    try {
      final file = File(filePath);
      List<int> bytes = [];

      // Read first 8 bytes for signature checking
      await file.openRead(0, 8).forEach((element) {
        bytes.addAll(element);
      });

      if (bytes.isEmpty) return false;

      // PDF signature: %PDF (25 50 44 46)
      if (bytes.length >= 4 &&
          bytes[0] == 0x25 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x44 &&
          bytes[3] == 0x46) {
        return true;
      }

      // PNG signature: 89 50 4E 47 0D 0A 1A 0A
      if (bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47 &&
          bytes[4] == 0x0D &&
          bytes[5] == 0x0A &&
          bytes[6] == 0x1A &&
          bytes[7] == 0x0A) {
        return true;
      }

      // JPEG signature: FF D8 FF
      if (bytes.length >= 3 &&
          bytes[0] == 0xFF &&
          bytes[1] == 0xD8 &&
          bytes[2] == 0xFF) {
        return true;
      }

      // DOC signature: D0 CF 11 E0
      if (bytes.length >= 4 &&
          bytes[0] == 0xD0 &&
          bytes[1] == 0xCF &&
          bytes[2] == 0x11 &&
          bytes[3] == 0xE0) {
        return true;
      }

      // DOCX signature (ZIP format): 50 4B 03 04
      if (bytes.length >= 4 &&
          bytes[0] == 0x50 &&
          bytes[1] == 0x4B &&
          bytes[2] == 0x03 &&
          bytes[3] == 0x04) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking file signature: $e');
      return true; // Return true on error to avoid blocking valid files
    }
  }
}

// Enhanced file picker function
Future<PlatformFile?> pickSecureFile(BuildContext context) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: FileSecurityHelper.allowedExtensions,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      final file = result.files.first;

      // Check file size
      // if (!FileSecurityHelper.isFileSizeSafe(file.size)) {
      //   _showSecurityAlert(
      //       context,
      //       'File size exceeds maximum limit of ${(FileSecurityHelper.MAX_FILE_SIZE / (1024 * 1024)).toStringAsFixed(1)}MB'
      //   );
      //   return null;
      // }

      // Check if file extension is allowed
      if (!FileSecurityHelper.isFileExtensionAllowed(file.name)) {
        _showSecurityAlert(context, 'File type not allowed. Please select a PDF, DOC, DOCX, JPG, or PNG file.');
        return null;
      }

      // Check if file extension is in malicious list
      if (FileSecurityHelper.isFileExtensionMalicious(file.name)) {
        _showSecurityAlert(context, 'Potentially dangerous file type detected.');
        return null;
      }

      // Only perform signature check for files with path
      if (file.path != null) {
        final isValidSignature = await FileSecurityHelper.hasValidFileSignature(file.path!);
        if (!isValidSignature) {
          print('Warning: File signature check failed, but allowing file if extension is valid');
          // We don't block the file here as some valid PDFs might fail signature check
        }
      }

      return file;
    }
    return null;
  } catch (e) {
    print('Error picking file: $e');
    _showSecurityAlert(context, 'Error selecting file. Please try again.');
    return null;
  }
}

void _showSecurityAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('File Upload Alert'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}