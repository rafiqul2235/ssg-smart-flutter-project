import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:file_picker/file_picker.dart';

// Add this to your FileSecurityHelper class or create a new PDF helper class
class PdfCompressionHelper {
  // Compression quality levels
  static const CompressQuality HIGH_QUALITY = CompressQuality.HIGH;
  static const CompressQuality MEDIUM_QUALITY = CompressQuality.MEDIUM;
  static const CompressQuality LOW_QUALITY = CompressQuality.LOW;

  // Maximum sizes for different quality levels (in bytes)
  static const int SIZE_FOR_HIGH = 2 * 1024 * 1024;  // 2MB
  static const int SIZE_FOR_MEDIUM = 3 * 1024 * 1024;  // 3MB
  static const int SIZE_FOR_LOW = 4 * 1024 * 1024;  // 4MB

  /// Compress PDF file based on its size and desired quality
  static Future<File?> compressPdf(PlatformFile pdfFile, {CompressQuality quality = CompressQuality.MEDIUM}) async {
    if (pdfFile.path == null) {
      throw Exception('File path is null');
    }

    try {
      // Create temp directory for output file
      final tempDir = await getTemporaryDirectory();
      final outputFilePath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Auto-select compression quality based on file size if not specified
      CompressQuality compressionQuality = quality;
      if (quality == CompressQuality.MEDIUM) {
        if (pdfFile.size <= SIZE_FOR_HIGH) {
          compressionQuality = CompressQuality.HIGH;
        } else if (pdfFile.size <= SIZE_FOR_MEDIUM) {
          compressionQuality = CompressQuality.MEDIUM;
        } else {
          compressionQuality = CompressQuality.LOW;
        }
      }

      // Use the pdf_compressor package to compress the PDF
      await PdfCompressor.compressPdfFile(
        pdfFile.path!,
        outputFilePath,
        compressionQuality,
      );

      File compressedFile = File(outputFilePath);

      // Verify the compressed file exists and has content
      if (await compressedFile.exists() && (await compressedFile.length()) > 0) {
        return compressedFile;
      } else {
        throw Exception('Compressed file is empty or does not exist');
      }
    } catch (e) {
      print('Error compressing PDF: $e');
      // If compression fails, return the original file
      return pdfFile.path != null ? File(pdfFile.path!) : null;
    }
  }

  /// Smart compression based on file size
  static Future<File?> smartCompressPdf(PlatformFile pdfFile) async {
    // If file is already small enough, don't compress
    if (pdfFile.size <= SIZE_FOR_HIGH / 2) {
      return pdfFile.path != null ? File(pdfFile.path!) : null;
    }

    // Determine compression level based on file size
    CompressQuality quality;
    if (pdfFile.size <= SIZE_FOR_HIGH) {
      quality = HIGH_QUALITY;
    } else if (pdfFile.size <= SIZE_FOR_MEDIUM) {
      quality = HIGH_QUALITY;
    } else {
      quality = HIGH_QUALITY;
    }

    return await compressPdf(pdfFile, quality: quality);
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
