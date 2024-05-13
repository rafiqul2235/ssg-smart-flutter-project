class GenericModelRequest {

  final String? actionType;
  final String? param1;
  final String? param2;
  final double? latitude;
  final double? longitude;
  final int? id;
  final String? token;
  final bool? status;
  final Map<String,dynamic>? reqBody;

  GenericModelRequest({this.actionType, this.param1, this.param2,this.latitude,this.longitude,
    this.id, this.token, this.reqBody,this.status});

}