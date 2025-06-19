import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Connection {

  static Future<bool> checkConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    bool status = results != ConnectivityResult.wifi && results != ConnectivityResult.mobile;

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

  static void showConnectivityMessage(BuildContext context, {List<ConnectivityResult>? results}) async {

    if(results == null) {
      results = await Connectivity().checkConnectivity();
    }

    bool isNotConnected = !results.any((result) =>
      result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet
    );

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