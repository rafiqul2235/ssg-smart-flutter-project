import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/body/login_model.dart';
import 'package:ssg_smart2/data/model/body/register_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/social_login_model.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/response/user_info_model.dart';

class AuthRepo {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> login(LoginModel loginBody) async {
    try {
      Response response = await dioClient.postWithFormData(
        AppConstants.LOGIN_URI,
        data: loginBody.toLoginBodyJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('Auth Repo login ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> updateBaseLocation(Map<String,dynamic> body) async {
    try {
      Response response = await dioClient.post(
        'AppConstants.UPDATE_BASE_LOCATION',
        data: body,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> getDeviceToken() async {
    String? _deviceToken = "";
    if(Platform.isIOS) {
      _deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    }else {
      _deviceToken = await FirebaseMessaging.instance.getToken();
    }

    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }

  Future<String> getDeviceType() async {
    String _deviceType;
    if(Platform.isIOS) {
      _deviceType = 'iOS';
    }else {
      _deviceType = 'Android';
    }
    return _deviceType;
  }

  Future<bool> saveUserData(UserInfoModel userInfoModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      if(userInfoModel!=null) {
        prefs.setString(AppConstants.USER_CODE, userInfoModel.userName??'');
        prefs.setString(AppConstants.USER_DATA, jsonEncode(userInfoModel.toJson()));
      }else{
        prefs.setString(AppConstants.USER_DATA, '');
      }
    }catch(e){
      print(" Set Cart error ${e.toString()}");
      return false;
    }
    return prefs.commit();
  }

  Future<UserInfoModel?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      String? strUserData = prefs.getString(AppConstants.USER_DATA);
      print('Data  $strUserData');
      return UserInfoModel.fromJson(jsonDecode(strUserData??''));
    }catch(e){
      print("getUserData error ");
      print(e.toString());
      return null;
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  // for user credential remember
  Future<void> saveRemember(bool isRemember) async {
    try {
      await sharedPreferences.setBool(AppConstants.CREDENTIAL_REMEMBER, isRemember);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  //auth token
  // for  user token
  Future<void> saveAuthToken(String token) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  String getAuthToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }


  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool isRemember() {
    return sharedPreferences.getBool(AppConstants.CREDENTIAL_REMEMBER)??false;
  }

  Future<bool> clearSharedData() async {
    sharedPreferences.remove(AppConstants.USER_DATA);
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.USER_ID);
    sharedPreferences.remove(AppConstants.USER_PIN_CODE);
    sharedPreferences.remove(AppConstants.CREDENTIAL_REMEMBER);
    /*FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);*/
    return true;
  }

  // for verify Email
  Future<ApiResponse> checkEmail(String email, String temporaryToken) async {
    try {
      Response response = await dioClient.post('AppConstants.CHECK_EMAIL_URI', data: {"email": email, "temporary_token" : temporaryToken});
        return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token, String tempToken) async {
    try {
      Response response = await dioClient.post('AppConstants.VERIFY_EMAIL_URI', data: {"email": email, "token": token, 'temporary_token': tempToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  //verify phone number

  Future<ApiResponse> checkPhone(String phone, String temporaryToken) async {
    try {
      Response response = await dioClient.post(
          'AppConstants.CHECK_PHONE_URI', data: {"phone": phone, "temporary_token" :temporaryToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyPhone(String phone, String token,String otp) async {
    try {
      Response response = await dioClient.post(
          'AppConstants.VERIFY_PHONE_URI', data: {"phone": phone.trim(), "temporary_token": token,"otp": otp});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  Remember User ID and PinCode
  Future<void> saveUserIdAndPinCode(String userId, String pinCode, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_ID, userId);
      await sharedPreferences.setString(AppConstants.USER_PIN_CODE, pinCode);
    } catch (e) {
      throw e;
    }
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.USER_ID) ?? "";
  }

  String getUserCode() {
    return sharedPreferences.getString(AppConstants.USER_CODE) ?? "";
  }

  String getUserPinCode() {
    return sharedPreferences.getString(AppConstants.USER_PIN_CODE) ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserIdAndPinCode() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_ID);
    return await sharedPreferences.remove(AppConstants.USER_PIN_CODE);
  }

  Future<ApiResponse> sendOtpToEmail(String email) async {
    try {
      Response response = await dioClient.post('AppConstants.SEND_OTP_URI'+email);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String email, int otp, String newPassword) async {
    try {
      Response response = await dioClient.put('AppConstants.RESET_PASSWORD_URI', data: {"email": email,"otp": otp,"newPassword": newPassword});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
