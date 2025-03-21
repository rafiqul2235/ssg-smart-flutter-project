class DeliveryInfoModel {
  final String salesRepId;
  final String trip_info;
  final String event_time;
  final String additiontion_info;


  DeliveryInfoModel({
    required this.salesRepId,
    required this.trip_info,
    required this.event_time,
    required this.additiontion_info,
  });

  factory DeliveryInfoModel.fromJson(Map<String, dynamic> json) {
    return DeliveryInfoModel(
      salesRepId: json['SALESREP_ID'],
      trip_info: json['TRIP_INFO'],
      event_time: json['DLV_EVENT_TIME'],
      additiontion_info: json['ADITIONAL_INFO'],
    );
  }
}
