class RsmApprovalFlowModel {
  final String salesorderMstId;
  final String salesRepId;
  final String srName;
  final String customerId;
  final String isActive;
  final String itemQty;
  final String shipTositeName;
  final String itemName;
  final String creationDate;
  final String itemUom;
  final String custBalance;
  final String freight;
  final String customerName;
  final String orderTotal;



  RsmApprovalFlowModel({
    required this.salesorderMstId,
    required this.salesRepId,
    required this.srName,
    required this.customerId,
    required this.isActive,
    required this.itemQty,
    required this.shipTositeName,
    required this.itemName,
    required this.creationDate,
    required this.itemUom,
    required this.custBalance,
    required this.freight,
    required this.customerName,
    required this.orderTotal
  });

  factory RsmApprovalFlowModel.fromJson(Map<String, dynamic> json) {
    return RsmApprovalFlowModel(
      salesorderMstId: json['SALEORDER_MST_ID'],
      salesRepId: json['SALEREP_ID'],
      srName: json['SR_NAME'],
      customerId: json['CUSTOMER_ID'],
      isActive: json['IS_ACTIVE'],
      itemQty: json['ITEM_QTY'],
      shipTositeName: json['SHIP_TO_SITE_NAME'],
      itemName: json['ITEM_NAME'],
      creationDate: json['CREATION_DATE'],
      itemUom: json['ITEM_UOM'],
      custBalance: json['CREDIT_AVAILABLE'],
      freight: json['FREIGHT_TERMS'],
      customerName: json['CUSTOMER_NAME'],
      orderTotal: json['ORDER_TOTAL'],
    );
  }

  @override
  String toString() {
    return 'RsmApprovalFlowModel{salesorderMstId: $salesorderMstId, salesRepId: $salesRepId, srName: $srName, customerId: $customerId, isActive: $isActive, itemQty: $itemQty, shipTositeName: $shipTositeName, itemName: $itemName, creationDate: $creationDate, itemUom: $itemUom,$orderTotal:orderTotal}';
  }
}