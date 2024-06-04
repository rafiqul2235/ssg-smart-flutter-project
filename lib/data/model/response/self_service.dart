class SelfServiceModel {

  String? reportHeaderId;
  String? applicationType;
  String? statusFlg;
  String? createdDate;
  String? realTime;

  SelfServiceModel({this.reportHeaderId = '', this.applicationType = '', this.statusFlg = '',
      this.createdDate = '', this.realTime = ''});

  SelfServiceModel.fromJson(Map<String, dynamic> json) {
    reportHeaderId = json['REPORT_HEADER_ID'];
    applicationType = json['APPLICATION_TYPE'];
    statusFlg = json['STATUS_FLG'];
    createdDate = json['CREATION_DATE'];
    realTime = json['REAL_TIME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['REPORT_HEADER_ID'] = reportHeaderId;
    json['APPLICATION_TYPE'] = applicationType;
    json['STATUS_FLG'] = statusFlg;
    json['CREATION_DATE'] = createdDate;
    json['REAL_TIME'] = realTime;
    return json;
  }

  @override
  String toString() {
    return 'SelfServiceModel{reportHeaderId: $reportHeaderId, applicationType: $applicationType, statusFlg: $statusFlg, createdDate: $createdDate, realTime: $realTime}';
  }

}