class Warehouse {
  String? warehouseId;
  String? warehouseName;

  Warehouse(
      { this.warehouseId = "",
        this.warehouseName = ""});

  Warehouse.fromJson(Map<String, dynamic> json) {
    warehouseId = json['WAREHOUSE_ID'];
    warehouseName = json['WAREHOUSE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['WAREHOUSE_ID'] = warehouseId;
    data['WAREHOUSE_NAME'] = warehouseName;
    return data;
  }

}
