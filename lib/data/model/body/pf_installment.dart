class PfInstallment {
  final String code;
  final String description;

  PfInstallment({required this.code, required this.description});

  factory PfInstallment.fromJson(Map<String, dynamic> json) {
    return PfInstallment(
      code: json['CODE'],
      description: json['DESCRIPTION'],
    );
  }

  @override
  String toString() {
    return 'PfInstallment{code: $code, description: $description}';
  }
}