class FreightTerm {
  String? freightTerm;


  FreightTerm(
      { this.freightTerm = ""});

  FreightTerm.fromJson(Map<String, dynamic> json) {
    //warehouseId = json['WAREHOUSE_ID'];
    freightTerm = json['freight_terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['freight_terms'] = freightTerm;
    return data;
  }

}
