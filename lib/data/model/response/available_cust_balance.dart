class AvailableCustBalModel {

   String customerBalance = '';


  AvailableCustBalModel({this.customerBalance=''});

  AvailableCustBalModel.fromJson(Map<String, dynamic> json) {
    customerBalance = json['CREDIT_AVAILABLE']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CREDIT_AVAILABLE'] = customerBalance;
    return data;
  }

   @override
  String toString() {
    return 'CustomerBalanceModel{customerBalance: $customerBalance}';
  }
}