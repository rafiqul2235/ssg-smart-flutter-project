import 'package:ssg_smart2/data/model/area_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/model/dropdown_model.dart';
import '../data/model/response/base/api_response.dart';
import '../data/repository/master_data_repo.dart';
import '../helper/api_checker.dart';

class MasterDataProvider with ChangeNotifier {

  final MasterDataRepo masterDataRepo;
  MasterDataProvider({required this.masterDataRepo});

  Future<List<DropDownModel>> getAreaData(AreaRequestData requestData) async {

   // print( ' DefaultLocalRepository getAreaData  ${requestData.toString()}');

    List<DropDownModel> datas = [];

    if(requestData.requestDataType == 'Division') {

      String data = await rootBundle.loadString('assets/json/division_data.json');
      Map<String, dynamic> divisionData = json.decode(data);
      datas = (divisionData['Division'] as List)
          .map((e) => DropDownModel(code: e['DivisionCode'] as String, name: e['DivisionNameEng'] as String, nameBl: e['DivisionNameBng'] as String)).toList();

      //print('Division ${datas.length}');

    }else if(requestData.requestDataType == 'District') {

      String data = await rootBundle.loadString('assets/json/district_data.json');
      Map<String, dynamic> districtData = json.decode(data);

      if(requestData.divisionCode!=null && requestData.divisionCode!.isNotEmpty) {
        datas = (districtData['District'] as List)
            .where((e) =>
        e['DivisionCode'] as String == requestData.divisionCode).toList()
            .map((e) => DropDownModel(code: e['DistrictCode'] as String,
            name: e['DistrictNameEng'] as String,
            nameBl: e['DistrictNameBng'] as String)).toList();
      }else{
        //All District
        datas = (districtData['District'] as List)
            .map((e) => DropDownModel(code: e['DistrictCode'] as String,
            name: e['DistrictNameEng'] as String,
            nameBl: e['DistrictNameBng'] as String)).toList();

      }
      //print('District ${datas.length}');

    }else if(requestData.requestDataType == 'MCU') {
      //print('MCU');
      String data = await rootBundle.loadString('assets/json/mcu_data.json');
      Map<String, dynamic> mcu = json.decode(data);
      datas = (mcu['MCU'] as List)
          .where((e) => e['DistrictCode'] as String == requestData.districtCode && e['MCUType'] as String == requestData.mCUType).toList()
          .map((e) => DropDownModel(code: e['MCUCode'] as String, name: e['MCUNameEng'] as String, nameBl: e['MCUNameBng'] as String)).toList();

    }else if(requestData.requestDataType == 'UM') {
      //print('UM');

      String data = await rootBundle.loadString('assets/json/um_data.json');
      Map<String, dynamic> um = json.decode(data);
      datas = (um['UM'] as List)
          .where((e) => e['DistrictCode'] as String == requestData.districtCode && e['MCUCode'] as String == requestData.mCUCode ).toList()
          .map((e) => DropDownModel(code: e['UMCode'] as String, name: e['UMNameEng'] as String, nameBl: e['UMNameBng'] as String)).toList();

    }else if(requestData.requestDataType == 'Ward') {
      //print('Ward');
      String data = await rootBundle.loadString('assets/json/ward_data.json');
      Map<String, dynamic> ward = json.decode(data);
      datas = (ward['Ward'] as List)
          .where((e) => e['DistrictCode'] as String == requestData.districtCode && e['UMCode'] as String == requestData.uMCode ).toList()
          .map((e) => DropDownModel(code: e['WardCode'] as String, name: e['WardNameEng'] as String, nameBl: e['WardNameBng'] as String)).toList();

      /*
         datas = (ward['Ward'] as List)
          .where((e) => e['DistrictCode'] as String == requestData.districtCode && e['MCUCode'] as String == requestData.mCUCode && e['UMCode'] as String == requestData.uMCode ).toList()
          .map((e) => DropDownModel(code: e['WardCode'] as String, name: e['WardNameEng'] as String, nameBl: e['WardNameBng'] as String)).toList();
       */
      //print('Ward ${datas.length}');

    } else if(requestData.requestDataType == 'Ethnicity') {
      //print('Ethnicity');

      String data = await rootBundle.loadString('assets/json/form_entity_data.json');
      Map<String, dynamic> ward = json.decode(data);
      datas = (ward['FormEntity'] as List)
          .where((e) => e['ElementTable'] as String == 'ethnicity').toList()
          .map((e) => DropDownModel(code: (e['ElementId'] as int).toString() , name: e['ElementTextEn'] as String, nameBl: e['ElementTextBn'] as String)).toList();

      //print('Ethnicity ${datas.length}');

    }

    return datas;

    /*data = await rootBundle.loadString('assets/json/district_data.json');
    Map<String, dynamic> districtData = json.decode(data);

    data = await rootBundle.loadString('assets/json/mcu_data.json');
    Map<String, dynamic> mcu_data = json.decode(data);

    data = await rootBundle.loadString('assets/json/um_data.json');
    Map<String, dynamic> um_data = json.decode(data);

    data = await rootBundle.loadString('assets/json/ward_data.json');
    Map<String, dynamic> ward_data = json.decode(data);

    data = await rootBundle.loadString('assets/json/form_entity_data.json');
    Map<String, dynamic> form_entity_data = json.decode(data);*/

    /*
    return AreaDataResponse(
      status: 200,
      message:'',
      divisions: (divisionData['Division'] as List)
          ?.map((e) => e == null
          ? null
          : DivisionEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      districts: (districtData['District'] as List)
          ?.map((e) => e == null
          ? null
          : DistrictEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      mCUs: (mcu_data['MCU'] as List)
          ?.map((e) =>
      e == null ? null : MCUEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      uMs: (um_data['UM'] as List)
          ?.map((e) =>
      e == null ? null : UMEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      wards: (*//*ward_data['Ward'] as*//* List())
          ?.map((e) =>
      e == null ? null : WardEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      formEntities: (*//*form_entity_data['FormEntity'] as*//* List())
          ?.map((e) => e == null
          ? null
          : FormDefaultEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
    */

  }

