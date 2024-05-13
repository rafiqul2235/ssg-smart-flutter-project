
import 'dropdown_model.dart';

class AreaRequestData {

  String? requestDataType;
  bool? hasParentCode;
  String? divisionCode;
  String? districtCode;
  String? mCUType;
  String? mCUCode;
  String? uMCode;
  String? wardCode;
  String? formEntityId;

  AreaRequestData({
    this.requestDataType,
    this.hasParentCode,
    this.divisionCode,
    this.districtCode,
    this.mCUType,
    this.mCUCode,
    this.uMCode,
    this.wardCode,
    this.formEntityId});

  @override
  String toString() {
    return 'AreaRequestData{requestDataType: $requestDataType, hasParentCode: $hasParentCode, divisionCode: $divisionCode, districtCode: $districtCode, mCUCode: $mCUCode, uMCode: $uMCode, wardCode: $wardCode, formEntityId: $formEntityId}';
  }
}

class AreaData {

   List<DropDownModel>? divisions;
   List<DropDownModel>? districts;
   List<DropDownModel>? mcus;
   List<DropDownModel>? ums;
   List<DropDownModel>? wards;
   List<DropDownModel>? formEntities;

  AreaData({this.divisions, this.districts, this.mcus, this.ums, this.wards,
    this.formEntities});
}

/*class ItemData *//*extends Equatable*//* {

  String itemCode;
  String itemNameEng;
  String itemNameBng;

  ItemData({this.itemCode,this.itemNameEng,this.itemNameBng});


*//*@override
  List<Object> get props => [itemCode,itemNameEng,itemNameBng];*//*

*//*  @override
  bool operator ==(Object other) => other is ItemData && other.itemCode == itemCode;

  @override
  int get hashCode => itemCode.hashCode;*//*
}*/

class Division {
  int? divisionId;
  String? divisionCode;
  String? divisionNameEng;
  String? divisionNameBng;

  Division({this.divisionId, this.divisionCode, this.divisionNameEng,
    this.divisionNameBng});
}

class District {

  int? districtId;
  String? divisionCode;
  String? districtCode;
  String? districtNameEng;
  String? districtNameBng;

  District({this.districtId, this.divisionCode, this.districtCode,
    this.districtNameEng, this.districtNameBng});
}

class MCU {
  final int? mCUId;
  final String? districtCode;
  final String? mCUCode;
  final String? mCUNameEng;
  final String? mCUNameBng;
  final String? mCUType;
  final String? uCDNameEng;
  final String? uCDNameBng;
  final String? isUCDMultiple;

  MCU({
    this.mCUId,
    this.districtCode,
    this.mCUCode,
    this.mCUNameEng,
    this.mCUNameBng,
    this.mCUType,
    this.uCDNameEng,
    this.uCDNameBng,
    this.isUCDMultiple});
}
class UM {

  final int? uMId;
  final String? districtCode;
  final String? mCUCode;
  final String? uMCode;
  final String? uMNameEng;
  final String? uMNameBng;
  final String? uMType;
  final String? uCDNo;
  final String? uCDNameEng;
  final String? uCDNameBng;

  UM({
    this.uMId,
    this.districtCode,
    this.mCUCode,
    this.uMCode,
    this.uMNameEng,
    this.uMNameBng,
    this.uMType,
    this.uCDNo,
    this.uCDNameEng,
    this.uCDNameBng});
}
class Ward {
  final int? wardId;
  final String? districtCode;
  final String? mCUCode;
  final String? uMCode;
  final String? wardCode;
  final String? wardNameEng;
  final String? wardNameBng;
  final String? uCDNo;
  final String? uCDNameEng;
  final String? cDNameBng;

  Ward({
    this.wardId,
    this.districtCode,
    this.mCUCode,
    this.uMCode,
    this.wardCode,
    this.wardNameEng,
    this.wardNameBng,
    this.uCDNo,
    this.uCDNameEng,
    this.cDNameBng});
}

class FormEntity {

  final int? pwdFormEntityId;
  final String? elementId;
  final String? elementOrder;
  final String? elementTextEn;
  final String? elementTextBn;
  final String? elementTable;
  final int? status;

  FormEntity({this.pwdFormEntityId, this.elementId, this.elementOrder,
    this.elementTextEn, this.elementTextBn, this.elementTable, this.status});
}
