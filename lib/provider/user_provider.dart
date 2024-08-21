import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/response_model.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/data/repository/user_repo.dart';
import 'package:ssg_smart2/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import '../data/model/response/app_update_info.dart';
import '../data/model/response/self_service.dart';
import '../data/model/response/user_menu.dart';
import 'dart:developer' as developer;
import '../utill/app_constants.dart';
import 'auth_provider.dart';

class UserProvider extends ChangeNotifier {

  final UserRepo userRepo;

  UserProvider({required this.userRepo});

  /* User Or Employee Information */
  UserInfoModel? _userInfoModel;
  List<UserInfoModel> _userList = [];

  /* User Menu List */
  List<UserMenu> _userMenuList = [];

  /* Application List */
  List<SelfServiceModel> _applicationList = [];

  bool _isLoading = false;
  bool _hasData = false;

  UserInfoModel? get userInfoModel => _userInfoModel;
  List<UserInfoModel> get userList => _userList?? [];
  List<UserMenu> get userMenuList => _userMenuList?? [];

  List<SelfServiceModel> get applicationList => _applicationList?? [];

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

  Future<void> getUserInfoFromSharedPref({bool reload = false}) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      String? strUserData = prefs.getString(AppConstants.USER_DATA);
      print('Data  $strUserData');
      _userInfoModel =  UserInfoModel.fromJson(jsonDecode(strUserData??''));
    }catch(e){
      print("getUserData error ");
      print(e.toString());
    }

  }

 void getUserMenu(BuildContext context) async {

   AuthProvider authProvider =  Provider.of<AuthProvider>(context, listen: false);

   ApiResponse apiResponse = await userRepo.getUserMenu(authProvider.getUserId(), authProvider.getOrgId());

   if(apiResponse.response != null && apiResponse.response?.statusCode == 200){
     /*developer.log(
         'log me',
         name: 'User_Menu',
         error: apiResponse.response?.data.toString()
     );*/

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

   }else {
     ApiChecker.checkApi(context, apiResponse);
   }

 }

  Future<void> getEmployeeInfo(BuildContext context) async {

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();
    /*String? department =  Provider.of<UserProvider>(context, listen: false).userInfoModel?.department;*/

    ApiResponse apiResponse = await userRepo.getEmployeeInfo(empId);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _userInfoModel?.fromJsonAdditionalInfo(_userInfoModel!, apiResponse.response?.data['emp_info'][0]);

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }

  }


  Future<void> getApplicationList(BuildContext context) async {

    String empId =  Provider.of<AuthProvider>(context, listen: false).getEmpId();

    ApiResponse apiResponse = await userRepo.getApplicationList(empId);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      _applicationList = [];
      apiResponse.response?.data['service_list'].forEach((application) => _applicationList.add(SelfServiceModel.fromJson(application)));

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
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
