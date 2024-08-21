import 'package:ssg_smart2/data/model/response/api_pagination_response.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/notification_model.dart';
import 'package:ssg_smart2/data/repository/notification_repo.dart';
import 'package:ssg_smart2/helper/api_checker.dart';

class NotificationProvider extends ChangeNotifier {

  final NotificationRepo notificationRepo;

  NotificationProvider({required this.notificationRepo});

  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;

  Future<void> initNotificationList(BuildContext context,int pageNo, int pageSize) async {
    ApiResponse apiResponse = await notificationRepo.getNotificationList(pageNo,pageSize);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _notificationList = [];
      ApiPaginationResponse? response =  ApiPaginationResponse.fromJson(apiResponse.response?.data);
      response?.data?.forEach((notification) => _notificationList.add(NotificationModel.fromJson(notification)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> changeMessageReadFlag(BuildContext context, int messageId) async {
    ApiResponse apiResponse = await notificationRepo.changeMessageFlag(messageId);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      //Provider.of<InventoryProvider>(context, listen: false).getInventoryDefaults(isNotify: true);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

}
