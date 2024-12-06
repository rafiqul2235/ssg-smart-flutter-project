class ItemPriceModel {
  int itemPrice;

  ItemPriceModel({this.itemPrice = 0});

  ItemPriceModel.fromJson(Map<String, dynamic> json)
      : itemPrice = int.tryParse(json['ITEM_PRICE']?.toString() ?? '') ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_PRICE'] = itemPrice;
    return data;
  }

  @override
  String toString() {
    return 'ItemPriceModel{itemPrice: $itemPrice}';
  }
}