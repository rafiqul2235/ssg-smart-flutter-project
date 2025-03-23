class WppfLedger {
  final String payrollName;
  final String employeeNumber;
  final String employeeName;
  final String fiscalYear;
  final String wppfAmount;
  final String eachEmpEarningAmt;
  final String eachEmpInvestmentAmt;
  final String eachEmpPayableAmt;
  final String eachEmpTaxAmt;
  final String eachEmpNetAmt;
  final String investProfit;
  final String investProfitPayable;
  final String paymentStatus;
  final String wppfStatus;

  WppfLedger({
    required this.payrollName,
    required this.employeeNumber,
    required this.employeeName,
    required this.fiscalYear,
    required this.wppfAmount,
    required this.eachEmpEarningAmt,
    required this.eachEmpInvestmentAmt,
    required this.eachEmpPayableAmt,
    required this.eachEmpTaxAmt,
    required this.eachEmpNetAmt,
    required this.investProfit,
    required this.investProfitPayable,
    required this.paymentStatus,
    required this.wppfStatus,
  });

  factory WppfLedger.fromJson(Map<String, dynamic> json) {
    return WppfLedger(
      payrollName: json['PAYROLL_NAME'],
      employeeNumber: json['EMPLOYEE_NUMBER'],
      employeeName: json['EMPLOYEE_NAME'],
      fiscalYear: json['FISCAL_YEAR'],
      wppfAmount: json['WPPF_AMOUNT'],
      eachEmpEarningAmt: json['EACH_EMP_EARNING_AMT'],
      eachEmpInvestmentAmt: json['EACH_EMP_INVESTMENT_AMT'],
      eachEmpPayableAmt: json['EACH_EMP_PAYABLE_AMT'],
      eachEmpTaxAmt: json['EACH_EMP_TAX_AMT'],
      eachEmpNetAmt: json['EACH_EMP_NET_AMT'],
      investProfit: json['INVEST_FROFIT'],
      investProfitPayable: json['INVEST_FROFIT_PAYABLE'],
      paymentStatus: json['PAYMENT_STATUS'],
      wppfStatus: json['WPPF_STATUS'],
    );
  }
}