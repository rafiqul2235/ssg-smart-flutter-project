class BankInfo {

  String? bankAccountName;
  String? bankAccountId;
  String? receiptMethod;
  String? receiptMethodId;
  String? remitBankAccountUseId;

  BankInfo(
      { this.bankAccountName = "",
        this.bankAccountId = "",
        this.receiptMethod = "",
        this.receiptMethodId = "",
        this.remitBankAccountUseId = ""});

  BankInfo.fromJson(Map<String, dynamic> json) {
    bankAccountName = json['BANK_ACCOUNT_NAME']??'';
    bankAccountId = json['BANK_ACCOUNT_ID']??'';
    receiptMethod = json['RECEIPT_METHOD']??'';
    receiptMethodId = json['RECEIPT_METHOD_ID']??'';
    remitBankAccountUseId = json['REMIT_BANK_ACCT_USE_ID']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BANK_ACCOUNT_NAME'] = bankAccountName;
    data['BANK_ACCOUNT_ID'] = bankAccountId;
    data['RECEIPT_METHOD'] = receiptMethod;
    data['RECEIPT_METHOD_ID'] = receiptMethodId;
    data['REMIT_BANK_ACCT_USE_ID'] = remitBankAccountUseId;
    return data;
  }

  @override
  String toString() {
    return 'BankInfo{bankAccountName: $bankAccountName, bankAccountId: $bankAccountId, receiptMethod: $receiptMethod, receiptMethodId: $receiptMethodId, remitBankAccountUseId: $remitBankAccountUseId}';
  }
}
