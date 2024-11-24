class SalesDataModel{
  String? custId;
  String? selesrepId;
  String? orgId;
  String? billToSiteId;
  String? billToAddress;
  String? orderTypeId;
  String? orderType;
  String? freightTerm;
  String? freightTermId;
  String? wareHouseId;
  String? orderDate;
  String? priceListId;
  String? primaryShipToSiteId;

  /*String orgName;
  String? custAccountNumber;
  String? partySiteId;
  String? customerName;
  String? wareHouseName;
  String? customerPoNumber;*/


  /*Line Table
  Field Name	Field type	Uses API
  SALESREP_ID	String	orders
  CUSTOMER_ID	String	orders
  ORG_ID	String	orders
  PRIMARY_SHIP_TO	String	orders
  SHIP_TO_SITE_ID	String	orders
  CUSTOMER_NAME	String	orders
  SHIP_TO_LOCATION	String	orders
  ITEM_NAME	String	sales order Model
  ITEM_ID	String	sales order Model
  ITEM_UOM	String	sales order Model
  QUANTITY	String	sales order Model
  REMARKS	String	sales order Model
  VEHICLE_TYPE	String	sales order Model
  VEHICLE_TYPE_ID	String	sales order Model*/

  SalesDataModel({
    required this.custId,
    required this.selesrepId,
    required this.orgId,
    required this.billToSiteId,
    required this.billToAddress,
    required this.priceListId,
    required this.primaryShipToSiteId,
    required this.orderType,
    required this.orderTypeId,
    required this.freightTerm,
    required this.freightTermId,
    required this.orderDate,
    required this.wareHouseId,
    /*required this.customerName,
    required this.orgName,
    required this.custAccountNumber,
    required this.partySiteId,
    required this.wareHouseName,
    required this.customerPoNumber*/
});

  Map<String, dynamic> toJson(){
    return{
      'CUSTOMER_ID': custId,
      'SALESREP_ID': selesrepId,
      'ORG_ID': orgId,
      'BILL_TO_SITE_ID': billToSiteId,
      'BILL_TO_ADDRESS': billToAddress,
      'PRICE_LIST_ID': priceListId,
      'PRIMARY_SHIP_TO_SITE_ID': primaryShipToSiteId,
      'ORDER_TYPE': orderType,
      'ORDER_TYPE_ID': orderTypeId,
      'FREIGHT_TERMS': freightTerm,
      'FREIGHT_TERMS_ID': freightTermId,
      'ORDER_DATE': orderDate,
      'leave_duration': wareHouseId,
      /*'ORG_NAME': orgName,
      'ACCOUNT_NUMBER': custAccountNumber,
      'CUSTOMER_NAME': customerName,
      'PARTY_SITE_NUMBER': partySiteId,
      'WAREHOUSE_ID': wareHouseName,
      'WAREHOUSE_NAME': customerPoNumber,
      'CUSTOMER_PO_NUMBER': customerPoNumber*/
    };
  }

  @override
  String toString() {
    return 'SalesDataModel{custId: $custId, selesrepId: $selesrepId, orgId: $orgId, billToSiteId: $billToSiteId, billToAddress: $billToAddress, orderTypeId: $orderTypeId, orderType: $orderType, freightTerm: $freightTerm, freightTermId: $freightTermId, wareHouseId: $wareHouseId, orderDate: $orderDate, priceListId: $priceListId, primaryShipToSiteId: $primaryShipToSiteId}';
  }
}