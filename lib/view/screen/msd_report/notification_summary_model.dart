class NotificationSummaryModel {
  final String summary;


  NotificationSummaryModel({
    required this.summary,
  });

  factory NotificationSummaryModel.fromJson(Map<String, dynamic> json) {
    return NotificationSummaryModel(
      summary: json['SUMMARY'],
    );
  }

  @override
  String toString() {
    return 'NotificationSummaryModel{summary: $summary}';
  }
}
