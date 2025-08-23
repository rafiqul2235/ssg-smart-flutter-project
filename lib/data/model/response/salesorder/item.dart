class OrderItem {
  int? itemId;
  String? itemName;
  String? itemUOM;

  OrderItem(
      { this.itemId = 0,
        this.itemName = "",
        this.itemUOM = ""});

  OrderItem.fromJson(Map<String, dynamic> json) {
    try {
      itemId = int.parse(json['ITEM_ID']??'0');
    }catch(e){};

    itemName = json['ITEM_NAME']??'';
    itemUOM = json['ITEM_UOM']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_ID'] = itemId;
    data['ITEM_NAME'] = itemName;
    data['ITEM_UOM'] = itemUOM;
    return data;
  }

  @override
  String toString() {
    return 'OrderItem{itemId: $itemId, itemName: $itemName, itemUOM: $itemUOM}';
  }
}
