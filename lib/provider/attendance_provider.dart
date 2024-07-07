import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/model/response/attendance_sheet_model.dart';
import 'package:ssg_smart2/data/repository/attendance_repo.dart';

class AttendanceProvider with ChangeNotifier{
  final AttendanceRepo attendanceRepo;
  AttendanceProvider({required this.attendanceRepo});

  List<AttendanceSheet> _attendanceRecords = [];
  List<AttendanceSheet> get attendanceRecords => _attendanceRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAttendanceSheet(String empId, String fromDate, String toDate, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceRecords = await attendanceRepo.fetchAttendanceSheet(empId, fromDate, toDate, status);
    } catch (e) {
      print('Error fetching attendance sheet: $e');
      _attendanceRecords = [];
    }

    _isLoading = false;
    notifyListeners();
  }
  void clearAttendanceData(){
    _attendanceRecords = [];
    notifyListeners();
  }

}