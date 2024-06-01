import 'dart:io';
import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRepo {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  UserRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getUserMenu(String userId, String orgId) async {
    try {

      final Map<String, dynamic> data = <String, dynamic>{};
      data['user_id'] = userId;
      data['org_id']=  orgId;

      final response = await dioClient.postWithFormData(
          AppConstants.USER_MENU_URI,
         data:data
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserList() async {
    try {
      final response = await dioClient.get("AppConstants.USER_LIST_URI");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient.get("AppConstants.USER_PROFILE_URI");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserDefault() async {
    try {
      final response = await dioClient.get('AppConstants.USER_DEFAULTS');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, String pass, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${'AppConstants.UPDATE_PROFILE_URI'}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null){
      request.files.add(http.MultipartFile('files', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
     Map<String, String> _fields = Map();

    _fields.addAll(<String, String>{
      //'firstName': userInfoModel.firstName??'', 'lastName': userInfoModel.lastName??'',
      //'gender': userInfoModel.genderId.toString(),'userName': userInfoModel.userId??'',
     // 'password': pass!=null&&pass.isNotEmpty?pass:userInfoModel.password??'','address': userInfoModel.address??"",
      //'mobileNo': userInfoModel.mobileNo??'', 'email': userInfoModel.email??''
    });

    /*if(pass.isEmpty) {
      _fields.addAll(<String, String>{
        '_method': 'put', 'firstName': userInfoModel.firstName, 'lastName': userInfoModel.lastName, 'mobileNo': userInfoModel.mobileNo
      });
    }else {
      _fields.addAll(<String, String>{
        '_method': 'put', 'f_name': userInfoModel.firstName, 'l_name': userInfoModel.lastName, 'phone': userInfoModel.mobileNo, 'password': pass
      });
    }*/

    request.fields.addAll(_fields);
    print('========>${_fields.toString()}');
    http.StreamedResponse response = await request.send();
    return response;
  }

}
