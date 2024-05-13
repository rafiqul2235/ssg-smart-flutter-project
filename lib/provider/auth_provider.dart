import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/body/login_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/base/error_response.dart';
import 'package:ssg_smart2/data/model/response/response_model.dart';
import 'package:ssg_smart2/data/repository/auth_repo.dart';
import '../data/model/response/user_info_model.dart';
import 'dart:developer' as developer;

class AuthProvider with ChangeNotifier {

  final AuthRepo authRepo;
  bool _isLoading = false;
  bool _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;
  String _userCode = '';
  String _userGroup = '';
  String _userRole = '';

  AuthProvider({required this.authRepo}) {
    if(isLoggedIn()){
      _isRemember = authRepo.isRemember();
    }
  }

  String? get userCode => _userCode;
  void setUserCode(String userCode) {
    _userCode = userCode;
  }

  String? get userGroup => _userGroup??'';
  void setUserGroup(String userGroup) {
    _userGroup = userGroup;
  }

  String? get userRole => _userRole;
  void setUserRole(String userRole) {
    _userRole = userRole;
  }

  updateSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }

  bool? get isLoading => _isLoading;
  bool? get isRemember => _isRemember;

  void updateRemember(bool value,{bool reload = true}) {
    _isRemember = value;
    if(reload) {
      notifyListeners();
    }
  }

  void showLoading(){
    if(!_isLoading!) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void hideLoading(){
    if(_isLoading!) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future authToken(String authToken ) async{
    authRepo.saveAuthToken(authToken);
    notifyListeners();
  }

  Future login(BuildContext context, LoginModel loginBody, Function callback) async {

    showLoading();

    ApiResponse apiResponse = await authRepo.login(loginBody);

    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

      Map map = apiResponse.response?.data;

      print(map.toString());

      if(map['success'] == 1) {
        String token = map['user']['AUTH_CODE'];
        UserInfoModel userInfoModel = UserInfoModel.fromJson(map['user']);
        authRepo.saveUserToken(token);
        authRepo.saveUserData(userInfoModel);

        callback(true, token);
      }else{
         String errorMessage = map['msg'][0];
         callback(false, errorMessage);
      }

      hideLoading();

    } else {
      hideLoading();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false,errorMessage);
    }
  }

  Future updateBaseLocation(BuildContext context, Map<String,dynamic> body, Function callback) async {
    showLoading();
    ApiResponse apiResponse = await authRepo.updateBaseLocation(body);
    hideLoading();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      String message = apiResponse.response?.data['message'];
      callback(true, message);
    }else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
  }

/*  Future<void> updateToken(BuildContext context) async {
    ApiResponse apiResponse = await authRepo.updateToken();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {

    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }*/

  //email
  Future<ResponseModel> checkEmail(String email, String temporaryToken) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.checkEmail(email,temporaryToken);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response?.data['token'], true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage,false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyEmail(email, _verificationCode, token);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel( apiResponse.response?.data["message"], true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  //phone
  Future<ResponseModel> checkPhone(String phone, String temporaryToken) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.checkPhone(phone, temporaryToken);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response?.data["token"],true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel( errorMessage,false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String phone, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo.verifyPhone(phone, token, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel( apiResponse.response?.data["message"], true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage,false);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;

  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  String _verificationMsg = '';

  String get verificationMessage => _verificationMsg;
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }
  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for user Section
  String getUserToken() {
    return authRepo.getUserToken();
  }

  //get auth token
  // for user Section
  String getAuthToken() {
    return authRepo.getAuthToken();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  /*Future<UserInfoModel> getUserData() async {
    return authRepo.getUserData();
  }*/

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  // for  Remember ID and Pin Code
  void saveUserIdAndPinCode(String userId, String pinCode, String password) {
    authRepo.saveUserIdAndPinCode(userId, pinCode, password);
  }

  String getUserId() {
    return authRepo.getUserId() ?? "";
  }

  String getUserCode() {
    return authRepo.getUserCode() ?? "";
  }

  String getUserPinCode() {
    return authRepo.getUserPinCode() ?? "";
  }


  String getUserEmail() {
    return authRepo.getUserEmail() ?? "";
  }

  Future<bool> clearUserIdAndPinCode() async {
    return authRepo.clearUserIdAndPinCode();
  }


  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<ResponseModel> sendOtpToEmail(String email) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.sendOtpToEmail(email);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel("${apiResponse.response?.data["result"]["otp"]}", true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String email, int otp, String newPassword) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.resetPassword(email, otp, newPassword);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response?.data["message"], true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
    }
    return responseModel;
  }
}
