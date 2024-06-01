class LoginModel {

  String? pincode;
  String? userName;
  String? password;
  String? userType;
  String? loginDevice;
  String? deviceType;
  String? deviceName;
  String? imeiNo;
  String? udid;
  String? fcmToken;
  String? currentVersionName;
  int? currentVersionCode;
  double? loginLatitude;
  double? loginLongitude;
  String? loginLocation;

  LoginModel({
      this.pincode,
      this.userName,
      this.password,
      this.userType,
      this.loginDevice,
      this.deviceType,
      this.deviceName,
      this.imeiNo,
      this.udid,
      this.fcmToken,
      this.currentVersionName,
      this.currentVersionCode,
      this.loginLatitude,
      this.loginLongitude,
      this.loginLocation});

  LoginModel.fromJson(Map<String, dynamic> json) {
    pincode = json['USER_ID'];
    userName = json['userName'];
    password = json['password'];
    userType = json['userType'];
    loginDevice = json['loginDevice'];
    deviceType = json['deviceType'];
    deviceName = json['deviceName'];
    imeiNo = json['imeiNo'];
    udid = json['udid'];
    fcmToken = json['fcmToken'];
    currentVersionName = json['currentVersionName'];
    currentVersionCode = json['currentVersionCode'];
    loginLatitude = json['loginLatitude'];
    loginLongitude = json['loginLongitude'];
    loginLocation = json['loginLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = userName;
    data['password']=  password;
    return data;
  }

  Map<String, dynamic> toLoginBodyJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = userName;
    data['password']=  password;
    return data;
  }

  @override
  String toString() {
    return 'LoginModel{pincode: $pincode, userName: $userName, password: $password, userType: $userType, loginDevice: $loginDevice, deviceType: $deviceType, deviceName: $deviceName, imeiNo: $imeiNo, udid: $udid, fcmToken: $fcmToken, currentVersionName: $currentVersionName, currentVersionCode: $currentVersionCode, loginLatitude: $loginLatitude, loginLongitude: $loginLongitude, loginLocation: $loginLocation}';
  }
}
