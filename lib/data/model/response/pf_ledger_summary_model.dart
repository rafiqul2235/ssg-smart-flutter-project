class PfLedgerSummaryModel {

  String total_contribute ="";
  String total_interest ="";
  String total_loan ="";
  String total_recovered ="";
  String total_outstanding ="";
  String total_balance ="";





  PfLedgerSummaryModel({
    this.total_contribute='', this.total_interest='', this.total_loan='', this.total_recovered='', this.total_outstanding='', this.total_balance=''
  });
//parssing method
  PfLedgerSummaryModel.fromJson(Map<String, dynamic> json) {
    total_contribute = json['CON_TOTAL']??'';
    total_interest = json['PROF_TOTAL']??'';
    total_loan = json['LOAN_AMOUNT']??'';
    total_recovered = json['COLL_AMOUNT']??'';
    total_outstanding = json['OUTSTANDING']??'';
    total_balance = json['NET_TOTAL']??'';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CON_TOTAL'] = total_contribute;
    data['PROF_TOTAL'] = total_interest;
    data['LOAN_AMOUNT'] = total_loan;
    data['COLL_AMOUNT'] = total_recovered;
    data['OUTSTANDING'] = total_outstanding;
    data['NET_TOTAL'] = total_balance;


    return data;
  }

  @override
  String toString() {
    return 'PfLedgerSummaryModel{total_contribute: $total_contribute, total_interest: $total_interest, total_loan: $total_loan, total_recovered: $total_recovered, total_outstanding: $total_outstanding, total_balance: $total_balance}';
  }
}