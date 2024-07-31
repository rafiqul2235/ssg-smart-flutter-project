import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Connection {

  static Future<bool> checkConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    bool status = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;

    return !status;
  }

  static void showNotConnectedMessage(BuildContext context, {int durationInSec = 3}) async {

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      duration: Duration(seconds:durationInSec),
      content: Text(
        'No Internet Connection!',
        textAlign: TextAlign.center,
      ),
    ));

  }

  static void showConnectivityMessage(BuildContext context, {ConnectivityResult? result}) async {

    if(result == null) {
      result = await Connectivity().checkConnectivity();
    }

    bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isNotConnected ? Colors.red : Colors.green,
      duration: Duration(seconds: isNotConnected ? 6000 : 3),
      content: Text(
        isNotConnected ? 'No Internet Connection!' : 'Connected!',
        textAlign: TextAlign.center,
      ),
    ));

  }
}