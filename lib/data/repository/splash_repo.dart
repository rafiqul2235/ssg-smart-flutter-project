import 'package:ssg_smart2/data/datasource/remote/dio/dio_client.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.dioClient, required this.sharedPreferences});

  void initSharedData() async {
    if (!sharedPreferences.containsKey(AppConstants.SEARCH_ADDRESS)) {
      sharedPreferences.setStringList(AppConstants.SEARCH_ADDRESS, []);
    }
    if (!sharedPreferences.containsKey(AppConstants.INTRO)) {
      sharedPreferences.setBool(AppConstants.INTRO, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.CURRENCY)) {
      sharedPreferences.setString(AppConstants.CURRENCY, '');
    }
  }

  String getCurrency() {
    return sharedPreferences.getString(AppConstants.CURRENCY) ?? '';
  }

  void setCurrency(String currencyCode) {
    sharedPreferences.setString(AppConstants.CURRENCY, currencyCode);
  }

  void disableIntro() {
    sharedPreferences.setBool(AppConstants.INTRO, false);
  }

  bool? showIntro() {
    return sharedPreferences.getBool(AppConstants.INTRO);
  }


}
