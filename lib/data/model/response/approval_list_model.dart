class ApprovalListModel {

  String? notificationId;
  String? headerId;
  String? fromRole;
  String? fromUser;
  String? subject;
  String? wf_item_key;
  String? to_user;

  ApprovalListModel({this.notificationId = '', this.headerId = '', this.fromRole = '',
      this.fromUser = '', this.subject = '',this.wf_item_key = '',this.to_user = ''});

  ApprovalListModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['NOTIFICATION_ID'];
    headerId = json['REPORT_HEADER_ID'];
    fromRole = json['FROM_ROLE'];
    fromUser = json['FROM_USER'];
    subject = json['SUBJECT'];
    wf_item_key = json['WF_ITEM_KEY'];
    to_user = json['TO_USER'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['NOTIFICATION_ID'] = notificationId;
    json['REPORT_HEADER_ID'] = headerId;
    json['FROM_ROLE'] = fromRole;
    json['FROM_USER'] = fromUser;
    json['SUBJECT'] = subject;
    json['WF_ITEM_KEY'] = wf_item_key;
    json['TO_USER'] = to_user;
    return json;
  }

  @override
  String toString() {
    return 'SelfServiceModel{notificationId: $notificationId, headerId: $headerId, fromRole: $fromRole, fromUser: $fromUser, subject: $subject, wf_item_key: $wf_item_key, to_user: $to_user}';
  }
}