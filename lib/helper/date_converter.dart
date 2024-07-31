import 'package:intl/intl.dart';

class DateConverter {

  static int differanceTwoDate(String sfromDate, String stoDate){
    var inputFormat = DateFormat("dd-MM-yyyy");
    var  fromDate = inputFormat.parse(sfromDate);
    var  toDate = inputFormat.parse(stoDate);
    var difference = toDate.difference(fromDate).inDays;
    return difference;
  }

  static String checkDate(String strDateTime){

    var inputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = DateTime(now.year, now.month, now.day - 1);
    var tomorrow = DateTime(now.year, now.month, now.day + 1);

    try{
      var dateToCheck = inputFormat.parse(strDateTime);
      var aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
      if(aDate == today) {
        return 'Today';
      } else if(aDate == yesterday) {
        return 'Yesterday';
      } else if (aDate == tomorrow) {
        return 'Tomorrow';
      }else{
        return 'Others';
      }
    }catch(e){}

    return 'Others';

  }

  static String findCurrentMonth(){
    try{
      return DateFormat('MMMM').format(DateTime.now());
    }catch(e){
      return '';
    }
  }

  static int findMonthDay(String strDateTime){
    var inputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
    try{
      var date = inputFormat.parse(strDateTime);
      return date.day;
    }catch(e){
      return 0;
    }
  }

  static int countRestOfMonthDay(DateTime date){
    var now = DateTime.now();
    var nextMonthDate = DateTime(date.year, date.month+1, 0).toString();
    var next = DateTime.parse(nextMonthDate);
    if(date.month == now.month){
      return next.day - now.day;
    }else{
      return next.day - date.day;
    }
  }

  static String getMonth(int monthIndex){
    List<String> months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return months[monthIndex -1];
  }

  static Map<String,DateTime> getMonthNameList(int month, int year){
    List<String> months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    Map<String,DateTime> mothMap = {};
    DateTime dateTime = DateTime.now();
    for(int i = 0; i<12;i++){
      DateTime currentDate = DateTime.now();
      int index = ((month-1) + i) % 12;
      if(index >= (month-1)){
        dateTime = DateTime(currentDate.year, index+1);
      }else{
         dateTime = DateTime(currentDate.year+1, index+1);
      }
      String monthV = months[index];
      mothMap.putIfAbsent('$monthV-${dateTime.year}', () => dateTime);
    }
    return mothMap;
  }

  static bool checkBirthday(String strDateTime){

    var inputFormat = DateFormat("dd-MM-yyyy");
    var now = DateTime.now();
    int month = now.month;
    int day = now.day;
    try{
      var dateToCheck = inputFormat.parse(strDateTime);
      if(dateToCheck.month == month && dateToCheck.day == day) {
        return true;
      }else{
        return false;
      }
    }catch(e){}

    return false;

  }

  static String getTaDaBillFromDate(String billMonth, String fromDate){
    String result = '';
    if(fromDate !=null && fromDate.isNotEmpty){
      return reverseStringToStringDateTime(fromDate);
    }else{
      try{
        var inputFormat = DateFormat("MMM-yy");
        DateTime dateTime = inputFormat.parse(billMonth);
        result =  DateFormat('dd-MM-yyyy').format(DateTime(dateTime.year, dateTime.month,1));
      }catch(e){}
    }
    return result;
  }

  static String getTaDaBillToDate(String billMonth,String toDate){
    String result = '';
    if(toDate !=null && toDate.isNotEmpty){
      return reverseStringToStringDateTime(toDate);
    }else{
      try{
        var inputFormat = DateFormat("MMM-yy");
        DateTime dateTime = inputFormat.parse(billMonth);
        result = DateFormat('dd-MM-yyyy').format(DateTime(dateTime.year, dateTime.month + 1, 0));
      }catch(e){}
    }
    return result;
  }

  static String getFirstDateMonth(){
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month,1);
    return DateFormat('dd-MM-yyyy').format(firstDayOfMonth);
  }

  static String getLastDateMonth(){
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return DateFormat('dd-MM-yyyy').format(lastDayOfMonth);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String getToday() {
    return DateFormat('dd-MMM-yyyy').format(DateTime.now());
  }

  static DateTime estimatedDateBy(String dateTime) {
    try{
      var inputFormat = DateFormat("dd-MM-yyyy");
      return inputFormat.parse(dateTime);
    }catch(e){}
    return DateTime.now();
  }

  static String estimatedTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String convertDateTo(String strDate, String strInputFormat, String strOutputFormat) {
    if(strDate == null || strDate.isEmpty) return '';
    try{
      var inputFormat = DateFormat(strInputFormat);
      var outputFormat = DateFormat(strOutputFormat);
      return outputFormat.format(inputFormat.parse(strDate));
    }catch(e){}
    return '';
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
  }

  static String convertStringToStringDate(String? dateTime) {
    if(dateTime == null) return '';
    try{
      var inputFormat = DateFormat("dd-MM-yyyy");
      var outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String convertStringToStringDateTime(String dateTime) {
    if(dateTime == null) return '';
    try{
      var inputFormat = DateFormat("dd-MM-yyyy hh:mm a");
      var outputFormat = DateFormat("yyyy-MM-dd hh:mm a");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String reverseStringToStringDateTime2(String? dateTime) {
    if(dateTime == null || dateTime.isEmpty) return '';
    try{
      var inputFormat = DateFormat("dd-MM-yyyy");
      var outputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String reverseStringToStringDateTime3(String? dateTime) {
    if(dateTime == null || dateTime.isEmpty) return '';
    try{
      var inputFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
      var outputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String reverseStringToStringDateTime4(String dateTime) {
    if(dateTime == null || dateTime.isEmpty) return '';
    try{
      var inputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
       var outputFormat = DateFormat("dd-MM-yyyy hh:mm a");
      //var outputFormat = DateFormat("dd-MM-yyyy");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String reverseStringToStringDateTime(String dateTime) {
    if(dateTime == null || dateTime.isEmpty) return '';
    try{
      var inputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
     // var outputFormat = DateFormat("dd-MM-yyyy hh:mm a");
      var outputFormat = DateFormat("dd-MM-yyyy");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String reverseStringToStringDate(String? dateTime) {
    if(dateTime == null || dateTime.isEmpty) return '';
    try{
      var inputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
      var outputFormat = DateFormat("dd-MM-yy");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static String reverseStringToStringTime(String dateTime) {
    if(dateTime == null || dateTime.isEmpty) return '';
    try{
      var inputFormat = DateFormat("yyyy-MM-ddThh:mm:ss");
      var outputFormat = DateFormat("h:mm a");
      return outputFormat.format(inputFormat.parse(dateTime));
    }catch(e){}
    return '';
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime).toLocal();
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('h:mm a | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('HH:mm').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd:MM:yy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toUtc());
  }

  static String isoStringToLocalDateAndTime(String dateTime) {
    return DateFormat('dd-MMM-yyyy hh:mm a').format(isoStringToLocalDate(dateTime));
  }

}
