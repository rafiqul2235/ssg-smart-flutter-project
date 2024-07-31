class AppUpdateInfo {
  int? id;
  String? appVersionName = '';
  int? appVersionCode = 0;
  bool? isSoftUpdate = true;
  String? releaseLocation;
  String? releaseDate;
  bool? isActive = false;

  AppUpdateInfo({this.id, this.appVersionName, this.appVersionCode = 0,
      this.isSoftUpdate, this.releaseLocation, this.releaseDate, this.isActive});

  AppUpdateInfo.fromJson(Map<String, dynamic>? json) {
    if(json == null) return;
    id = json['id']??0;
    appVersionName = json['appVersionName']??'';
    appVersionCode = json['appVersionCode']??0;
    isSoftUpdate = json['isSoftUpdate']??true;
    releaseLocation = json['releaseLocation']??'';
    releaseDate = json['releaseDate'];
    isActive = json['isActive']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appVersionName'] = appVersionName;
    data['appVersionCode'] = appVersionCode;
    data['isSoftUpdate'] = isSoftUpdate;
    data['releaseLocation'] = releaseLocation;
    data['releaseDate'] = releaseDate;
    data['isActive'] = isActive;
    return data;
  }
}
