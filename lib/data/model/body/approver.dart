class ApproverDetail {
  final String serialNo;
  final String responder;
  final String responderName;
  final String action;
  final String note;
  final String actionDate;

  ApproverDetail({
    required this.serialNo,
    required this.responder,
    required this.responderName,
    required this.action,
    required this.note,
    required this.actionDate,
  });

  factory ApproverDetail.fromJson(Map<String, dynamic> json) {
    return ApproverDetail(
      serialNo: json['serialNo']?.toString() ?? '',
      responder: json['responder']?.toString() ?? '',
      responderName: json['responderName']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      actionDate: json['actionDate']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'ApproverDetail{serialNo: $serialNo, responder: $responder, responderName: $responderName, action: $action, note: $note, actionDate: $actionDate}';
  }
}