  Future<List<DropDownModel>> getRegionAreaTerritoryHierarchy(BuildContext context, String inputType, String inputValue,
      String columnNameForData,String columnNameForCode,{String initialValue=''}) async {
    ApiResponse apiResponse = await masterDataRepo.getRegionAreaTerritoryHierarchyList(inputType, inputValue,
        columnNameForData, columnNameForCode);
    List<DropDownModel> _dealerList = [];
    if(initialValue=='ALL'){
      _dealerList.add(DropDownModel(code: 'ALL',name: 'ALL',description: null));
    }
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      apiResponse.response?.data.forEach((item) => _dealerList.add(DropDownModel.fromJson(item)));
    }else {
      if(context!=null) {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    return _dealerList;
  }

  Future<List<DropDownModel>> getMaskerDataKey(BuildContext context,String category, String key) async {
    List<DropDownModel> data = [];
    ApiResponse apiResponse = await masterDataRepo.getMaskerDataKey(category, key);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      apiResponse.response?.data.forEach((item) => data.add(DropDownModel.fromJsonMasterKey(item)));
    }else {
      if(context!=null) {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    return data;
  }

  Future<List<DropDownModel>> getCampaignList(BuildContext context) async {
    List<DropDownModel> data = [];
    ApiResponse apiResponse = await masterDataRepo.getCampaignList();
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      apiResponse.response?.data.forEach((item) => data.add(DropDownModel.fromJsonCampaignList(item)));
    }else {
      if(context!=null) {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    return data;
  }

  Future<List<DropDownModel>> getBankBranchList(BuildContext context,String bankName, String districtName) async {
    List<DropDownModel> data = [];
    ApiResponse apiResponse = await masterDataRepo.getBankBranchList(bankName,districtName);
    if(apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      apiResponse.response?.data.forEach((item) => data.add(DropDownModel.fromJsonBankBranchList(item)));
    }else {
      if(context!=null) {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    return data;
  }
}