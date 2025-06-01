import 'dart:convert';

class MoveOrderDetails {
  final String sl;
  final String organizationId;
  final String inventoryItemId;
  final String? status;
  final String moveOrderNumber;
  final String? itemCode;
  final String? description;
  final String? lineNumber;
  final String? transactionType;
  final String? dateRequired;
  final String? uom;
  final String? quantityRequired;
  final String? quantityDelivered;
  final String? lotNumber;
  final String? transactionTypeId;
  final String? oldReturn;
  final String? userId;
  final String? createBy;
  final String? itemLocator;
  final String? txnSourceId;
  final String? subinventoryCode;
  final String? toSubinventoryCode;
  final String? transactionDate;
  final String? transactionQuantity;
  final String? mtActualCost;
  final String? reasonId;
  final String? preparedBy;
  final String? totalValue;
  final String? transactionId;
  final String? headerStatusName;
  final String? useOfAreaSection;
  final String? useOfArea;
  final String? sectionRtd;
  final String? lastIssueInfo;

  MoveOrderDetails({
    required this.sl,
    required this.organizationId,
    required this.status,
    required this.inventoryItemId,
    required this.moveOrderNumber,
    required this.itemCode,
    required this.description,
    required this.lineNumber,
    required this.transactionType,
    required this.dateRequired,
    required this.uom,
    required this.quantityRequired,
    required this.quantityDelivered,
    required this.lotNumber,
    required this.transactionTypeId,
    required this.oldReturn,
    required this.userId,
    required this.createBy,
    required this.itemLocator,
    required this.txnSourceId,
    required this.subinventoryCode,
    required this.toSubinventoryCode,
    required this.transactionDate,
    required this.transactionQuantity,
    required this.mtActualCost,
    required this.reasonId,
    required this.preparedBy,
    required this.totalValue,
    required this.transactionId,
    required this.headerStatusName,
    required this.useOfAreaSection,
    required this.useOfArea,
    required this.sectionRtd,
    required this.lastIssueInfo,
  });

  factory MoveOrderDetails.fromJson(Map<String, dynamic> json) {
    return MoveOrderDetails(
      sl: json["SL"] ?? '',
      organizationId: json["ORGANIZATION_ID"] ?? '',
      status: json["STATUS"] ?? '',
      inventoryItemId: json["INVENTORY_ITEM_ID"] ?? '',
      moveOrderNumber: json["MOVE_ORDER_NUMBER"] ?? '',
      itemCode: json["ITEM_CODE"] ?? '',
      description: json["DESCRIPTION"] ?? '',
      lineNumber: json["LINE_NUMBER"] ?? '',
      transactionType: json["TRANSACTION_TYPE"] ?? '',
      dateRequired: json["DATE_REQUIRED"] ?? '',
      uom: json["UOM"] ?? '',
      quantityRequired: json["QUANTITY_REQUIRED"] ?? '',
      quantityDelivered: json["QUANTITY_DELIVERED"] ?? '',
      lotNumber: json["LOT_NUMBER"],
      transactionTypeId: json["TRANSACTION_TYPE_ID"] ?? '',
      oldReturn: json["OLD_RETURN"],
      userId: json["USER_ID"] ?? '',
      createBy: json["CREATE_BY"] ?? '',
      itemLocator: json["ITEM_LOCATOR"] ?? '',
      txnSourceId: json["TXN_SOURCE_ID"],
      subinventoryCode: json["SUBINVENTORY_CODE"] ?? '',
      toSubinventoryCode: json["TO_SUBINVENTORY_CODE"],
      transactionDate: json["TRANSACTION_DATE"] ?? '',
      transactionQuantity: json["TRANSACTION_QUANTITY"] ?? '',
      mtActualCost: json["MT_ACTUAL_COST"] != null
          ? double.parse(json["MT_ACTUAL_COST"].toString()).toStringAsFixed(2)
          : '0.00',
      reasonId: json["REASON_ID"],
      preparedBy: json["PREPARED_BY"] ?? '',
      totalValue: json["TOTAL_VALUE"] != null
          ? double.parse(json["TOTAL_VALUE"].toString()).toStringAsFixed(2)
          : '0.00',
      transactionId: json["TRANSACTION_ID"] ?? '',
      headerStatusName: json["HEADER_STATUS_NAME"] ?? '',
      useOfAreaSection: json["USE_OF_AREA_SECTION"] ?? '',
      useOfArea: json["USE_OF_AREA"] ?? '',
      sectionRtd: json["SECTION_RTD"],
      lastIssueInfo: json["LAST_ISSUE_INFO"] ?? '',
    );
  }

  @override
  String toString() {
    return 'MoveOrderDetails{sl: $sl, organizationId: $organizationId, inventoryItemId: $inventoryItemId, moveOrderNumber: $moveOrderNumber, itemCode: $itemCode, description: $description, lineNumber: $lineNumber, transactionType: $transactionType, dateRequired: $dateRequired, uom: $uom, quantityRequired: $quantityRequired, quantityDelivered: $quantityDelivered, lotNumber: $lotNumber, transactionTypeId: $transactionTypeId, oldReturn: $oldReturn, userId: $userId, createBy: $createBy, itemLocator: $itemLocator, txnSourceId: $txnSourceId, subinventoryCode: $subinventoryCode, toSubinventoryCode: $toSubinventoryCode, transactionDate: $transactionDate, transactionQuantity: $transactionQuantity, mtActualCost: $mtActualCost, reasonId: $reasonId, preparedBy: $preparedBy, totalValue: $totalValue, transactionId: $transactionId, headerStatusName: $headerStatusName, useOfAreaSection: $useOfAreaSection, useOfArea: $useOfArea, sectionRtd: $sectionRtd, lastIssueInfo: $lastIssueInfo}';
  }
}
