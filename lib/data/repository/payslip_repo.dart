import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';

import '../../utill/app_constants.dart';
import '../model/response/payslip_model.dart';

class PaySlipRepo {
  final DioClient dioClient;

  PaySlipRepo({
    required this.dioClient
});

  Future<EmployeePaySlip> fetchEmployeePaySlip(String empId) async{
    try {
      final response = await dioClient.postWithFormData(
        AppConstants.PAY_SLIP,
        data: {
          'emp_id': empId
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print("Payslip from repo: $responseData");
        return EmployeePaySlip.fromJson(responseData['emp_pay_slip'][0]);
      } else {
        throw Exception('Failed to load payslip');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
