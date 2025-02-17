class PendingSO {
  final String? srlNum;
  final String? ntfResponder;
  final String? approverName;
  final String? approverAction;
  final String? note;
  final String? actionDate;

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
      srlNum: json['SRL_NUM'] as String?,
      ntfResponder: json['NTF_RESPONDER'] as String?,
      approverName: json['APPROVER_NAME'] as String?,
      approverAction: json['APPROVER_ACTION'] as String?,
      note: json['NOTE'] as String?,
      actionDate: json['ACTION_DATE'] as String?,
    );
  }

  @override
  String toString() {
    return 'PendingSO{srlNum: $srlNum, ntfResponder: $ntfResponder, approverName: $approverName, approverAction: $approverAction, note: $note, actionDate: $actionDate}';
  }
}