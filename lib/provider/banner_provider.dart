import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/banner_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/repository/banner_repo.dart';
import 'package:ssg_smart2/helper/api_checker.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel> _mainBannerList = [];
  List<BannerModel> _footerBannerList = [];
  int _currentIndex = 0;

  List<BannerModel> get mainBannerList => _mainBannerList;
  List<BannerModel> get footerBannerList => _footerBannerList;

  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload, BuildContext context) async {

    //_mainBannerList = [];

   // _mainBannerList.add(BannerModel(id: 1, photo: 'Globatt',url: 'assets/images/banner_globatt.jpg'));
    //_mainBannerList.add(BannerModel(id: 1, photo: 'RA Interface',url: 'assets/images/ra_interface.jpg'));
    //_mainBannerList.add(BannerModel(id: 2, photo: 'Globatt',url: 'assets/images/banner_globatt2.jpg'));

    //if (_mainBannerList == null || _mainBannerList.isEmpty || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        _mainBannerList = [];
        apiResponse.response?.data.forEach((bannerModel) => _mainBannerList.add(BannerModel.fromJson(bannerModel)));
        _currentIndex = 0;
        if(reload) {
          notifyListeners();
        }
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    //}
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> getFooterBannerList(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getFooterBannerList();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _footerBannerList = [];
      apiResponse.response?.data.forEach((bannerModel) => _footerBannerList.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }
}
