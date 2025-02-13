class FinancialYear{
  String? enableFlagId;
  String? description;

  FinancialYear({
     this.enableFlagId,
     this.description
  });

  factory FinancialYear.fromJson(Map<String, dynamic> json) {
    return FinancialYear(
        enableFlagId: json['ENABLED_FLAG'],
        description: json['DESCRIPTION']
    );
  }

  @override
  String toString() {
    return 'FinancialYear{enableFlagId: $enableFlagId, description: $description}';
  }
}