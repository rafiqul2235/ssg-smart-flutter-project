class CustomerDetails {
  String? salesRepId;
  String? customerId;
  String? orgId;
  String? accountNumber;
  String? partySiteNumber;
  String? billToSiteId;
  String? customarName;
  String? customerType;
  String? salesSection;
  String? customerCategory;
  String? billToAddress;
  String? freightTerm;
  String? freightTermId;
  String? priceListId;
  String? primaryShipToSiteId;
  String? warehouseId;
  String? warehouseName;
  String? orderTypeId;
  String? orderType;

  CustomerDetails({
    this.salesRepId,
    this.customerId,
    this.orgId,
    this.accountNumber,
    this.partySiteNumber,
    this.billToSiteId,
    this.customarName,
    this.customerType,
    this.salesSection,
    this.customerCategory,
    this.billToAddress,
    this.freightTerm,
    this.freightTermId,
    this.priceListId,
    this.primaryShipToSiteId,
    this.warehouseId,
    this.warehouseName,
    this.orderTypeId,
    this.orderType
});

  factory CustomerDetails.fromJson(Map<String, dynamic> json){
    return CustomerDetails(
      salesRepId: json['SALESREP_ID'],
      customerId: json['CUSTOMER_ID'],
      orgId: json['ORG_ID'],
      accountNumber: json['ACCOUNT_NUMBER'],
      partySiteNumber: json['BILL_TO_SITE_ID'],
      customarName: json['CUSTOMER_NAME'],
      customerType: json['CUSTOMER_TYPE'] ,
      salesSection: json['SALES_SECTION'] ,
      customerCategory: json['CUSTOMER_CATEGORY'] ,
      billToAddress: json['BILL_TO_ADDRESS'] ,
      freightTerm: json['FREIGHT_TERMS'] ,
      freightTermId: json['FREIGHT_TERMS_ID'] ,
      priceListId: json['PRICE_LIST_ID'] ,
      primaryShipToSiteId: json['PRIMARY_SHIP_TO_SITE_ID'] ,
      warehouseId: json['WAREHOUSE_ID'],
      warehouseName: json['WAREHOUSE_NAME'],
      orderType: json['ORDER_TYPE'] ,
      orderTypeId: json['ORDER_TYPE_ID']
    );
  }

  @override
  String toString() {
    return 'CustomerDetails{salesRepId: $salesRepId, customerId: $customerId, orgId: $orgId, accountNumber: $accountNumber, partySiteNumber: $partySiteNumber, billToSiteId: $billToSiteId, customarName: $customarName, customerType: $customerType, salesSection: $salesSection, customerCategory: $customerCategory, billToAddress: $billToAddress, freightTerm: $freightTerm, freightTermId: $freightTermId, priceListId: $priceListId, primaryShipToSiteId: $primaryShipToSiteId, warehouseId: $warehouseId, warehouseName: $warehouseName, orderTypeId: $orderTypeId, orderType: $orderType}';
  }
}