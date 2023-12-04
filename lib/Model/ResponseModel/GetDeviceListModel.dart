class GetDeviceListModel {
  GetDeviceListModel({
      this.loginId, 
      this.deviceId, 
      this.vDeviceModelName, 
      this.registerDate,
      this.os, 
      this.isLoggedIn,
      this.isVerified,
      this.isRegistered,});

  GetDeviceListModel.fromJson(dynamic json) {
    loginId = json['loginId'];
    deviceId = json['deviceId'];
    vDeviceModelName = json['deviceModelName'];
    registerDate = json['registerDate'];
    os = json['os'];
    isLoggedIn = json['isLoggedIn'];
    isVerified = json['isVerified'];
    isRegistered = json['isRegistered'];
  }
  String? loginId;
  String? deviceId;
  String? vDeviceModelName;
  String? registerDate;
  String? os;
  String? isLoggedIn;
  String? isVerified;
  bool? isRegistered;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loginId'] = loginId;
    map['deviceId'] = deviceId;
    map['vDeviceModelName'] = vDeviceModelName;
    map['registerDate'] = registerDate;
    map['os'] = os;
    map['isLoggedIn'] = isLoggedIn;
    map['isVerified'] = isVerified;
    map['isRegistered'] = isRegistered;
    return map;
  }

}

