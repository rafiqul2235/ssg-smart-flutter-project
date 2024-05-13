class SummaryReportModel {
  String? userCode;
  String? name;
  int? planed;
  int? visited;
  int? updatedDealer;
  int? pCustomer;
  int? uDealer;
  int? mr;

  SummaryReportModel({
        this.userCode,
        this.name,
        this.planed,
        this.visited,
        this.pCustomer,
        this.uDealer,
        this.mr
  });

  SummaryReportModel.fromJson(Map<String, dynamic> json) {
    userCode = json['code']??'';
    name = json['name']??'';
    planed = json['planed']??0;
    visited = json['visited']??0;
    pCustomer = json['pCustomer']??0;
    uDealer = json['uDealer']??0;
    updatedDealer = json['updatedDealer']??0;
    mr = json['mr']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = userCode;
    data['name'] = name;
    data['planed'] = planed;
    data['visited'] = visited;
    data['pCustomer'] = pCustomer;
    data['uDealer'] = uDealer;
    data['mr'] = mr;
    return data;
  }
}
