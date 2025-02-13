import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/body/financial_year.dart';

class AitEssentialResponse {
  final int success;
  final List<dynamic> msg;
  final List<CustomerDetails> customerDetails;
  final List<FinancialYear> financialYears;
  final Map<String, dynamic> post;
  final List<dynamic> get;

  AitEssentialResponse({
    required this.success,
    required this.msg,
    required this.customerDetails,
    required this.financialYears,
    required this.post,
    required this.get
  });

  factory AitEssentialResponse.fromJson(Map<String, dynamic> json) {
    return AitEssentialResponse(
        success: json['success'] ?? 0,
        msg: json['msg'] ?? [],
        customerDetails: (json['customer_details'] as List?)
            ?.map((e) => CustomerDetails.fromJson(e))
              .toList() ?? [],
        financialYears: (json['financial_year'] as List?)
            ?.map((e) => FinancialYear.fromJson(e))
              .toList() ?? [],
        post: json['post'] ?? {},
        get: json['get'] ?? []
    );
  }
}