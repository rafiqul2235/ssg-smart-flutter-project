class AttendanceSummaryModel {
  final String sValue;
  final String sDetails;


  AttendanceSummaryModel({
    required this.sValue,
    required this.sDetails,

  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      sValue: json['STATUS_VALUES'],
      sDetails: json['DAY_DETAILS'],

    );
  }
}
