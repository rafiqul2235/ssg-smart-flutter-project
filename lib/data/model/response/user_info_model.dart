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
  String? authCode;
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
      this.password ,
      this.authCode ='',
      this.totalOrgs = 0,
 });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    if(json == null) return;

    userId = json['USER_ID'];
    salesRepId = json['SALESREP_ID'];
    salesPersonName = json['SALES_PERSON_NAME'];
    //employeeId = json['EMPLOYEE_ID'];
    employeeName = json['EMPLOYEE_NAME'];
    userName = json['USER_NAME'];
    authCode = json['AUTH_CODE'];

    employeeId = userName;

    try {
      orgId = json['ORGS'][0]['id'];
    }catch(e){
      orgId = json['ORG_ID'];
    }

    try {
      orgName = json['ORGS'][0]['name'];
    }catch(e){
      orgName = json['ORG_NAME'];
    }

    totalOrgs = json['TOTAL_ORGS'];

  }


  void fromJsonAdditionalInfo(UserInfoModel infoModel, Map<String, dynamic>? json) {
    if(json == null) return;

    infoModel.payrollId = json['PAYROLL_ID'];
    infoModel.payrollName = json['PAYROLL_NAME'];
    infoModel.workLocation = json['WORK_LOCATION'];
    infoModel.personId = json['PERSON_ID'];
    infoModel. employeeNumber = json['EMPLOYEE_NUMBER'];
    infoModel.employmentCategory = json['EMPLOYMENT_CATEGORY'];
    infoModel.fullName = json['FULL_NAME'];
    infoModel.designation = json['DESIGNATION'];
    infoModel.department = json['DEPARTMENT'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic> {};
     json['USER_ID'] = userId;
     json['SALESREP_ID'] = salesRepId;
     json['SALES_PERSON_NAME'] = salesPersonName;
     json['EMPLOYEE_ID'] = employeeId;
     json['EMPLOYEE_NAME'] = employeeName;
     json['USER_NAME'] = userName;
     json['AUTH_CODE'] = authCode;
     json['ORG_ID'] = orgId;
     json['ORG_NAME'] = orgName;
     json['TOTAL_ORGS'] = totalOrgs;
    return json;
  }

  Map<String, dynamic> toLoginBodyJson() {
    final Map<String, dynamic> json = <String, dynamic> {};
    json['username'] = userName ;
    json['password'] = password ;
    return json;
  }

  @override
  String toString() {
    return 'UserInfoModel{firstName: $firstName, lastName: $lastName, email: $email, mobileNo: $mobileNo, photoUrl: $photoUrl, orgId: $orgId, orgName: $orgName, userId: $userId, salesRepId: $salesRepId, salesPersonName: $salesPersonName, employeeId: $employeeId, employeeName: $employeeName, userName: $userName, password: $password, authCode: $authCode, totalOrgs: $totalOrgs, payrollId: $payrollId, payrollName: $payrollName, workLocation: $workLocation, personId: $personId, employeeNumber: $employeeNumber, employmentCategory: $employmentCategory, fullName: $fullName, designation: $designation, department: $department}';
  }
}
