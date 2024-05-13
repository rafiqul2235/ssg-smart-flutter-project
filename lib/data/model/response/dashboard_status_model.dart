
class DashboardStatusModel {

  String? code;
  String? name;
  int? planed;
  int? visited;
  int? prospectiveCustomer;
  List<String>? groups;
  int? actionLog;

  DashboardStatusModel({this.code, this.name, this.planed, this.visited,
      this.prospectiveCustomer, this.groups, this.actionLog});

  DashboardStatusModel.fromJson(Map<String, dynamic> json) {
    code = json['code']??'';
    name = json['name']??'';
    planed = json['planed']??0;
    visited = json['visited']??0;
    prospectiveCustomer = json['pCustomer']??0;
    String strGroups = json['groups'];
    if(strGroups!=null && strGroups.isNotEmpty){
      groups = strGroups.split(',');
    }
    actionLog = json['actionLog']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['planed'] = planed;
    data['visited'] = visited;
    data['pCustomer'] = prospectiveCustomer;
    data['groups'] = groups;
    data['actionLog'] = actionLog;
    return data;
  }
}