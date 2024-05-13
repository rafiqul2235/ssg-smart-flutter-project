class DropDownModel {

  int? id;
  String? code;
  String? name;
  String? nameBl;/* Bengali Text*/
  String? description;

  DropDownModel({this.id, this.code, this.name,this.nameBl,this.description=''});

  DropDownModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    code = json['code'];
    name = json['name'];
  }

  DropDownModel.fromJsonMasterKey(Map<String, dynamic>? json) {
    if (json == null) return;
    code = '${json['id']}';
    name = json['value'];
  }

  DropDownModel.fromJsonCampaignList(Map<String, dynamic>? json) {
    if (json == null) return;
    id = json['id']??0;
    //code = '${json['id']}';
    name = json['name']??'';
  }
  DropDownModel.fromJsonBankBranchList(Map<String, dynamic>? json) {
    if (json == null) return;
    //id = json['branchId']??0;
    code = '${json['branchId']}';
    name = json['branchName']??'';
  }

  DropDownModel.fromJsonCustomer(Map<String, dynamic>? json) {
    if (json == null) return;
    code = json['businessCode'];
    name = json['name'];
    description = json['type'];
  }

}
