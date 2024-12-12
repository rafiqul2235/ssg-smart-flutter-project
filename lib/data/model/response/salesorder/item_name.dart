class ItemNameModel {

  int? itemId;
  String? itemName;
  String? itemUOM;

  ItemNameModel(
      { this.itemId = 0,
        this.itemName = "",
        this.itemUOM = ""});

  ItemNameModel.fromJson(Map<String, dynamic> json) {
    itemId = json['ITEM_ID']??0;
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