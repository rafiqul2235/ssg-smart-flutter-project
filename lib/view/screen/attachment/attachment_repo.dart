import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/base/new_api_resonse.dart';
import 'package:ssg_smart2/view/screen/attachment/ait_data.dart';
import 'package:ssg_smart2/view/screen/attachment/leave_data.dart';

import '../../../data/datasource/remote/dio/dio_client.dart';
import '../../../utill/app_constants.dart';
import 'leave_response.dart';

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

  Future<ApiResonseNew> submitAITAutomationForm(Map<String, dynamic> data) async {
    print("started api calling for ai automation");
    try {
      List<MultipartFile> attachments = await _getMultipartFiles(data['attachments']);

      FormData formData = FormData.fromMap({
        'customerId' : data['customerId'],
        'customerAccount': data['customerAccount'],
        'customerName' : data['customerName'],
        'customerType' : data['customerType'],
        'customerCategory' : data['customerCategory'],
        'billToAddress' : data['billToAddress'],
        'challanNo' : data['challanNo'],
        'challanDate': data['challanDate'],
        'invoiceAmount' : data['invoiceAmount'],
        'aitAmount' : data['aitAmount'],
        'remarks': data['remarks'],
        'empId': data['empId'],
        'empName': data['empName'],
        'personId': data['personId'],
        'userId': data['userId'],
        'deptName': data['deptName'],
        'designation': data['designation'],
        'orgId': data['orgId'],
        'orgName': data['orgName'],
        'attachments[]': attachments,
      });

      Response response = await dioClient.post(
        AppConstants.AIT_AUTOMATION,
        data: formData
      );
      return ApiResonseNew.withSuccess(response);
    }catch(e){
      rethrow;
    }
  }
  Future<List<MultipartFile>> _getMultipartFiles(List<File> files) async {
    List<MultipartFile> multipartFiles = [];
    for (File file in files) {
      multipartFiles.add(await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ));
    }
    return multipartFiles;
  }

  Future<List<CustomerDetails>> fetchCustomerDetailsInfo(String orgId, String salesRepId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.CUSTOMER_DETAILS,
        data: {
          'orgId': orgId,
          'salesId': salesRepId
        }
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1) {
          return (responseData['customer_details'] as List)
              .map((json) => CustomerDetails.fromJson(json))
              .toList();
        }else {
          throw Exception("Failed to load customer details.");
        }
      }else {
        throw Exception("Error to load customer details");
      }
    }catch (e) {
      throw Exception("Error: ${e.toString()}");
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
        throw Exception("Error fetching leave data");
      }
    }catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }



  Future<List<AitData>> fetchAitData() async {
    try {
      final response = await dioClient.post(
        AppConstants.AIT_VIEW,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if(data['success'] == 1) {
          final List<dynamic> aitDataList = data['ait_data'];
          return aitDataList.map((json) => AitData.fromJson(json)).toList();
        }
      }
      throw Exception("Failed to fetch AIT data");
    }catch(e){
      throw Exception('Error: $e');
    }
  }


}