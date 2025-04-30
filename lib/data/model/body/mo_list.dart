class MoveOrderItem{
  final String headerId;
  final String moveOrderNumber;
  final String orgId;
  final String orgName;
  final String? description;
  final String dateRequired;
  final String headerStatus;
  final String headerStatusName;
  final String statusDate;
  final String createdBy;
  final String creationDate;
  final DateTime lastUpdateDate;

  MoveOrderItem({
    required this.headerId,
    required this.moveOrderNumber,
    required this.orgId,
    required this.orgName,
    required this.description,
    required this.dateRequired,
    required this.headerStatus,
    required this.headerStatusName,
    required this.statusDate,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdateDate
});

  factory MoveOrderItem.fromJson(Map<String, dynamic> json) {
    return MoveOrderItem(
        headerId: json['HEADER_ID'],
        moveOrderNumber: json['REQUEST_NUMBER'],
        orgId: json['ORGANIZATION_ID'],
        orgName: json['ORGANIZATION_NAME'],
        description: json['DESCRIPTION']?? '',
        dateRequired: json['DATE_REQUIRED'],
        headerStatus: json['HEADER_STATUS'],
        headerStatusName: json['HEADER_STATUS_NAME'],
        statusDate: json['STATUS_DATE'],
        createdBy: json['CREATED_BY'],
        creationDate: json['CREATION_DATE'],
        lastUpdateDate: DateTime.parse(json['LAST_UPDATE_DATE'])
    );
  }
}