class SalaryEligibleInfo {
  final String eligibilityAmount;
  final String eligibilityStatusInfo;
  final String eligibilityStatus;

  SalaryEligibleInfo({
    required this.eligibilityAmount,
    required this.eligibilityStatusInfo,
    required this.eligibilityStatus
});
  factory SalaryEligibleInfo.fromJson(Map<String, dynamic> json) {
    return SalaryEligibleInfo(
        eligibilityAmount: json['ELIGIBILITY_AMOUNT'],
        eligibilityStatusInfo: json['ELIGIBILITY_STATUS_INFO'],
        eligibilityStatus: json['ELIGIBILITY_STATUS']
    );
  }
}