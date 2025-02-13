
class PendingSO {
  String? creationDate;
  String? customerId;
  String? mainPartyName;
  String? orderNumber;
  String? pendingQty;
  String? uom;
  String? freight;
  String? itemName;
  String? ghatName;
  String? ghatId;
  String? itemCode;

  PendingSO({
    this.creationDate = "",
    this.customerId = "",
    this.mainPartyName = "",
    this.orderNumber =  "",
    this.pendingQty =  "",
    this.uom =  "",
    this.freight =  "",
    this.itemName =  "",
    this.ghatName =  "",
    this.ghatId =  "",
    this.itemCode =  ""
  });

  PendingSO.fromJson(Map<String, dynamic> json) {
    creationDate = json['CREATION_DATE'];
    customerId = json['CUSTOMER_ID'];
    mainPartyName = json['MAIN_PARTY_NAME'];
    orderNumber = json['ORDER_NUMBER'];
    pendingQty = json['PENDING_QTY'];
    uom = json['UOM'];
    freight = json['FREIGHT'];
    itemName = json['ITEM_DESCRIPTION'];
    ghatName = json['GHAT_NAME'];
    ghatId = json['GHAT_ID'];
    itemCode = json['ITEM_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CREATION_DATE'] = creationDate;
    data['CUSTOMER_ID'] = customerId;
    data['MAIN_PARTY_NAME'] = mainPartyName;
    data['ORDER_NUMBER'] = orderNumber;
    data['PENDING_QTY'] = pendingQty;
    data['UOM'] = uom;
    data['FREIGHT'] = freight;
    data['ITEM_DESCRIPTION'] = itemName;
    data['GHAT_NAME'] = ghatName;
    data['GHAT_ID'] = ghatId ;
    data['ITEM_CODE'] = itemCode ;
    return data;
  }

  @override
  String toString() {
    return 'PendingSO{creationDate: $creationDate, customerId: $customerId, mainPartyName: $mainPartyName, orderNumber: $orderNumber, pendingQty: $pendingQty, uom: $uom, freight: $freight, itemName: $itemName, ghatName: $ghatName, ghatId: $ghatId, itemCode: $itemCode}';
  }
}
