import 'package:ssg_smart2/data/model/response/user_info_model.dart';

class HouseKeepingDataItem {

   int? itemId;
   String? itemCode;
   String? itemName;
   String? itemDescription;
   String? activity;
   double? sequenceNo;
   bool? isSelected = false;

  HouseKeepingDataItem({this.itemId,this.itemCode, this.itemName, this.itemDescription, this.activity, this.sequenceNo,this.isSelected = false});

  HouseKeepingDataItem.fromJsonForActionLogMailReceiver(Map<String, dynamic> json) {
    itemId = json['id'];
    activity = json['activity'];

    UserInfoModel user = UserInfoModel.fromJson(json['user']);

    if(user !=null){
      //itemCode = user.shortName;
     // itemName = '${user.shortName??''} ( ${user.firstName??''} ${user.lastName??''} )';
      //itemDescription = user.email;
    }
  }
}
