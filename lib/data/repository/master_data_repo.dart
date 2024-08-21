import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/utill/app_constants.dart';

class MasterDataRepo {

  final DioClient dioClient;
  MasterDataRepo({required this.dioClient});

  Future<ApiResponse> getRegionAreaTerritoryHierarchyList(String inputType, String inputValue, String columnNameForData,
      String columnNameForCode) async {
    try {
      final response = await dioClient.get('AppConstants.RegionAreaTerritoryHierarchy'+inputType+'&inputValue='+inputValue+'&columnNameForData='+columnNameForData+'&columnNameForCode='+columnNameForCode);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMaskerDataKey(String category, String key) async {
    try {
      final response = await dioClient.get('AppConstants.MASTER_KEY_SETTINGS'+category+'&key='+key);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCampaignList() async {
    try {
      final response = await dioClient.get('AppConstants.CAMPAIGNS');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBankBranchList(String bankName, String districtName) async {
    try {
      final response = await dioClient.get('AppConstants.BANK_BRANCH_LIST_URI'+bankName+'&district='+districtName);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}