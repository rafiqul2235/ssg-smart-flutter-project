class ItemPriceModel {

   int itemPrice = 0;


  ItemPriceModel({this.itemPrice=0});

  ItemPriceModel.fromJson(Map<String, dynamic> json) {
    itemPrice = json['ITEM_PRICE']??'';
  }

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