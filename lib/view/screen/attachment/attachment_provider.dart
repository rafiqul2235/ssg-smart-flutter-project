import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/view/screen/leave/leave_data.dart';

import 'attachment_repo.dart';
import '../leave/leave_response.dart';

class AttachmentProvider with ChangeNotifier {
  final AttachmentRepo attachmentRepo;
  bool _isLoading = false;
  String _error = '';
  LeaveRequestResponse? _response;

  List<AttachmentData> _attachmentData = [];
  List<AttachmentData> get attachment => _attachmentData;

  AttachmentProvider({required this.attachmentRepo});
  bool get isLoading => _isLoading;
  String get error => _error;
  LeaveRequestResponse? get response => _response;

  Future<void> submitLeaveAttach({
    required String empId,
    required String empName,
    required String leaveType,
    required String startDate,
    required String endDate,
    required PlatformFile? attachment,
  }) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _response = await attachmentRepo.submitLeaveAttach(
          empId: empId,
          empName: empName,
          leaveType: leaveType,
          startDate: startDate,
          endDate: endDate,
          attachment: attachment
      );

      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchAttachmentData(String empId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _attachmentData = await attachmentRepo.fetchAttachData(empId);
      print("Attachment data: ${_attachmentData}");
      _isLoading = false;
      notifyListeners();
    } catch(e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}