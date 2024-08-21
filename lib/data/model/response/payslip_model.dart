class EmployeePaySlip {
  final String empNameId;
  final String designation;
  final String departmentSection;
  final String doj;
  final String payrollMonth;
  final String workingLocation;
  final String grossSal;
  final String basic;
  final String houseRent;
  final String medicalAllowance;
  final String conveyance;
  final String entertainment;
  final String otherAllowance;
  final String taAndTD;
  final String otherPayment;
  final String totalEarning;
  final String incomeTax;
  final String loanInstallment;
  final String pfEmployee;
  final String pfLoanRecovery;
  final String excessMobileBill;
  final String otherDeduction;
  final String totalDeduction;
  final String netPayable;
  final String inWord;

  EmployeePaySlip({
    required this.empNameId,
    required this.designation,
    required this.departmentSection,
    required this.doj,
    required this.payrollMonth,
    required this.workingLocation,
    required this.grossSal,
    required this.basic,
    required this.houseRent,
    required this.medicalAllowance,
    required this.conveyance,
    required this.entertainment,
    required this.otherAllowance,
    required this.taAndTD,
    required this.otherPayment,
    required this.totalEarning,
    required this.incomeTax,
    required this.loanInstallment,
    required this.pfEmployee,
    required this.pfLoanRecovery,
    required this.excessMobileBill,
    required this.otherDeduction,
    required this.totalDeduction,
    required this.netPayable,
    required this.inWord,
  });

  factory EmployeePaySlip.fromJson(Map<String, dynamic> json) {
    return EmployeePaySlip(
      empNameId: json['EMP_NAME_ID'],
      designation: json['DESIGNATION'],
      departmentSection: json['DEPARTMENT_SECTION'],
      doj: json['DOJ'],
      payrollMonth: json['PAYROLL_MONTH'],
      workingLocation: json['WORKING_LOCATION'],
      grossSal: json['GROSS_SAL'],
      basic: json['BASIC'],
      houseRent: json['HOUSE_RENT'],
      medicalAllowance: json['MEDICAL_ALLOWANCE'],
      conveyance: json['CONVEYANCE'],
      entertainment: json['ENTERTAINMENT']?.isEmpty ?? true ? '0.00' :json['ENTERTAINMENT'],
      otherAllowance: json['OTHER_ALLOWANCE']?.isEmpty ?? true ? '0.00' :json['OTHER_ALLOWANCE'],
      taAndTD: json['TA_OT']?.isEmpty ?? true ? '0.00' :json['TA_OT'],
      otherPayment: json['OTHERS_PAYMENTS']?.isEmpty ?? true ? '0.00' :json['OTHERS_PAYMENTS'],
      totalEarning: json['TOTAL_EARNING'],
      incomeTax: json['INCOME_TEX']?.isEmpty ?? true ? '0.00' : json['INCOME_TEX'],
      loanInstallment: json['LOAN_INSTALLMENT']?.isEmpty ?? true ? '0.00' :json['LOAN_INSTALLMENT'],
      pfEmployee: json['PF_EMPLOYEE']?.isEmpty ?? true ? '0.00' : json['PF_EMPLOYEE'],
      pfLoanRecovery: json['PF_LOAN_RECOVERY']?.isEmpty ?? true ? '0.00' :json['PF_LOAN_RECOVERY'],
      excessMobileBill: json['EXCESS_MOBILE_BILL']?.isEmpty ?? true ? '0.00' :json['EXCESS_MOBILE_BILL'],
      otherDeduction: json['OTHER_DEDUCTION']?.isEmpty ?? true ? '0.00' :json['OTHER_DEDUCTION'],
      totalDeduction: json['TOTAL_DEDUCTION'],
      netPayable: json['NET_PAYABLE'],
      inWord: json['IN_WORD'],
    );
  }
}