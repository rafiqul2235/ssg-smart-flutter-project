class PfLedgerModel {

   String period_name ="";
   String con_employee = '';
   String con_employer = '';
   String con_total = '';
   String pro_employee = '';
   String pro_employer = '';
   String pro_total = '';
   String con_with_prof = '';
   String loan_amt = '';
   String recovery = '';
   String outstanding = '';
   String net_total = '';

  PfLedgerModel({
    this.period_name='', this.con_employee = '', this.con_employer = '',this.con_total = '',this.pro_employee = '',
    this.pro_employer = '',this.pro_total = '', this.con_with_prof = '',this.loan_amt = '',this.recovery = '',this.outstanding = '',this.net_total = ''
  });
//parssing method
  PfLedgerModel.fromJson(Map<String, dynamic> json) {
    period_name = json['PERIOD']??'';
    con_employee = json['CONTRIBUTION_OWN']??'0';
    con_employer = json['CONTRIBUTION_EMPLOYER']??'0';
    con_total = json['CON_TOTAL']??'0';
    //pro_employee = int.parse(json['PROFIT_OWN']??'0');
    pro_employer = json['PROFIT_EMPLOYER']??'0';
    pro_total = json['PROF_TOTAL']??'0';
    con_with_prof = json['CON_PROFIT_TOTAL']??'0';
    loan_amt = json['LOAN_AMOUNT']??'0';
    recovery = json['RECOVERY']??'0';
    outstanding = json['OUTSTANDING']??'0';
    net_total = json['NET_TOTAL']??'0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PERIOD'] = period_name;
    data['CONTRIBUTION_OWN'] = con_employee;
    data['CONTRIBUTION_EMPLOYER'] = con_employer;
    data['CON_TOTAL'] = con_total;
    data['PROFIT_OWN'] = pro_employee;
    data['PROFIT_EMPLOYER'] = pro_employer;
    data['PROF_TOTAL'] = pro_total;
    data['CON_PROFIT_TOTAL'] = con_with_prof;
    data['LOAN_AMOUNT'] = loan_amt;
    data['RECOVERY'] = recovery;
    data['OUTSTANDING'] = outstanding;
    data['NET_TOTAL'] = net_total;

    return data;
  }

  @override
  String toString() {
    return 'PfLedgerModel{period_name: $period_name, con_employee: $con_employee, con_employer: $con_employer, con_total: $con_total, pro_employee: $pro_employee, pro_employer: $pro_employer, pro_total: $pro_total, con_with_prof: $con_with_prof, loan_amt: $loan_amt, recovery: $recovery, outstanding: $outstanding, net_total: $net_total}';
  }
}