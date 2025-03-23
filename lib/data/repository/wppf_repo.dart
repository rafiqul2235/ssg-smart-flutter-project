import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/model/response/WppfLedger.dart';

import '../../utill/app_constants.dart';

class WppfRepo {
  final DioClient dioClient;
  WppfRepo({
    required this.dioClient
  });

  Future<List<WppfLedger>> fetchWppfLedger(String empId) async {
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.WPPF_LEDGER,
        data: {
          'emp_id': empId,
        },
      );
      print("Repo response $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData['success'] == 1 && responseData['wppf_ledger'] != null) {
          return (responseData['wppf_ledger'] as List)
              .map((json) => WppfLedger.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to load wppf ledger');
        }
      } else {
        throw Exception('Failed to load wppf ledger');
      }
    } catch (e) {
      throw Exception('Error fetching wppf ledger: $e');
    }
  }

}