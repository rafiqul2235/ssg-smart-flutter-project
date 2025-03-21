class ItemWisePendingModel {
  final String item_name;
  final String pending_qty;
  final String freight;
  final String uom;


  ItemWisePendingModel({
    required this.item_name,
    required this.pending_qty,
    required this.freight,
    required this.uom
  });

  factory ItemWisePendingModel.fromJson(Map<String, dynamic> json) {
    return ItemWisePendingModel(
        item_name: json['ITEM_DESCRIPTION'],
        pending_qty: json['TOTAL_PENDING_QTY'],
        freight: json['FREIGHT'],
        uom: json['UOM']
    );
  }
}
