class MsdReportModel {
  final String msg;
  final String msg_date;


  MsdReportModel({
    required this.msg,
    required this.msg_date,
  });

  factory MsdReportModel.fromJson(Map<String, dynamic> json) {
    return MsdReportModel(
      msg: json['MSG'],
      msg_date: json['MSG_DATE'],
    );
  }
}
