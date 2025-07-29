class UserInfoModel {

  String? firstName;
  String? lastName;
  String? email;
  String? mobileNo;
  String? photoUrl;
  String? orgId;
  String? orgName;
  String? userId;
  String? salesRepId;
  String? salesPersonName;
  String? employeeId;
  String? employeeName;
  String? userName;
  String? password;
  String? changePasswordFlag;
  String? authCode;
  List<Org> orgs = [];
  int? totalOrgs;

  String? payrollId;
  String? payrollName;
  String? workLocation;
  String? personId;
  String? employeeNumber;
  String? employmentCategory;
  String? fullName;
  String? designation;
  String? department;

 UserInfoModel({
      this.userId = '',
      this.salesRepId = '',
      this.salesPersonName = '',
      this.employeeId = '',
      this.employeeName = '',
      this.userName = '',
      this.orgId = '',
      this.orgName = '',
      this.password = '',
      this.changePasswordFlag = '',
      this.authCode ='',
      this.orgs = const [],
      this.totalOrgs = 0,
 });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    final orgList = (json['ORGS'] as List)
        .map((orgJson) => Org.fromJson(orgJson))
        .toList();
    return UserInfoModel(
      userId: json['USER_ID'],
      salesRepId: json['SALESREP_ID'],
      salesPersonName: json['SALES_PERSON_NAME'],
      employeeId: json['USER_NAME'],
      employeeName: json['EMPLOYEE_NAME'],
      changePasswordFlag: json['CHANGE_PASSW_FLG'],
      userName: json['USER_NAME'],
      authCode: json['AUTH_CODE'],
      orgs: orgList,
      orgId: json['ORG_ID'] ?? (orgList.isNotEmpty ? orgList.first.id : null),
      orgName: json['ORG_NAME'] ?? (orgList.isNotEmpty ? orgList.first.name : null),
      totalOrgs: json['TOTAL_ORGS']
    );
  }

  void fromJsonAdditionalInfo(UserInfoModel infoModel, Map<String, dynamic>? json) {
    if(json == null) return;

    infoModel.payrollId = json['PAYROLL_ID'];
    infoModel.payrollName = json['PAYROLL_NAME'];
    infoModel.workLocation = json['WORK_LOCATION'];
    infoModel.personId = json['PERSON_ID'];
    infoModel.changePasswordFlag = json['CHANGE_PASSW_FLG'];
    infoModel. employeeNumber = json['EMPLOYEE_NUMBER'];
    infoModel.employmentCategory = json['EMPLOYMENT_CATEGORY'];
    infoModel.fullName = json['FULL_NAME'];
    infoModel.designation = json['DESIGNATION'];
    infoModel.department = json['DEPARTMENT'];

  }

  Map<String, dynamic> toJson() => {
    'USER_ID': userId,
    'SALESREP_ID': salesRepId,
    'SALES_PERSON_NAME': salesPersonName,
    'EMPLOYEE_ID': employeeId,
    'EMPLOYEE_NAME': employeeName,
    'USER_NAME': userName,
    'CHANGE_PASSW_FLG': changePasswordFlag,
    'AUTH_CODE': authCode,
    'ORGS': orgs.map((org) => org.toJson()).toList(),
    'ORG_ID': orgId,
    'ORG_NAME': orgName,
    'TOTAL_ORGS': totalOrgs,
  };

  Map<String, dynamic> toLoginBodyJson() {
    final Map<String, dynamic> json = <String, dynamic> {};
    json['username'] = userName ;
    json['password'] = password ;
    return json;
  }

  @override
  String toString() {
    return 'UserInfoModel{firstName: $firstName, lastName: $lastName, email: $email, mobileNo: $mobileNo, photoUrl: $photoUrl, orgId: $orgId, orgName: $orgName, userId: $userId, salesRepId: $salesRepId, salesPersonName: $salesPersonName, employeeId: $employeeId, employeeName: $employeeName, userName: $userName, password: $password, changePasswordFlag: $changePasswordFlag, authCode: $authCode, orgs: $orgs, totalOrgs: $totalOrgs, payrollId: $payrollId, payrollName: $payrollName, workLocation: $workLocation, personId: $personId, employeeNumber: $employeeNumber, employmentCategory: $employmentCategory, fullName: $fullName, designation: $designation, department: $department}';
  }
}


class Org {
  final String id;
  final String name;
  Org({required this.id, required this.name});
  
  factory Org.fromJson(Map<String, dynamic> json) {
    return Org(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  @override
  String toString() {
    return 'Org{id: $id, name: $name}';
  }
}
