class LeaveBalance {

   int casual = 0;
   int compensatory = 0;
   double earned = 0;
   int sick = 0;

  LeaveBalance({this.casual=0, this.compensatory = 0, this.earned = 0, this.sick = 0});

  LeaveBalance.fromJson(Map<String, dynamic> json) {
    casual = int.parse(json['CASUAL']??'0');
    compensatory = int.parse(json['COMPENSATORY']??'0');
    earned = double.parse(json['EARNED']??'0');
    sick = int.parse(json['SICK']??'0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CASUAL'] = casual;
    data['COMPENSATORY'] = compensatory;
    data['EARNED'] = earned;
    data['SICK'] = sick;
    return data;
  }

   @override
  String toString() {
    return 'LeaveBalance{casual: $casual, compensatory: $compensatory, earned: $earned, sick: $sick}';
  }
}