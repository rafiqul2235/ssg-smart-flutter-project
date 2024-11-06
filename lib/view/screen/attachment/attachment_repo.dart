import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ssg_smart2/view/screen/leave/leave_data.dart';

import '../../../data/datasource/remote/dio/dio_client.dart';
import '../../../utill/app_constants.dart';
import '../leave/leave_response.dart';

class AttachmentRepo {
  final DioClient dioClient;

  AttachmentRepo({required this.dioClient});

  Future<LeaveRequestResponse> submitLeaveAttach({
    required String empId,
    required String empName,
    required String leaveType,
    required String startDate,
    required String endDate,
    PlatformFile? attachment,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'emp_id': empId,
        'emp_name': empName,
        'leave_type': leaveType,
        'start_date': startDate,
        'end_date': endDate
      });

      if (attachment != null && attachment.bytes != null) {
        formData.files.add(
            MapEntry(
                'attachment',
                MultipartFile.fromBytes(
                    attachment.bytes!,
                    filename: attachment.name,
                    contentType: DioMediaType.parse(
                      getContentType(attachment.extension ?? ''),
                    )
                )
            )
        );
      }

      Response response = await dioClient.post(
          AppConstants.ATTACHMENT_PROJECT,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          )
      );

      // Convert ApiResponse to LeaveRequestResponse
      if (response.statusCode == 200) {
        return LeaveRequestResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to submit leave attachment');
      }
    } catch (e) {
      print("attachment repo error: $e");
      throw Exception('Failed to submit leave attachment: ${e.toString()}');
    }
  }

  String getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      default:
        return 'application/octet-stream';
    }
  }

  Future<List<AttachmentData>> fetchAttachData(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.FETCH_ATTACHMENT,
        data: {
          'emp_id': empId,
        },
      );

      if (response.statusCode == 200){
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 && responseData['leave_data'] != null) {
          return (responseData['leave_data'] as List)
              .map((json) => AttachmentData.fromJson(json))
              .toList();
        }else {
          throw Exception("Failed to load leave data");
        }
      }else {
        throw Exception("Failed to load leave data");
      }
    }catch (e) {
      throw Exception("Error fetching leave data");
    }
  }


}