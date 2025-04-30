import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:file_picker/file_picker.dart';

class PdfCompressionHelper2 {
  // Compression quality levels
  static const CompressQuality VERY_HIGH_QUALITY = CompressQuality.HIGH;
  static const CompressQuality HIGH_QUALITY = CompressQuality.HIGH;
  static const CompressQuality MEDIUM_QUALITY = CompressQuality.MEDIUM;
  static const CompressQuality LOW_QUALITY = CompressQuality.LOW;

  // Maximum sizes for different quality levels (in bytes)
  static const int MAX_FILE_SIZE = 12 * 1024 * 1024;  // 12MB
  static const int SIZE_FOR_VERY_HIGH = 2 * 1024 * 1024;  // 2MB
  static const int SIZE_FOR_HIGH = 4 * 1024 * 1024;  // 4MB
  static const int SIZE_FOR_MEDIUM = 8 * 1024 * 1024;  // 8MB
  static const int SIZE_FOR_LOW = MAX_FILE_SIZE;  // 12MB

  // Quality loss thresholds
  static const double ACCEPTABLE_QUALITY_LOSS = 10.0; // percentage

  /// Compress PDF file based on its size and desired quality
  static Future<File?> compressPdf(PlatformFile pdfFile, {CompressQuality? quality}) async {
    if (pdfFile.path == null) {
      throw Exception('File path is null');
    }

    try {
      // Create temp directory for output file
      final tempDir = await getTemporaryDirectory();
      final outputFilePath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Auto-select compression quality based on file size if not specified
      CompressQuality compressionQuality = quality ?? _determineOptimalQuality(pdfFile.size);

      // Use the pdf_compressor package to compress the PDF
      await PdfCompressor.compressPdfFile(
        pdfFile.path!,
        outputFilePath,
        compressionQuality,
      );

      File compressedFile = File(outputFilePath);

      // Verify the compressed file exists and has content
      if (await compressedFile.exists() && (await compressedFile.length()) > 0) {
        // Check if compression resulted in acceptable quality
        if (await _isQualityAcceptable(pdfFile.path!, outputFilePath)) {
          return compressedFile;
        } else {
          // If quality is not acceptable, try a higher quality setting
          if (compressionQuality == CompressQuality.LOW) {
            return await compressPdf(pdfFile, quality: CompressQuality.MEDIUM);
          } else if (compressionQuality == CompressQuality.MEDIUM) {
            return await compressPdf(pdfFile, quality: CompressQuality.HIGH);
          } else {
            // If we're already at high quality and still not acceptable, return original
            return pdfFile.path != null ? File(pdfFile.path!) : null;
          }
        }
      } else {
        throw Exception('Compressed file is empty or does not exist');
      }
    } catch (e) {
      print('Error compressing PDF: $e');
      // If compression fails, return the original file
      return pdfFile.path != null ? File(pdfFile.path!) : null;
    }
  }

  /// Determine optimal compression quality based on file size
  static CompressQuality _determineOptimalQuality(int fileSize) {
    if (fileSize <= SIZE_FOR_VERY_HIGH) {
      return VERY_HIGH_QUALITY;
    } else if (fileSize <= SIZE_FOR_HIGH) {
      return HIGH_QUALITY;
    } else if (fileSize <= SIZE_FOR_MEDIUM) {
      return MEDIUM_QUALITY;
    } else {
      return LOW_QUALITY;
    }
  }

  /// Smart compression that balances size and quality
  static Future<File?> smartCompressPdf(PlatformFile pdfFile) async {
    // If file is already small enough, don't compress
    if (pdfFile.size <= SIZE_FOR_VERY_HIGH / 2) {
      return pdfFile.path != null ? File(pdfFile.path!) : null;
    }

    // Start with adaptive compression
    File? result = await adaptiveCompressPdf(pdfFile);

    // If adaptive compression didn't work well, try standard compression
    if (result == null) {
      return await compressPdf(pdfFile);
    }

    return result;
  }

  /// Adaptive compression that tries multiple quality levels to find optimal balance
  static Future<File?> adaptiveCompressPdf(PlatformFile pdfFile) async {
    if (pdfFile.path == null) {
      throw Exception('File path is null');
    }

    // If file size is already below threshold, return original
    if (pdfFile.size <= SIZE_FOR_VERY_HIGH) {
      return File(pdfFile.path!);
    }

    final tempDir = await getTemporaryDirectory();

    // Try different compression levels and analyze results
    List<CompressQuality> qualityLevels = [
      CompressQuality.HIGH,
      CompressQuality.MEDIUM,
      CompressQuality.LOW
    ];

    File? bestResult;
    int bestSize = pdfFile.size;

    for (var quality in qualityLevels) {
      try {
        final outputPath = '${tempDir.path}/compressed_${quality.toString()}_${DateTime.now().millisecondsSinceEpoch}.pdf';

        // Compress with current quality
        await PdfCompressor.compressPdfFile(
          pdfFile.path!,
          outputPath,
          quality,
        );

        File compressedFile = File(outputPath);

        if (await compressedFile.exists()) {
          int compressedSize = await compressedFile.length();

          // Check if this compression level provides sufficient size reduction
          // while maintaining acceptable quality
          if (compressedSize < bestSize && await _isQualityAcceptable(pdfFile.path!, outputPath)) {
            // Clean up previous best result if it exists
            if (bestResult != null && await bestResult.exists()) {
              await bestResult.delete();
            }

            bestResult = compressedFile;
            bestSize = compressedSize;
          } else if (compressedFile != bestResult) {
            // Clean up this attempt if it's not the best
            await compressedFile.delete();
          }
        }
      } catch (e) {
        print('Error during adaptive compression with quality $quality: $e');
      }
    }

    return bestResult;
  }

  /// Check if compression resulted in meaningful size reduction
  static Future<bool> isCompressionEffective(File originalFile, File compressedFile) async {
    final originalSize = await originalFile.length();
    final compressedSize = await compressedFile.length();

    // Calculate size reduction percentage
    double reductionPercent = ((originalSize - compressedSize) / originalSize) * 100;

    // Consider compression effective if size reduced by at least 15%
    return reductionPercent >= 15;
  }

  /// Check if the compressed PDF maintains acceptable quality
  static Future<bool> _isQualityAcceptable(String originalPath, String compressedPath) async {
    // This is a placeholder for actual quality comparison
    // In a real implementation, you would analyze visual quality metrics

    // For now, we're estimating quality based on file size reduction
    File originalFile = File(originalPath);
    File compressedFile = File(compressedPath);

    final originalSize = await originalFile.length();
    final compressedSize = await compressedFile.length();

    // If size reduction is too extreme, quality might be compromised
    double reductionPercent = ((originalSize - compressedSize) / originalSize) * 100;

    // If reduction is over 80%, quality might be too degraded
    if (reductionPercent > 80) {
      return false;
    }

    return true;
  }
}