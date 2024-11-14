class OrderType {
  String? orderTypeId;
  String? orderType;

  OrderType(
      { this.orderTypeId = "",
        this.orderType = ""});

  OrderType.fromJson(Map<String, dynamic> json) {
    orderTypeId = json['ORDER_TYPE_ID'];
    orderType = json['ORDER_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ORDER_TYPE_ID'] = orderTypeId;
    data['ORDER_TYPE'] = orderType;
    return data;
  }

}
