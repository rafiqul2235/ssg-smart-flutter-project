class AitDetail {
  final String headerId;
  final String customerId;
  final String customerAccount;
  final String customerName;
  final String challanNo;
  final String invoiceAmount;
  final String aitAmount;
  final String tax;
  final String difference;
  final String challanDate;
  final String remarks;
  final String statusflag;
  final String orgId;
  final String orgName;
  final String department;
  final String designation;
  final String empName;
  final String empNumber;
  final String status;
  final String salesSection;
  final String financialYear;
  final List<String> filePaths;

  AitDetail({
    required this.headerId,
    required this.customerId,
    required this.customerAccount,
    required this.customerName,
    required this.challanNo,
    required this.invoiceAmount,
    required this.aitAmount,
    required this.tax,
    required this.difference,
    required this.challanDate,
    required this.remarks,
    required this.statusflag,
    required this.orgId,
    required this.orgName,
    required this.department,
    required this.designation,
    required this.empName,
    required this.empNumber,
    required this.status,
    required this.salesSection,
    required this.financialYear,
    required this.filePaths,
  });

  factory AitDetail.fromJson(Map<String, dynamic> json) {
    return AitDetail(
      headerId: json['headerId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      customerAccount: json['customerAccount']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      challanNo: json['challanNo']?.toString() ?? '',
      invoiceAmount: json['invoiceAmount']?.toString() ?? '',
      aitAmount: json['aitAmount']?.toString() ?? '',
      tax: json['tax']?.toString() ?? '',
      difference: json['difference']?.toString() ?? '',
      challanDate: json['challanDate']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      statusflag: json['statusflag']?.toString() ?? '',
      orgId: json['orgId']?.toString() ?? '',
      orgName: json['orgName']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      empName: json['empName']?.toString() ?? '',
      empNumber: json['empNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      salesSection: json['sales_section']?.toString() ?? '',
      financialYear: json['financialYear']?.toString()??'',
      filePaths: (json['file_paths'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  @override
  String toString() {
    return 'AitDetail{headerId: $headerId, customerId: $customerId, customerAccount: $customerAccount, customerName: $customerName, challanNo: $challanNo, invoiceAmount: $invoiceAmount, aitAmount: $aitAmount, challanDate: $challanDate, remarks: $remarks, statusflag: $statusflag, orgId: $orgId, orgName: $orgName, department: $department, designation: $designation, empName: $empName, empNumber: $empNumber, status: $status, salesSection: $salesSection, filePaths: $filePaths}';
  }
}