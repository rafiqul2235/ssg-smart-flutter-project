import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class UserDataStorage {
  static Future<void> saveUserInfo(UserInfoModel userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = json.encode(userInfo.toJson());
    print('userInfo(UserDataStorage): $userInfoJson');
    await prefs.setString(AppConstants.USER_DATA, userInfoJson);
  }

  static Future<UserInfoModel?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString(AppConstants.USER_DATA);
    print('getUserInfo: $userInfoJson');
    if (userInfoJson != null) {
      final userInfoMap = json.decode(userInfoJson);
      return UserInfoModel.fromJson(userInfoMap);
    }
    return null;
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.USER_DATA);
  }
}