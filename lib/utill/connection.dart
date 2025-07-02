import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Connection {

  static Future<bool> checkConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();

    // Check if any connection is available (excluding none)
    return !results.contains(ConnectivityResult.none);
  }

  static void showNotConnectedMessage(BuildContext context, {int durationInSec = 3}) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      duration: Duration(seconds: durationInSec),
      content: Text(
        'No Internet Connection!',
        textAlign: TextAlign.center,
      ),
    ));
  }

  static void showConnectivityMessage(BuildContext context, {List<ConnectivityResult>? results}) async {
    if (results == null) {
      results = await Connectivity().checkConnectivity();
    }

    bool isNotConnected = results.contains(ConnectivityResult.none);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isNotConnected ? Colors.red : Colors.green,
      duration: Duration(seconds: isNotConnected ? 6 : 3), // Fixed: was 6000 seconds
      content: Text(
        isNotConnected ? 'No Internet Connection!' : 'Connected!',
        textAlign: TextAlign.center,
      ),
    ));
  }
}