class SalesOrder {

  String? customerId;
  String? salesPersonId;
  String? orgId;
  String? orgName;
  String? accountNumber;
  String? partySiteNumber;
  String? billToSiteId;
  String? customerName;
  String? billToAddress;
  String? priceListId;
  String? primaryShipToSiteId;
  String? orderType;
  String? orderTypeId;
  String? freightTerms;
  String? freightTermsId;
  String? orderDate;
  String? warehouseId;
  String? warehouseName;
  String? customerPoNumber;

  List<ItemDetail>? orderItemDetail = [];

  SalesOrder({
    this.customerId = '',
    this.salesPersonId= '',
    this.orgId= '',
    this.orgName= '',
    this.accountNumber= '',
    this.partySiteNumber= '',
    this.billToSiteId= '',
    this.customerName= '',
    this.billToAddress= '',
    this.priceListId= '',
    this.primaryShipToSiteId= '',
    this.orderType= '',
    this.orderTypeId= '',
    this.freightTerms= '',
    this.freightTermsId= '',
    this.orderDate= '',
    this.warehouseId= '',
    this.warehouseName= '',
    this.customerPoNumber= ''
  });

  void addItem(ItemDetail item){
    /*if(orderItemDetail == null){
      orderItemDetail = [];
    }*/
    orderItemDetail ??= [];
    orderItemDetail?.add(item);

  }

  SalesOrder.fromJson(Map<String, dynamic> json) {
    customerId= json['CUSTOMER_ID'];
    salesPersonId= json['SALESREP_ID'];
    orgId= json['ORG_ID'];
    orgName= json['ORG_NAME'];
    accountNumber= json['ACCOUNT_NUMBER'];
    partySiteNumber= json['PARTY_SITE_NUMBER'];
    billToSiteId= json['BILL_TO_SITE_ID'];
    customerName= json['CUSTOMER_NAME'];
    billToAddress= json['BILL_TO_ADDRESS'];
    priceListId= json['PRICE_LIST_ID'];
    primaryShipToSiteId= json['PRIMARY_SHIP_TO_SITE_ID'];
    orderType= json['ORDER_TYPE'];
    orderTypeId= json['ORDER_TYPE_ID'];
    freightTerms= json['FREIGHT_TERMS'];
    freightTermsId= json['FREIGHT_TERMS_ID'];
    orderDate= json['ORDER_DATE'];
    warehouseId= json['WAREHOUSE_ID'];
    warehouseName= json['WAREHOUSE_NAME'];
    customerPoNumber= json['CUSTOMER_PO_NUMBER'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CUSTOMER_ID'] = customerId;
    data['SALESREP_ID'] = salesPersonId;
    data['ORG_ID'] = orgId;
    data['ORG_NAME'] = orgName;
    data['ACCOUNT_NUMBER'] = accountNumber;
    data['PARTY_SITE_NUMBER'] = partySiteNumber;
    data['BILL_TO_SITE_ID'] = billToSiteId;
    data['CUSTOMER_NAME'] = customerName;
    data['BILL_TO_ADDRESS'] = billToAddress;
    data['PRICE_LIST_ID'] = priceListId;
    data['PRIMARY_SHIP_TO_SITE_ID'] = primaryShipToSiteId;
    data['ORDER_TYPE'] = orderType;
    data['ORDER_TYPE_ID'] = orderTypeId;
    data['FREIGHT_TERMS'] = freightTerms;
    data['FREIGHT_TERMS_ID'] = freightTermsId;
    data['ORDER_DATE'] = orderDate;
    data['WAREHOUSE_ID'] = warehouseId;
    data['WAREHOUSE_NAME'] = warehouseName;
    data['CUSTOMER_PO_NUMBER'] = customerPoNumber;
/*
    if (this.orderItemDetail != null) {
      data['unique_shops'] = this._uniqueShops?.map((v) => v.toJson()).toList();
    }*/

    return data;
  }
}

class ItemDetail {

  String? salesPersonId;
  String? customerId;
  String? orgId;
  String? primaryShipTo;
  String? shipToSiteId;
  String? customerName;
  String? shipToLocation;
  int? itemId;
  String? itemName;
  String? itemUOM;
  String? quantity;
  String? remarks;
  String? vehicleTypeId;
  String? vehicleType;

  bool isEditable = false;
  int unitPrice = 0;
  double totalPrice = 0.0;

  ItemDetail({
    this.salesPersonId = '',
    this.customerId= '',
    this.orgId= '',
    this.primaryShipTo= '',
    this.shipToSiteId= '',
    this.customerName= '',
    this.shipToLocation= '',
    this.itemId= 0,
    this.itemName= '',
    this.itemUOM= '',
    this.quantity= '',
    this.remarks= '',
    this.vehicleTypeId = '',
    this.vehicleType = ''
  });

  ItemDetail.fromJson(Map<String, dynamic> json) {
    salesPersonId = json['SALESREP_ID']??'';
    customerId = json['CUSTOMER_ID']??'';
    orgId = json['ORG_ID']??'';
    primaryShipTo = json['PRIMARY_SHIP_TO']??'';
    shipToSiteId = json['SHIP_TO_SITE_ID']??'';
    customerName = json['CUSTOMER_NAME']??'';
    shipToLocation = json['SHIP_TO_LOCATION']??'';
    itemId = json['ITEM_ID']??0;
    itemName = json['ITEM_NAME']??'';
    itemUOM = json['ITEM_UOM']??'';
    quantity = json['QUANTITY']??'';
    remarks = json['REMARKS']??'';
    vehicleTypeId = json['VEHICLE_TYPE_ID']??'';
    vehicleType = json['VEHICLE_TYPE']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SALESREP_ID'] = salesPersonId;
    data['CUSTOMER_ID'] = customerId;
    data['ORG_ID'] = orgId;
    data['PRIMARY_SHIP_TO'] = primaryShipTo;
    data['SHIP_TO_SITE_ID'] = shipToSiteId;
    data['CUSTOMER_NAME'] = customerName;
    data['SHIP_TO_LOCATION'] = shipToLocation;
    data['ITEM_ID'] = itemId??0;
    data['ITEM_NAME'] = itemName;
    data['ITEM_UOM'] = itemUOM;
    data['QUANTITY'] = quantity;
    data['REMARKS'] = remarks;
    data['VEHICLE_TYPE_ID'] = vehicleTypeId;
    data['VEHICLE_TYPE'] = vehicleType;
    return data;
  }

}
