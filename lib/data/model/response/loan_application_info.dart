class LoanApplicationInfo {
  final String? applicationType;
  final String? eligibilityAmount;
  final String? appliedAmount;
  final String? noOfInstallment;
  final String? realizationDate;

  LoanApplicationInfo({
    required this.applicationType,
    required this.eligibilityAmount,
    required this.appliedAmount,
    required this.noOfInstallment,
    required this.realizationDate
  });

  factory LoanApplicationInfo.fromJson(Map<String, dynamic> json) {
    return LoanApplicationInfo(
      applicationType: json['APPLICATION_TYPE'] as String?,
      eligibilityAmount: json['ELIGIBILITY_AMOUNT'] as String?,
      appliedAmount: json['APPLIED_AMOUNT'] as String?,
      noOfInstallment: json['NO_INSTALLMENT'] as String?,
      realizationDate: json['LOAN_REALIZATION_DATE'] as String?,
    );
  }

  @override
  String toString() {
    return 'ApplicationInfo{applicationType: $applicationType, eligibilityAmount: $eligibilityAmount, appliedAmount: $appliedAmount, noOfInstallment: $noOfInstallment, realizationDate: $realizationDate}';
  }
}
