class PendingSO {
  final String srlNum;
  final String ntfResponder;
  final String approverName;
  final String approverAction;
  final String note;
  final String actionDate;

  PendingSO({
    required this.srlNum,
    required this.ntfResponder,
    required this.approverName,
    required this.approverAction,
    required this.note,
    required this.actionDate,
  });

  factory PendingSO.fromJson(Map<String, dynamic> json) {
    return PendingSO(
      srlNum: json['SRL_NUM'],
      ntfResponder: json['NTF_RESPONDER'],
      approverName: json['APPROVER_NAME'],
      approverAction: json['APPROVER_ACTION'],
      note: json['NOTE'],
      actionDate: json['ACTION_DATE'],
    );
  }

  @override
  String toString() {
    return 'PendingSO{srlNum: $srlNum, ntfResponder: $ntfResponder, approverName: $approverName, approverAction: $approverAction, note: $note, actionDate: $actionDate}';
  }
}
