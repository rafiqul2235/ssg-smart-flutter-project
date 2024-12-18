class FinancialYear{
  final String enableFlagId;
  final String description;

  FinancialYear({
    required this.enableFlagId,
    required this.description
  });

  factory FinancialYear.fromJson(Map<String, dynamic> json) {
    return FinancialYear(
        enableFlagId: json['ENABLED_FLAG'],
        description: json['DESCRIPTION']
    );
  }

}