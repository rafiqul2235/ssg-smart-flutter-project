import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/repository/search_repo.dart';
import 'package:ssg_smart2/helper/api_checker.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo searchRepo;
  SearchProvider({required this.searchRepo});

  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  List<String> get historyList => _historyList;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void sortSearchList(double startingPrice, double endingPrice) {
   // _searchProductList = [];
    if(startingPrice > 0 && endingPrice > startingPrice) {
      /*_searchProductList.addAll(_filterProductList.where((product) =>
      (product.unitPrice!) > startingPrice && (product.unitPrice!) < endingPrice).toList());*/
    }else {
      //_searchProductList.addAll(_filterProductList);
    }

   /* if (_filterIndex == 0) {

    } else if (_filterIndex == 1) {
      _searchProductList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    } else if (_filterIndex == 2) {
      _searchProductList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable!.toList() as List<Product>;
    } else if (_filterIndex == 3) {
      _searchProductList.sort((a, b) => a.unitPrice!.compareTo(b.unitPrice as num));
    } else if (_filterIndex == 4) {
      _searchProductList.sort((a, b) => a.unitPrice!.compareTo(b.unitPrice as num));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList() as List<Product>;
    }*/

    notifyListeners();
  }

  bool _isClear = true;
  String _searchText = '';

  bool get isClear => _isClear;
  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void searchProduct(String query, BuildContext context) async {
    _searchText = query;
    _isClear = false;
    //_searchProductList = [];

    notifyListeners();

    ApiResponse apiResponse = await searchRepo.getSearchProductList(query);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      if (query.isEmpty) {
        //_searchProductList = [];
      } else {
      /*  _searchProductList = [];
        _searchProductList.addAll(ProductModel.fromJson(apiResponse.response?.data).products as Iterable<Product>);
        _filterProductList = [];
        _filterProductList.addAll(ProductModel.fromJson(apiResponse.response?.data).products as Iterable<Product>);*/
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
    notifyListeners();
  }

  void saveSearchAddress(String searchAddress) async {
    searchRepo.saveSearchAddress(searchAddress);
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }
}
