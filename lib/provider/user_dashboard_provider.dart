import 'package:flutter/material.dart';
import '../data/model/response/view_category.dart';
import '../data/repository/user_dashboard_repo.dart';

class UserDashboardProvider extends ChangeNotifier {

  final UserDashboardRepo userDashboardRepo ;

  UserDashboardProvider({required this.userDashboardRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ViewCategory> _viewCategories = [];
  List<ViewCategory> get viewCategories => _viewCategories ?? [];

  int _viewCategoryIndex = 1;
  int get viewCategoryIndex => _viewCategoryIndex;

  void setCategoryIndex(int index) {
    _viewCategoryIndex = index;
    notifyListeners();
  }

}