class CustTargetVsAchivModel {
  final String period;
  final String target;
  final String delivered;
  final String acchive;
  final String so_qty;
  final String so_acchive;
  final String note;


  CustTargetVsAchivModel({
    required this.period,
    required this.target,
    required this.delivered,
    required this.acchive,
    required this.so_qty,
    required this.so_acchive,
    required this.note,
  });

  factory CustTargetVsAchivModel.fromJson(Map<String, dynamic> json) {
    return CustTargetVsAchivModel(
      period: json['PERIOD_NAME'],
      target: json['TARGET'],
      delivered: json['DELIVERED'],
      acchive: json['ACIEVEMENT'],
      so_qty: json['ORDER_QNTY'],
      so_acchive: json['SO_ACIEVEMENT'],
      note: json['NOTE'],

    );
  }
}
