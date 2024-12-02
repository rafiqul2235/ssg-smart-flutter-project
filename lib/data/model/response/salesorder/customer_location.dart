class CustomerShipLocation {
  String? salesPersonId;
  String? customerId;
  String? orgId;
  String? shipToSiteId;
  String? partySiteNumber;
  String? primaryShipTo;
  String? customerName;
  String? shipToLocation;

  CustomerShipLocation(
      { this.salesPersonId = "",
        this.customerId = "",
        this.orgId = "",
        this.shipToSiteId = "",
        this.partySiteNumber = "",
        this.primaryShipTo = "",
        this.customerName = "",
        this.shipToLocation = ""});

  CustomerShipLocation.fromJson(Map<String, dynamic> json) {
    salesPersonId = json['SALESREP_ID'];
    customerId = json['CUSTOMER_ID'];
    orgId = json['ORG_ID'];
    shipToSiteId = json['SHIP_TO_SITE_ID'];
    partySiteNumber = json['PARTY_SITE_NUMBER'];
    primaryShipTo = json['PRIMARY_SHIP_TO'];
    customerName = json['CUSTOMER_NAME'];
    shipToLocation = json['SHIP_TO_LOCATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SALESREP_ID'] = salesPersonId;
    data['CUSTOMER_ID'] = customerId;
    data['ORG_ID'] = orgId;
    data['SHIP_TO_SITE_ID'] = shipToSiteId;
    data['PARTY_SITE_NUMBER'] = partySiteNumber;
    data['PRIMARY_SHIP_TO'] = primaryShipTo;
    data['CUSTOMER_NAME'] = customerName;
    data['SHIP_TO_LOCATION'] = shipToLocation;
    return data;
  }
}
