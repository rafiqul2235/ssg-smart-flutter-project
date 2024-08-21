
import 'package:flutter/services.dart';

class GetMacAddress {
  static const MethodChannel _channel = MethodChannel('com.sevenringscement.ssg_smart2');

  static Future<String> get macAddress async {
    print('macID ');
    final String macID = await _channel.invokeMethod('getMAC');
    print('macID $macID');
    return macID;
  }
}