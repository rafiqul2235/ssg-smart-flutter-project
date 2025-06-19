import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';

class NetworkInfo {

  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

   Future<bool> get isConnected async {
    List<ConnectivityResult> results = await connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  static void checkConnectivity(BuildContext context) {
    bool _firstTime = true;
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      if(!_firstTime) {
        bool isNotConnected;

        bool hasNoConnection = results.every((result) => result == ConnectivityResult.none);
        if(hasNoConnection) {
          isNotConnected = true;
        }else {
          isNotConnected = !await _updateConnectivityStatus();
        }
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
      }
      _firstTime = false;
    });
  }

  static Future<bool> _updateConnectivityStatus() async {
     bool _isConnected = false;
     try {
       final List<InternetAddress> _result = await InternetAddress.lookup('google.com');
       if(_result.isNotEmpty && _result[0].rawAddress.isNotEmpty) {
         _isConnected = true;
       }
     }catch(e) {
       _isConnected = false;
     }
     return _isConnected;
  }
}
