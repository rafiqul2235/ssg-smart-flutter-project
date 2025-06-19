import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

// Add this to your FileSecurityHelper class or create a new PDF helper class
class PdfCompressionHelper {

  // Maximum sizes for different quality levels (in bytes)
  static const int SIZE_FOR_HIGH = 2 * 1024 * 1024;  // 2MB
  static const int SIZE_FOR_MEDIUM = 3 * 1024 * 1024;  // 3MB
  static const int SIZE_FOR_LOW = 4 * 1024 * 1024;  // 4MB


  /// Smart compression based on file size
  static Future<File?> smartCompressPdf(PlatformFile pdfFile) async {
    // If file is already small enough, don't compress
    if (pdfFile.size <= SIZE_FOR_HIGH / 2) {
      return pdfFile.path != null ? File(pdfFile.path!) : null;
    }

    // Determine compression level based on file size

  }

  /// Check if compression resulted in meaningful size reduction
  static Future<bool> isCompressionEffective(File originalFile, File compressedFile) async {
    final originalSize = await originalFile.length();
    final compressedSize = await compressedFile.length();

    // Calculate size reduction percentage
    double reductionPercent = ((originalSize - compressedSize) / originalSize) * 100;

    // Consider compression effective if size reduced by at least 10%
    return reductionPercent >= 10;
  }
}
