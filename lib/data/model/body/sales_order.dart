class SalesOrder {

  String? customerId;
  String? salesPersonId;
  String? orgId;
  String? userId;
  String? orgName;
  String? createdBy;
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
  String? vehicleInfo;
  String? orderTotal;

  List<ItemDetail>? orderItemDetail = [];
  //List<DlvRequestItemDetail>? dlvItemDetail = [];

  SalesOrder({
    this.customerId = '',
    this.salesPersonId= '',
    this.orgId= '',
    this.userId='',
    this.orgName= '',
    this.createdBy='',
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
    this.customerPoNumber= '',
    this.vehicleInfo = '',
    this.orderTotal=''
  });

  void addItem(ItemDetail item){
    /*if(orderItemDetail == null){
      orderItemDetail = [];
    }*/
    orderItemDetail ??= [];
    orderItemDetail?.add(item);

  }

  /*void dlvAddItem(DlvRequestItemDetail dlvIitem){
    *//*if(orderItemDetail == null){
      orderItemDetail = [];
    }*//*
    dlvItemDetail ??= [];
    dlvItemDetail?.add(dlvIitem);

  }*/

  SalesOrder.fromJson(Map<String, dynamic> json) {
    customerId= json['CUSTOMER_ID'];
    salesPersonId= json['SALESREP_ID'];
    orgId= json['ORG_ID'];
    userId= json['USER_ID'];
    orgName= json['ORG_NAME'];
    createdBy= json['CREATED_BY'];
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
    vehicleInfo= json['VEHICLE_INFO'];
    orderTotal= json['ATTRIBUTE8'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    /*data['SALESREP_ID'] = salesPersonId;
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
    data['CUSTOMER_PO_NUMBER'] = customerPoNumber;*/

    data['CUSTOMER_ID'] = customerId??'0';
    data['ORG_ID'] = orgId??'0';
    data['USER_ID'] = userId??'0';
    data['BILL_TO_SITE_ID'] = billToSiteId??'0';
    data['BILL_TO_ADDRESS'] = billToAddress??'';
    data['ORDER_TYPE_ID'] = orderTypeId??'0';
    data['ORDER_TYPE'] = orderType??'';
    data['CREATED_BY'] = createdBy??'';
    data['FREIGHT_TERMS_ID'] = freightTermsId??'';
    data['FREIGHT_TERMS'] = freightTerms??'';
    data['WAREHOUSE_ID'] = warehouseId??'0';
    data['CUSTOMER_PO_NUMBER'] = customerPoNumber??'';
    data['VEHICLE_INFO'] = vehicleInfo??'';
    data['ATTRIBUTE8'] = orderTotal??'';
    data['SALESREP_ID'] = salesPersonId??'0';
    data['PRICE_LIST_ID'] = priceListId??'0';
    data['PRIMARY_SHIP_TO_SITE_ID'] = primaryShipToSiteId??'';

    if (this.orderItemDetail != null) {
      data['sales'] = this.orderItemDetail?.map((item) => item.toJson()).toList();
    }

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
  int? quantity = 0;
  String? remarks;
  String? vehicleTypeId;
  String? vehicleType;
  String? vehicleCate;
  String? vehicleCateId;
  String? soNumber;
  String? additionalSo;

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
    this.quantity= 0,
    this.remarks= '',
    this.vehicleTypeId = '',
    this.vehicleType = '',
    this.soNumber='',
    this.additionalSo
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
    soNumber = json['SO_NUMBER']??'';
    additionalSo = json['ADDITIOAL_SO']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    /*data['SALESREP_ID'] = salesPersonId;
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
    data['VEHICLE_TYPE'] = vehicleType;*/

    data['ITEM_ID'] = itemId??0;
    data['ITEM_NAME'] = itemName??'';
    data['ITEM_UOM'] = itemUOM??"";
    data['QUANTITY'] = quantity??'0';
    data['SHIP_TO_SITE_ID'] = shipToSiteId??'';
    data['SHIP_TO_LOCATION'] = shipToLocation??'';
    data['VEHICLE_TYPE'] = vehicleType??'';
    data['VEHICLE_CAT'] = vehicleCate??'';
    data['REMARKS'] = remarks??'';
    data['SO_NUMBER'] = soNumber??'';
    data['ADDITIOAL_SO'] = additionalSo??'';

    return data;
  }

}


/*class DlvRequestItemDetail {

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
  String? vehicleCate;
  String? vehicleCateId;

  bool isEditable = false;
  int unitPrice = 0;
  double totalPrice = 0.0;

  DlvRequestItemDetail({
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

  DlvRequestItemDetail.fromJson(Map<String, dynamic> json) {
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
    *//*data['SALESREP_ID'] = salesPersonId;
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
    data['VEHICLE_TYPE'] = vehicleType;*//*

    data['ITEM_ID'] = itemId??0;
    data['ITEM_NAME'] = itemName??'';
    data['ITEM_UOM'] = itemUOM??"";
    data['QUANTITY'] = quantity??'0';
    data['SHIP_TO_SITE_ID'] = shipToSiteId??'';
    data['SHIP_TO_LOCATION'] = shipToLocation??'';
    data['VEHICLE_TYPE'] = vehicleType??'';
    data['VEHICLE_CAT'] = vehicleCate??'';
    data['REMARKS'] = remarks??'';

    return data;
  }

}*/
