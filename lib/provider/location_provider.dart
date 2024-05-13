import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/address_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/model/response/base/error_response.dart';
import 'package:ssg_smart2/data/model/response/response_model.dart';
import 'package:ssg_smart2/data/repository/location_repo.dart';
import 'package:ssg_smart2/helper/api_checker.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

import '../utill/plance_service.dart';

class LocationProvider with ChangeNotifier {

  final SharedPreferences sharedPreferences;
  final LocationRepo locationRepo;

  LocationProvider({required this.sharedPreferences, required this.locationRepo});

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 2, headingAccuracy: 2);
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,altitudeAccuracy: 2, headingAccuracy: 2);
  bool _loading = false;
  bool get loading => _loading;
  bool _isBilling = true;
  bool get isBilling =>_isBilling;
  TextEditingController _locationController = TextEditingController();

  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Placemark _address = Placemark();
  Placemark _pickAddress = Placemark();

  Placemark get address => _address;
  Placemark get pickAddress => _pickAddress;
  List<Marker> _markers = <Marker>[];
  TextEditingController get locationController => _locationController;

  List<Marker> get markers => _markers;

  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController ?_mapController;
  List<Prediction> _predictionList = [];
  bool _updateAddAddressData = true;

  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController? get mapController => _mapController;

  void setLocationController(String text) {
    _locationController.text = text;
  }

  Future<void> initLocation() async {
    await getCurrentLocation2();
    getAddressFromLatLng(null);
  }

  Future<Position> getCurrentLocation2() async {
    Position _myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: AppConstants.Location_Accuracy);
      _myPosition = newLocalData;
      _position = newLocalData;
    }catch(e) {
      if(_position!=null) {
        _myPosition = _position;
      }else{
        _myPosition = Position(
          latitude: double.parse('0'),
          longitude: double.parse('0'),
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          heading: 1,
          speed: 1,
          speedAccuracy: 1, altitudeAccuracy: 2, headingAccuracy: 2,
        );
      }
    }
    return _myPosition;
  }

  // for get current location
  void getCurrentLocation(BuildContext context, bool fromAddress, {GoogleMapController? mapController}) async {

    print('_position');

    _loading = true;
    notifyListeners();
    Position _myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: AppConstants.Location_Accuracy);
      _myPosition = newLocalData;
    }catch(e) {

      _myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,altitudeAccuracy: 2, headingAccuracy: 2
      );
    }
    if(fromAddress) {
      _position = _myPosition;
    }else {
      _pickPosition = _myPosition;
    }

    print('_position ${_position.toJson()}');

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 17),
      ));
    }
    Placemark _myPlaceMark;
    try {
        String? _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude), context);
        _myPlaceMark = Placemark(name: _address, locality: '', postalCode: '', country: '');

    }catch (e) {
      String? _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude), context);
      _myPlaceMark = Placemark(name: _address, locality: '', postalCode: '', country: '');
    }
    fromAddress ? _address = _myPlaceMark : _pickAddress = _myPlaceMark;
    if(fromAddress) {
      _locationController.text = placeMarkToAddress(_address);
    }
    _loading = false;
    //notifyListeners();
  }

  void updatePosition(CameraPosition position, bool fromAddress, String address, BuildContext context) async {
    if(_updateAddAddressData) {
      _loading = true;
      notifyListeners();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,altitudeAccuracy: 2, headingAccuracy: 2
          );
        } else {
          _pickPosition = Position(
            latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,altitudeAccuracy: 2, headingAccuracy: 2
          );
        }
        if (_changeAddress) {
            String _addresss = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude), context)??'';
            fromAddress ? _address = Placemark(name: _addresss) : _pickAddress = Placemark(name: _addresss);

          if(address != null) {
            _locationController.text = address;
          }else if(fromAddress) {
            _locationController.text = placeMarkToAddress(_address);
          }
        } else {
          _changeAddress = true;
        }
      } catch (e) {}
      _loading = false;
      notifyListeners();
    }else {
      _updateAddAddressData = true;
    }
  }

  // End Address Position
  void dragableAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(_position.latitude, _position.longitude);
    _address = placemarks.first;
    _locationController.text = placeMarkToAddress(_address);
    //saveUserAddress(address: currentAddresses.first);
    notifyListeners();
  }

  // delete usser address
  void deleteUserAddressByID(int id, int index, Function callback) async {
    ApiResponse apiResponse = await locationRepo.removeAddressByID(id);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _addressList?.removeAt(index);
      callback(true, 'Deleted address successfully');
      notifyListeners();
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
      callback(false, errorMessage);
    }
  }

  bool _isAvaibleLocation = false;

  bool get isAvaibleLocation => _isAvaibleLocation;

  // user address
  List<AddressModel>? _addressList;

  List<AddressModel>? get addressList => _addressList;

  Future<ResponseModel?> initAddressList(BuildContext context) async {
    ResponseModel? _responseModel;
    ApiResponse apiResponse = await locationRepo.getAllAddress();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _addressList = [];
      apiResponse.response?.data?.forEach((address) => _addressList?.add(AddressModel.fromJson(address)));
      _responseModel = ResponseModel('successful', true);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  String _addressStatusMessage = '';
  String get addressStatusMessage => _addressStatusMessage;
  updateAddressStatusMessae({String? message}){
    _addressStatusMessage = message??'';
  }
  updateErrorMessage({String? message}){
    _errorMessage = message??'';
  }

  Future<ResponseModel> addAddress(AddressModel addressModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = '';
    ApiResponse apiResponse = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      Map map = apiResponse.response?.data;
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(message, true);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for address update screen
  Future<ResponseModel> updateAddress(BuildContext context, {AddressModel? addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = '';
    ApiResponse apiResponse = await locationRepo.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      Map map = apiResponse.response?.data;
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel( message, true);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for Label Us
  List<String> _getAllAddressType = [];

  List<String> get getAllAddressType => _getAllAddressType;
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  initializeAllAddressType({BuildContext? context}) {
    if (_getAllAddressType.length == 0) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo.getAllAddressType(context: context);
    }
  }

  void setLocation(String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    notifyListeners();
    PlacesDetailsResponse detail;
    ApiResponse response = await locationRepo.getPlaceDetails(placeID);
    detail = PlacesDetailsResponse.fromJson(response.response?.data);

    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lat, latitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,altitudeAccuracy: 2, headingAccuracy: 2
    );

    //_pickAddress = Placemark(name: address);
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
        detail.result.geometry!.location.lat, detail.result.geometry!.location.lng,
      ), zoom: 17)));
    }
    _loading = false;
    notifyListeners();
  }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData() {
    _position = _pickPosition;
   // _address = _pickAddress;
    _locationController.text = placeMarkToAddress(_address);
    _updateAddAddressData = false;
    notifyListeners();
  }

  void setPickData() {
    _pickPosition = _position;
    //_pickAddress = _address;
    _locationController.text = placeMarkToAddress(_address);
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<String?> getAddressFromGeocode(LatLng latLng, BuildContext context) async {
    ApiResponse response = await locationRepo.getAddressFromGeocode(latLng);
    String? _address = 'Unknown Location Found';
    if(response.response?.statusCode == 200 && response.response?.data['status'] == 'OK') {
      _address = response.response?.data['results'][0]['formatted_address'].toString();
    }else {
      ApiChecker.checkApi(context, response);
    }
    return _address;
  }

  Future<String> getAddressFromGeocode2(LatLng latLng) async {
   /* if(latLng == null){
      if(_position == null || _position.latitude <= 0.0){
        return '';
      }else{
        latLng = LatLng(_position.latitude,_position.longitude);
      }
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark placeMark  = placemarks[0];
    _address = placeMark;
    String name = placeMark.name??'';
    String subLocality = placeMark.subLocality??'';
    String locality = placeMark.locality??'';
    String administrativeArea = placeMark.administrativeArea??"";
    String postalCode = placeMark.postalCode??'';
    String country = placeMark.country??'';
    String strAddress = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    print(strAddress);*/
    //return strAddress;
    return "";
  }

  Future<String> getAddressFromLatLng(LatLng? latLng) async {
    if(latLng == null){
      if(_position == null || _position.latitude <= 0.0){
        return '';
      }else{
        latLng = LatLng(_position.latitude,_position.longitude);
      }
    }
    final sessionToken = Uuid().v4();
    String address  = await PlaceApiProvider(sessionToken).fetchAddress(latLng);
   // _address = Placemark(name: address);
    return address;
  }

/*  String getAddressFromPlacemark(Placemark? placeMark){
    placeMark ??= _address;
    String name = placeMark.name??'';
    String subLocality = placeMark.subLocality??'';
    String locality = placeMark.locality??'';
    String administrativeArea = placeMark.administrativeArea??'';
    String postalCode = placeMark.postalCode??'';
    String country = placeMark.country??'';
    String strAddress = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
    return strAddress;
  }*/


  Future<double> getDistanceCalculation(LatLng originLatLng, LatLng destinationLatLng) async {
    return Geolocator.distanceBetween(originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude);
  }

  Future<double> getDistanceCalculation2(LatLng originLatLng, LatLng destinationLatLng) async{
    double distanceKm = locationRepo.getDistanceInKiloMeter(originLatLng, destinationLatLng);
    return distanceKm * 1000;
  }

  Future<double> getDealerNearLocationInMeter(LatLng dealerLocation) async {
    double distanceKm = locationRepo.getDistanceInKiloMeter(LatLng(_position.latitude, _position.longitude), dealerLocation);
    return distanceKm * 1000;
  }

  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if(text != null && text.isNotEmpty) {
      ApiResponse response = await locationRepo.searchLocation(text);
      if (response.response?.statusCode == 200 && response.response?.data['status'] == 'OK') {
        _predictionList = [];
        response.response?.data['predictions'].forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(context, response);
      }
    }
    return _predictionList;
  }

  String placeMarkToAddress(Placemark placeMark) {
    return '${placeMark.name ?? ''}'
        ' ${placeMark.subAdministrativeArea ?? ''}'
        ' ${placeMark.isoCountryCode ?? ''}';
  }

  void isBillingChanged(bool change) {
    _isBilling = change;
    if (change) {
      change = !_isBilling;
    }
    notifyListeners();
  }


}
