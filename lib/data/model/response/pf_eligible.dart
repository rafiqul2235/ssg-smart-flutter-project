class PfEligibleInfo {
  final String pfBalance;
  final String eligibilityPercent;
  final String eligibilityAmount;
  final String eligibilityStatus;

  PfEligibleInfo({
    required this.pfBalance,
    required this.eligibilityPercent,
    required this.eligibilityAmount,
    required this.eligibilityStatus
  });

  factory PfEligibleInfo.fromJson(Map<String, dynamic> json) {
    return PfEligibleInfo(
        pfBalance: json['PF_BALANCE'],
        eligibilityPercent: json['ELIGIBILITY_PERCENT'],
        eligibilityAmount: json['ELIGIBILITY_AMOUNT'],
        eligibilityStatus: json['ELIGIBILITY_STATUS']
    );
  }
}