class Collection {

  String? customerId;
  String? salesPersonId;
  String? orgId;
  String? userId;
  String? bankAccountId;
  String? bankAccountName;
  String? receiptMethodId;
  String? receiptMethod;
  String? remitBankAcctUseId;
  String? collMode;
  String? instrument;
  String? remarks;
  String? depositNo;
  String? collAmount;
  String? billToSiteId;
  String? billToSiteAddress;
  String? custAmount;

  Collection({ this.customerId = '',
      this.salesPersonId = '',
      this.orgId = '',
      this.userId = '',
      this.bankAccountId = '',
      this.bankAccountName = '',
      this.receiptMethodId = '',
      this.receiptMethod = '',
      this.remitBankAcctUseId = '',
      this.collMode = '',
      this.instrument = '',
      this.remarks = '',
      this.depositNo = '',
      this.collAmount = '',
      this.billToSiteId = '',
      this.billToSiteAddress = '',
      this.custAmount = ''});


  Collection.fromJson(Map<String, dynamic> json) {

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['org_id'] = orgId;
    data['user_id'] = userId;
    data['salesrep_id'] = salesPersonId;
    data['bank_account_id'] = bankAccountId;
    data['bank_account_name'] = bankAccountName;
    data['receipt_method_id'] = receiptMethodId;
    data['receipt_method'] = receiptMethod;
    data['remit_bank_acct_use_id'] = remitBankAcctUseId;
    data['coll_mode'] = collMode;
    data['instrument'] = instrument;
    data['remarks'] = remarks;
    data['deposit_no'] = depositNo;
    data['coll_amount'] = collAmount;
    data['bill_to_site_id'] = billToSiteId;
    data['bill_to_site_address'] = billToSiteAddress;
    data['cust_amount'] = custAmount;
    return data;
  }
}

