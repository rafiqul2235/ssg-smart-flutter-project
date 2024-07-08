import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:ssg_smart2/data/model/response/attendance_sheet_model.dart';
import 'package:ssg_smart2/data/model/response/base/api_response.dart';
import 'package:ssg_smart2/data/repository/attendance_repo.dart';

import '../data/model/response/attendance_summary_model.dart';

class AttendanceProvider with ChangeNotifier{
  final AttendanceRepo attendanceRepo;
  AttendanceProvider({required this.attendanceRepo});

  List<AttendanceSheet> _attendanceRecords = [];
  List<AttendanceSheet> get attendanceRecords => _attendanceRecords;

  List<AttendanceSummaryModel> _attendanceSummary = [];
  List<AttendanceSummaryModel> get attendanceSummary => _attendanceSummary;

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


  //for summary
  Future<void> fetchAttendanceSummary(String empId, String fromDate, String toDate, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendanceSummary = await attendanceRepo.attendanceSummary(empId, fromDate, toDate, status);
    } catch (e) {
      print('Error fetching attendance summary: $e');
      _attendanceRecords = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}