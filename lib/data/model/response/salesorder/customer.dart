class Customer {
  String? salesPersonId;
  String? customerId;
  String? orgId;
  String? accountNumber;
  String? partySiteNumber;
  String? billToSiteId;
  String? customerName;
  String? customerType;
  String? salesSection;
  String? customerCategory;
  String? billToAddress;
  String? freightTerms;
  String? freightTermsId;
  String? priceListId;
  String? primaryShipToSiteId;
  String? warehouseId;
  String? warehouseName;
  String? orderTypeId;
  String? orderType;
  String? creditAvailable;

  Customer({
        this.salesPersonId = "",
        this.customerId = "",
        this.orgId = "",
        this.accountNumber =  "",
        this.partySiteNumber =  "",
        this.billToSiteId =  "",
        this.customerName =  "",
        this.customerType =  "",
        this.salesSection =  "",
        this.customerCategory =  "",
        this.billToAddress =  "",
        this.freightTerms =  "",
        this.freightTermsId =  "",
        this.priceListId =  "",
        this.primaryShipToSiteId = "",
        this.warehouseId = "",
        this.warehouseName = "",
        this.orderTypeId = "",
        this.orderType = "",
        this.creditAvailable = "" });

  Customer.fromJson(Map<String, dynamic> json) {
    salesPersonId = json['SALESREP_ID'];
    customerId = json['CUSTOMER_ID'];
    orgId = json['ORG_ID'];
    accountNumber = json['ACCOUNT_NUMBER'];
    partySiteNumber = json['PARTY_SITE_NUMBER'];
    billToSiteId = json['BILL_TO_SITE_ID'];
    customerName = json['CUSTOMER_NAME'];
    customerType = json['CUSTOMER_TYPE'];
    salesSection = json['SALES_SECTION'];
    customerCategory = json['CUSTOMER_CATEGORY'];
    billToAddress = json['BILL_TO_ADDRESS'];
    freightTerms = json['FREIGHT_TERMS'];
    freightTermsId = json['FREIGHT_TERMS_ID'];
    priceListId = json['PRICE_LIST_ID'];
    primaryShipToSiteId = json['PRIMARY_SHIP_TO_SITE_ID'];
    warehouseId = json['WAREHOUSE_ID'];
    warehouseName = json['WAREHOUSE_NAME'];
    orderTypeId = json['ORDER_TYPE_ID'];
    orderType = json['ORDER_TYPE'];
    creditAvailable = json['CREDIT_AVAILABLE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SALESREP_ID'] = salesPersonId;
    data['CUSTOMER_ID'] = customerId;
    data['ORG_ID'] = orgId;
    data['ACCOUNT_NUMBER'] = accountNumber;
    data['PARTY_SITE_NUMBER'] = partySiteNumber;
    data['BILL_TO_SITE_ID'] = billToSiteId;
    data['CUSTOMER_NAME'] = customerName;
    data['CUSTOMER_TYPE'] = customerType;
    data['SALES_SECTION'] = salesSection;
    data['CUSTOMER_CATEGORY'] = customerCategory ;
    data['BILL_TO_ADDRESS'] = billToAddress ;
    data['FREIGHT_TERMS'] = freightTerms ;
    data['FREIGHT_TERMS_ID'] = freightTermsId ;
    data['PRICE_LIST_ID'] = priceListId;
    data['PRIMARY_SHIP_TO_SITE_ID'] = primaryShipToSiteId ;
    data['WAREHOUSE_ID'] = warehouseId ;
    data['WAREHOUSE_NAME'] = warehouseName ;
    data['ORDER_TYPE_ID'] = orderTypeId ;
    data['ORDER_TYPE'] = orderType;
    data['CREDIT_AVAILABLE'] = creditAvailable ;
    return data;
  }

}
