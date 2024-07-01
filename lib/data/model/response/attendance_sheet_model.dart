class AttendanceSheetModel {

   String sl_num ="";
   String date ="";
   String in_time ="";
   String out_time ="";
   String w_hours ="";
   String status ="";



  AttendanceSheetModel({
    this.sl_num='',this.date='',this.in_time='',this.out_time='',this.w_hours='',this.status=''
  });
//parssing method
  AttendanceSheetModel.fromJson(Map<String, dynamic> json) {
    sl_num = json['SRL_NUM']??'';
    date = json['WORKING_DATE']??'';
    in_time = json['ACT_IN_TIME']??'';
    out_time = json['ACT_OUT_TIME']??'';
    w_hours = json['W_HOUR']??'';
    status = json['STATUS']??'';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SRL_NUM'] = sl_num;
    data['WORKING_DATE'] = date;
    data['ACT_IN_TIME'] = in_time;
    data['ACT_OUT_TIME'] = out_time;
    data['W_HOUR'] = w_hours;
    data['STATUS'] = status;
    return data;
  }

  @override
  String toString() {
    return 'AttendanceSheetModel{sl_num: $sl_num, date: $date, in_time: $in_time, out_time: $out_time, w_hours: $w_hours, status: $status}';
  }
}