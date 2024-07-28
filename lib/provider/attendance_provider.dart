import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/model/response/attendance_sheet_model.dart';
import 'package:ssg_smart2/data/repository/attendance_repo.dart';

import '../data/model/response/attendance_summary_model.dart';

class AttendanceProvider with ChangeNotifier{
  final AttendanceRepo attendanceRepo;
  AttendanceProvider({required this.attendanceRepo});

  List<AttendanceSheet> _attendanceRecords = [];
  List<AttendanceSheet> get attendanceRecords => _attendanceRecords;

  Map<String, int> attendanceSummary = {
    "Present": 0,
    "Offday": 0,
    "Late": 0,
    "Leave": 0
  };

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

    // Calculate summary
    attendanceSummary = {
      "Present": _attendanceRecords.where((element) => element.status == "Present").length,
      "Offday": _attendanceRecords.where((element) => element.status == "Offday").length,
      "Late": _attendanceRecords.where((element) => element.status == "Late").length,
      "Leave": _attendanceRecords.where((element) => element.status == "Leave").length,
      "Absent": _attendanceRecords.where((element) => element.status == "Absent").length,
      "Holiday": _attendanceRecords.where((element) => element.status == "Holiday").length
    };

    _isLoading = false;
    notifyListeners();
  }
  void clearAttendanceData(){
    _attendanceRecords = [];
    notifyListeners();
  }

}