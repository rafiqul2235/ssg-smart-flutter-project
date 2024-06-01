import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/response_model.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/data/repository/user_repo.dart';
import 'package:ssg_smart2/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import '../data/model/response/app_update_info.dart';
import '../data/model/response/user_menu.dart';
import 'dart:developer' as developer;

class UserProvider extends ChangeNotifier {

  final UserRepo userRepo;

  UserProvider({required this.userRepo});

  UserInfoModel? _userInfoModel;
  List<UserInfoModel> _userList = [];

  List<UserMenu> _userMenuList = [];

  bool _isLoading = false;
  bool _hasData = false;

  UserInfoModel? get userInfoModel => _userInfoModel;
  List<UserInfoModel> get userList => _userList?? [];
  List<UserMenu> get userMenuList => _userMenuList?? [];

  AppUpdateInfo? _appUpdateInfo;
  AppUpdateInfo? get appUpdateInfo => _appUpdateInfo;

  bool get isLoading => _isLoading;
  bool get hasData => _hasData;

  void showLoading(){
    if(!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void hideLoading(){
    if(_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetLoading() {
    _isLoading = false;
  }

 void getUserMenu(BuildContext context, String userId, String orgId) async {

   ApiResponse apiResponse = await userRepo.getUserMenu(userId, orgId);

    print('getUserMenu ${userId +','+ orgId}');


   if(apiResponse.response != null && apiResponse.response?.statusCode == 200){

     developer.log(
         'log me',
         name: 'User_Menu',
         error: apiResponse.response?.data.toString()
     );

     if(apiResponse.response?.data['success'] == 1){

       _userMenuList = [];

       apiResponse.response?.data['menus'].forEach((menu) {
         _userMenuList.add(UserMenu.fromJson(menu));
       });

     }else{
       String errorMessage = apiResponse.response?.data['msg'][0];

       developer.log(
           'log me for error',
           name: 'User_Menu',
           error: errorMessage
       );

      // callback(false, errorMessage);
     }



    // apiResponse.response.data


   }else {
     ApiChecker.checkApi(context, apiResponse);
   }

 }


  Future<void> getUserList(BuildContext context) async {
    ApiResponse apiResponse = await userRepo.getUserList();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _userList = [];
      apiResponse.response?.data.forEach((user) => _userList.add(UserInfoModel.fromJson(user)));
      print('getUserList ${_userList.length}');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }



  Future<String> getUserInfo(BuildContext context) async {
    String userID = '-1';
    ApiResponse apiResponse = await userRepo.getUserInfo();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response?.data['result']);
      print('getUserInfo ${_userInfoModel.toString()}');
      userID = _userInfoModel!.userId.toString();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return userID;
  }

/*  Future<UserMenu?> findAnUserMenu(String pageDescription) async {
    UserMenu? userMenu;
    if(_userMenuList!=null && _userMenuList.isNotEmpty) {
      for (var value in _userMenuList) {
        if (value.pageDescription == pageDescription) {
          userMenu = value;
          break;
        }
      }
    }
    return userMenu;
  }*/


  Future<void> getUserDefault({bool reload = false}) async {
    ApiResponse apiResponse = await userRepo.getUserDefault();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response?.data['result']['userInfo']);
      if(apiResponse.response?.data['result']['userMenus']!=null && (apiResponse.response?.data['result']['userMenus']as List).isNotEmpty ){
        _userMenuList = [];
        apiResponse.response?.data['result']['userMenus']?.forEach((userMenu) => _userMenuList.add(UserMenu.fromJson(userMenu)));
      }
      _appUpdateInfo = AppUpdateInfo.fromJson(apiResponse.response?.data['result']['appUpdateInfo']);
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }

    if(reload){
      notifyListeners();
    }
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String pass, File? file, String token) async {

    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    http.StreamedResponse response = await userRepo.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

}
