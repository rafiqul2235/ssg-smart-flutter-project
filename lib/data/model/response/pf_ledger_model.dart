class PfLedgerModel {

  String period_name ="";
   int con_prof_total = 0;
   int net_total = 0;




  PfLedgerModel({
    this.period_name='', this.con_prof_total = 0, this.net_total = 0
  });
//parssing method
  PfLedgerModel.fromJson(Map<String, dynamic> json) {
    period_name = json['PERIOD']??'';
    con_prof_total = int.parse(json['CON_PROFIT_TOTAL']??'0');
    net_total = int.parse(json['NET_TOTAL']??'0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PERIOD'] = period_name;
    data['CON_PROFIT_TOTAL'] = con_prof_total;
    data['NET_TOTAL'] = net_total;

    return data;
  }

  @override
  String toString() {
    return 'PfLedgerModel{period_name: $period_name, con_prof_total: $con_prof_total, net_total: $net_total}';
  }
}