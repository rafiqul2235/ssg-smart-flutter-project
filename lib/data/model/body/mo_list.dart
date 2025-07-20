class MoveOrderItem {
  final String headerId;
  final String moveOrderNumber;
  final String orgId;
  final String? orgName;
  final String? description;
  final String dateRequired;
   String? status;
  final String headerStatus;
  final String headerStatusName;
  final String statusDate;
  final String? createdBy;
  final String? creationDate;
  final DateTime? lastUpdateDate;
  final String? notificationId;
  final String? fullName;
  final String? fromRole;
  final String? toUser;

  MoveOrderItem({
    required this.headerId,
    required this.moveOrderNumber,
    required this.orgId,
    this.orgName,
    this.description,
    required this.dateRequired,
    this.status,
    required this.headerStatus,
    required this.headerStatusName,
    required this.statusDate,
    this.createdBy,
    this.creationDate,
    required this.lastUpdateDate,
    this.notificationId,
    required this.fullName,
    this.fromRole,
    this.toUser,
  });

  factory MoveOrderItem.fromJson(Map<String, dynamic> json) {
    return MoveOrderItem(
      headerId: json['HEADER_ID'],
      moveOrderNumber: json['REQUEST_NUMBER'],
      orgId: json['ORGANIZATION_ID'],
      orgName: json['ORGANIZATION_NAME'],
      description: json['DESCRIPTION'] ?? '',
      dateRequired: json['DATE_REQUIRED'] ?? '',
      status: json['STATUS'] ?? '',
      headerStatus: json['HEADER_STATUS'],
      headerStatusName: json['HEADER_STATUS_NAME'],
      statusDate: json['STATUS_DATE'],
      createdBy: json['CREATED_BY'],
      creationDate: json['CREATION_DATE'],
      lastUpdateDate: DateTime.tryParse(json['LAST_UPDATE_DATE']),
      notificationId: json['NOTIFICATION_ID'],
      fullName: json['FULL_NAME'] ?? '',
      fromRole: json['FROM_ROLE'],
      toUser: json['TO_USER'],
    );
  }

  @override
  String toString() {
    return 'MoveOrderItem{headerId: $headerId, moveOrderNumber: $moveOrderNumber, orgId: $orgId, orgName: $orgName, description: $description, dateRequired: $dateRequired, status: $status, headerStatus: $headerStatus, headerStatusName: $headerStatusName, statusDate: $statusDate, createdBy: $createdBy, creationDate: $creationDate, lastUpdateDate: $lastUpdateDate, notificationId: $notificationId, fromRole: $fromRole, toUser: $toUser}';
  }
}
