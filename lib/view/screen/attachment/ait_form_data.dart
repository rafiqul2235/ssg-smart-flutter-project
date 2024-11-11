import 'package:file_picker/file_picker.dart';

class AitFormData {
  final String? customerName;
  final String? challanNumber;
  final String? invoiceAmount;
  final String? aitAmount;
  final String? date;
  final List<PlatformFile> attachments;

  AitFormData({
      this.customerName,
      this.challanNumber,
      this.invoiceAmount,
      this.aitAmount,
      this.date,
      this.attachments = const [],
});
}