import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/response/aitResponse.dart';
import 'package:ssg_smart2/data/model/response/ait_essential.dart';

import 'package:ssg_smart2/data/model/response/base/new_api_resonse.dart';
import 'package:ssg_smart2/data/model/ait_data.dart';

import '../datasource/remote/dio/dio_client.dart';
import '../../utill/app_constants.dart';

class AttachmentRepo {
  final DioClient dioClient;

  AttachmentRepo({required this.dioClient});



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
      // Handle single file attachment
      MultipartFile? attachment = await _getMultipartFile(data['attachment']);

      // Create map of form data
      Map<String, dynamic> formMap = {
        'customerId': data['customerId'],
        'customerAccount': data['customerAccount'],
        'customerName': data['customerName'],
        'customerType': data['customerType'],
        'customerCategory': data['customerCategory'],
        'billToAddress': data['billToAddress'],
        'salesSection': data['salesSection'],
        'statusFlg': data['statusFlg'],
        'challanNo': data['challanNo'],
        'challanDate': data['challanDate'],
        'financialYear': data['financialYear'],
        'invoiceType': data['invoiceType'],
        'invoiceAmount': data['invoiceAmount'],
        'baseAmount': data['baseAmount'],
        'aitAmount': data['aitAmount'],
        'tax': data['tax'],
        'difference': data['difference'],
        'remarks': data['remarks'],
        'empId': data['empId'],
        'empName': data['empName'],
        'personId': data['personId'],
        'userId': data['userId'],
        'deptName': data['deptName'],
        'designation': data['designation'],
        'orgId': data['orgId'],
        'orgName': data['orgName'],
      };

      // Add attachment only if it exists
      if (attachment != null) {
        formMap['attachment'] = attachment;
      }

      FormData formData = FormData.fromMap(formMap);

      Response response = await dioClient.post(
          AppConstants.AIT_AUTOMATION,
          data: formData
      );
      return ApiResonseNew.withSuccess(response);
    } catch (e) {
      rethrow;
    }
  }
  Future<ApiResonseNew> updateAitEntry(String headerId, Map<String, dynamic> data) async {
    try {
      MultipartFile? attachment = await _getMultipartFile(data['attachment']);
      Map<String, dynamic> formMap = {
        'headerId' : headerId,
        'customerId' : data['customerId'],
        'customerAccount': data['customerAccount'],
        'customerName' : data['customerName'],
        'customerType' : data['customerType'],
        'customerCategory' : data['customerCategory'],
        'billToAddress' : data['billToAddress'],
        'salesSection' : data['salesSection'],
        'statusFlg' : data['statusFlg'],
        'challanNo' : data['challanNo'],
        'challanDate': data['challanDate'],
        'financialYear': data['financialYear'],
        'invoiceType': data['invoiceType'],
        'invoiceAmount' : data['invoiceAmount'],
        'baseAmount': data['baseAmount'],
        'aitAmount' : data['aitAmount'],
        'tax' : data['tax'],
        'difference' : data['difference'],
        'remarks': data['remarks'],
        'empId': data['empId'],
        'empName': data['empName'],
        'personId': data['personId'],
        'userId': data['userId'],
        'deptName': data['deptName'],
        'designation': data['designation'],
        'orgId': data['orgId'],
        'orgName': data['orgName']
      };
      // Add attachment only if it exists
      if (attachment != null) {
        formMap['attachment'] = attachment;
      }
      FormData formData = FormData.fromMap(formMap);
      Response response = await dioClient.post(
          AppConstants.UPDATE_AIT,
          data: formData
      );
      return ApiResonseNew.withSuccess(response);
    }catch(e){
      rethrow;
    }
  }

  Future<MultipartFile?> _getMultipartFile(File? file) async {
    if (file == null) return null;

    try {
      return await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
    } catch (e) {
      print('Error creating MultipartFile: $e');
      return null;
    }
  }

  Future<AitEssentialResponse> fetchAitEssential(String orgId, String salesRepId) async {
    try {
      final response = await dioClient.postWithFormData(
          AppConstants.AIT_ESSENTIAL,
          data: {
            'orgId': orgId,
            'salesId': salesRepId
          }
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1) {
          return AitEssentialResponse.fromJson(responseData);
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

  Future<List<AitData>> fetchAitInfo(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.AIT_VIEW,
        data: {
          'emp_id': empId
        }
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

Future<AitResponse> fetchAitDetails(String headerId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.AIT_DETAILS,
        data: {
          'header_id': headerId
        }
      );
      print("API response status: ${response.statusCode}");
      print("API response data: ${response.data}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        if (data['success'] == 1) {
          return AitResponse.fromJson(data);
        }else {
          print("API returned success = 0");
          throw Exception("API returned success = 0");
        }
      }else {
        throw Exception("Failed to fetch AIT data. Status code: ${response.statusCode}");
      }
    } catch(e) {
      print("Details error in repository: $e");
      rethrow;
    }
}

Future<bool> isChallanNumberExists(String challanNumber) async {
    final response = await dioClient.postWithFormData(
      AppConstants.CHECK_CHALLAN,
      data: {
        'challanNumber': challanNumber
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      return data['exists'];
    } else {
      throw Exception('Failed to check challan number');
    }
}
}