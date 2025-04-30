import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:file_picker/file_picker.dart';

class PdfCompressionHelper3 {
  // Target size ranges (in bytes)
  static const int HIGH_QUALITY_MIN = 800 * 1024;  // 800KB
  static const int HIGH_QUALITY_MAX = 1000 * 1024;  // 1000KB

  static const int MEDIUM_QUALITY_MIN = 600 * 1024;  // 600KB
  static const int MEDIUM_QUALITY_MAX = 800 * 1024;  // 800KB

  static const int LOW_QUALITY_MIN = 100 * 1024;  // 100KB
  static const int LOW_QUALITY_MAX = 500 * 1024;  // 500KB

  /// Compress PDF file with iterative approach to achieve target file sizes
  static Future<File?> compressPdf(PlatformFile pdfFile, {String quality = 'MEDIUM'}) async {
    if (pdfFile.path == null) {
      throw Exception('File path is null');
    }

    try {
      // Define target range based on quality
      int minSize, maxSize;
      CompressQuality initialQuality;

      switch (quality) {
        case 'HIGH':
          minSize = HIGH_QUALITY_MIN;
          maxSize = HIGH_QUALITY_MAX;
          initialQuality = CompressQuality.HIGH;
          break;
        case 'LOW':
          minSize = LOW_QUALITY_MIN;
          maxSize = LOW_QUALITY_MAX;
          initialQuality = CompressQuality.LOW;
          break;
        case 'MEDIUM':
        default:
          minSize = MEDIUM_QUALITY_MIN;
          maxSize = MEDIUM_QUALITY_MAX;
          initialQuality = CompressQuality.MEDIUM;
          break;
      }

      // Try standard compression first
      File? result = await _compressWithQuality(pdfFile, initialQuality);
      if (result == null) return null;

      // Check if size is in target range
      int fileSize = await result.length();

      // If size is already in target range, return file
      if (fileSize >= minSize && fileSize <= maxSize) {
        return result;
      }

      // If file is too small or too large, try custom approach
      return await _customCompressToTargetSize(pdfFile, minSize, maxSize);
    } catch (e) {
      print('Error compressing PDF: $e');
      // If compression fails, return the original file
      return pdfFile.path != null ? File(pdfFile.path!) : null;
    }
  }

  /// Helper method to compress with standard quality
  static Future<File?> _compressWithQuality(PlatformFile pdfFile, CompressQuality quality) async {
    try {
      // Create temp directory for output file
      final tempDir = await getTemporaryDirectory();
      final outputFilePath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Use the pdf_compressor package to compress the PDF
      await PdfCompressor.compressPdfFile(
        pdfFile.path!,
        outputFilePath,
        quality,
      );

      File compressedFile = File(outputFilePath);

      // Verify the compressed file exists and has content
      if (await compressedFile.exists() && (await compressedFile.length()) > 0) {
        return compressedFile;
      } else {
        throw Exception('Compressed file is empty or does not exist');
      }
    } catch (e) {
      print('Error in _compressWithQuality: $e');
      return null;
    }
  }

  /// Custom method to achieve target file size through iterative compression
  static Future<File?> _customCompressToTargetSize(PlatformFile pdfFile, int minSize, int maxSize) async {
    // Let's use a binary search approach to find the right quality setting

    // First, gather data points by trying different qualities
    final highQualityFile = await _compressWithQuality(pdfFile, CompressQuality.HIGH);
    final mediumQualityFile = await _compressWithQuality(pdfFile, CompressQuality.MEDIUM);
    final lowQualityFile = await _compressWithQuality(pdfFile, CompressQuality.LOW);

    if (highQualityFile == null || mediumQualityFile == null || lowQualityFile == null) {
      // If any compression fails, return best effort
      return highQualityFile ?? mediumQualityFile ?? lowQualityFile;
    }

    // Get file sizes
    final highSize = await highQualityFile.length();
    final mediumSize = await mediumQualityFile.length();
    final lowSize = await lowQualityFile.length();

    // Based on these sizes, select the best file that's closest to our target range
    if (highSize >= minSize && highSize <= maxSize) {
      return highQualityFile;
    } else if (mediumSize >= minSize && mediumSize <= maxSize) {
      return mediumQualityFile;
    } else if (lowSize >= minSize && lowSize <= maxSize) {
      return lowQualityFile;
    }

    // If no file is in range, select closest one
    int highDiff = _calculateDistanceToRange(highSize, minSize, maxSize);
    int mediumDiff = _calculateDistanceToRange(mediumSize, minSize, maxSize);
    int lowDiff = _calculateDistanceToRange(lowSize, minSize, maxSize);

    int minDiff = min(min(highDiff, mediumDiff), lowDiff);

    if (minDiff == highDiff) {
      return highQualityFile;
    } else if (minDiff == mediumDiff) {
      return mediumQualityFile;
    } else {
      return lowQualityFile;
    }
  }

  /// Calculate how far a size is from the target range
  static int _calculateDistanceToRange(int size, int minSize, int maxSize) {
    if (size < minSize) {
      return minSize - size;
    } else if (size > maxSize) {
      return size - maxSize;
    } else {
      return 0;  // Already in range
    }
  }

  /// Smart compression based on file size
  static Future<File?> smartCompressPdf(PlatformFile pdfFile) async {
    final fileSize = pdfFile.size;

    // Determine quality level based on original file size
    String quality;
    if (fileSize > 10 * 1024 * 1024) {  // Files > 10MB
      quality = 'LOW';
    } else if (fileSize > 5 * 1024 * 1024) {  // Files 5-10MB
      quality = 'MEDIUM';
    } else {
      quality = 'HIGH';
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

  /// Estimate resulting file size based on quality level and original size
  static int estimateCompressedSize(int originalSize, String quality) {
    switch (quality) {
      case 'HIGH':
        return max((originalSize * 0.7).toInt(), HIGH_QUALITY_MIN);
      case 'MEDIUM':
        return max((originalSize * 0.5).toInt(), MEDIUM_QUALITY_MIN);
      case 'LOW':
        return max((originalSize * 0.3).toInt(), LOW_QUALITY_MIN);
      default:
        return (originalSize * 0.5).toInt();
    }
  }
}