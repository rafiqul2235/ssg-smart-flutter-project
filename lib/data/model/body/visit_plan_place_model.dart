
class VisitPlanPlaceModel {

  int? id = 0;
  String? customerCode;
  bool? isProspectiveCustomer;
  String? priority;
  String? planDateTime;
  String? planMonth;
  String? assignee;
  String? assigner;
  String? dataProvider;
  String? planNotes;
  bool? isDeleted = false;

  VisitPlanPlaceModel({
      this.id,
      this.customerCode,
      this.isProspectiveCustomer,
      this.priority,
      this.planDateTime,
      this.planMonth,
      this.assignee,
      this.assigner,
      this.dataProvider,
      this.planNotes,
      this.isDeleted
  });

  VisitPlanPlaceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customerCode'];
    isProspectiveCustomer = json['isProspectiveCustomer'];
    priority = json['priority'];
    planDateTime = json['planDateTime'];
    planMonth = json['planMonth'];
    assignee = json['assignee'];
    assigner = json['assigner'];
    dataProvider = json['dataProvider'];
    planNotes = json['planNotes'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ;
    data['customerCode'] = customerCode ;
    data['isProspectiveCustomer'] = isProspectiveCustomer ;
    data['priority'] = priority ;
    data['planDateTime'] = planDateTime ;
    data['planMonth'] = planMonth ;
    data['assignee'] = assignee ;
    data['assigner'] = assigner ;
    data['dataProvider'] = dataProvider ;
    data['planNotes'] = planNotes ;
    data['isDeleted'] = isDeleted ;
    return data;
  }

  Map<String, dynamic> toJsonForCET() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fpr'] = assignee;
    data['customerCode'] = customerCode;
    data['isInfluencer'] = isProspectiveCustomer;
    data['planDateTime'] = planDateTime;
    data['planMonth'] = planMonth;
    data['planNotes'] = planNotes;
    data['isDeleted'] = isDeleted;
    return data;
  }

  @override
  String toString() {
    return 'VisitPlanPlaceModel{id: $id, customerCode: $customerCode, isProspectiveCustomer: $isProspectiveCustomer, priority: $priority, planDateTime: $planDateTime, planMonth: $planMonth, assignee: $assignee, assigner: $assigner, dataProvider: $dataProvider, planNotes: $planNotes, isDeleted: $isDeleted}';
  }
}
