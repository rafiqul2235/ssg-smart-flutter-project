class SalaryAdvanceData {
  String empId;
  String empName;
  String designation;
  String department;
  String location;
  String eligibilityStatus;
  String eligibilityAmount;
  double amount;
  int installment;
  String reason;
  String applicationType;
  String statusFlg;
  String lastUpdateBy;
  String lastUpdateLogin;

  SalaryAdvanceData({
    required this.empId,
    required this.empName,
    required this.designation,
    required this.department,
    required this.location,
    required this.eligibilityStatus,
    required this.eligibilityAmount,
    required this.amount,
    required this.installment,
    required this.reason,
    required this.applicationType,
    required this.statusFlg,
    required this.lastUpdateBy,
    required this.lastUpdateLogin
});

  Map<String, dynamic> toJson(){
    return{
      "EMPLOYEE_ID": empId,
      "EMPLOYEE_NAME": empName,
      "DEPARTMENT_NAME": department,
      "LOCATION": location,
      "ELIGIBILITY_STATUS": eligibilityStatus,
      "ELIGIBILITY_AMOUNT": eligibilityAmount,
      "APPLIED_AMOUNT": amount,
      "NO_INSTALLMENT": installment,
      "REASON": reason,
      "APPLICATION_TYPE": applicationType,
      "STATUS_FLG": statusFlg,
      "LAST_UPDATED_BY": lastUpdateBy,
      "LAST_UPDATE_LOGIN": lastUpdateLogin,
    };
  }

}