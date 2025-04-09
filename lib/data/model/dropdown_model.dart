import 'package:ssg_smart2/data/model/body/customer_details.dart';
import 'package:ssg_smart2/data/model/body/financial_year.dart';

class DropDownModel {
  int? id;
  String? code;
  String? name;
  String? nameBl;/* Bengali Text*/
  String? description;
  String? type;
  String? category;
  String? address;
  String? salesSection;


  // DropDownModel(this.id, this.code, this.name);

  DropDownModel({this.id, this.code, this.name, this.nameBl, this.description,
      this.type, this.category, this.address, this.salesSection});

  DropDownModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    code = json[''];
    name = json[''];
  }
  DropDownModel.fromJsonForLeaveType(Map<String, dynamic>? json) {
    if (json == null) return;
    code = json['LEAVE_TYPE_ID'];
    name = json['LEAVE_TYPE'];
  }

  DropDownModel.fromJsonForCustList(Map<String, dynamic>? json) {
    if (json == null) return;
    code = json['CUSTOMER_ID'];
    name = json['CUSTOMER_NAME'];
  }

  DropDownModel.fromJsonForSrTripList(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['TRIP_NUMBER'] +"   "+ json['CUSTOMER_NAME'];
    code = json['TRIP_NUMBER'];
  }

  DropDownModel.fromJsonMasterKey(Map<String, dynamic>? json) {
    if (json == null) return;
    name = '${json['id']}';
    code = json['value'];
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



  DropDownModel.fromJsonCustomerInfo(CustomerDetails customer) {
     id = int.tryParse(customer.customerId ?? '0');
     code = customer.accountNumber;
     name = customer.customarName;
     type = customer.customerType;
     category = customer.customerCategory;
     address = customer.billToAddress;
     salesSection = customer.salesSection;

  }

  DropDownModel.fromJsonFinancialYear(FinancialYear financialYear) {
    code = financialYear.enableFlagId;
    name = financialYear.description;
  }

  @override
  String toString() {
    return 'DropDownModel{id: $id, code: $code, name: $name, nameBl: $nameBl, description: $description}';
  }
}
