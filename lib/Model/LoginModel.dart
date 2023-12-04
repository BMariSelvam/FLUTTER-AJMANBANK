class LoginModel {
  LoginModel({
      this.msgSourceChannelID, 
      this.accessToken, 
      this.reqRefNo, 
      this.gcifID, 
      this.corpId, 
      this.loginId, 
      this.password, 
      this.mpin, 
      this.languageCode, 
      this.location, 
      this.ipAddr, 
      this.os, 
      this.deviceId, 
      this.deviceType, 
      this.appName, 
      this.appVersionCode, 
      this.requestFlag,});

  LoginModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    accessToken = json['accessToken'];
    reqRefNo = json['reqRefNo'];
    gcifID = json['gcifID'];
    corpId = json['corpId'];
    loginId = json['loginId'];
    password = json['password'];
    mpin = json['MPIN'];
    languageCode = json['languageCode'];
    location = json['location'];
    ipAddr = json['ipAddr'];
    os = json['os'];
    deviceId = json['deviceId'];
    deviceType = json['deviceType'];
    appName = json['appName'];
    appVersionCode = json['appVersionCode'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? accessToken;
  String? reqRefNo;
  String? gcifID;
  String? corpId;
  String? loginId;
  String? password;
  String? mpin;
  String? languageCode;
  String? location;
  String? ipAddr;
  String? os;
  String? deviceId;
  String? deviceType;
  String? appName;
  String? appVersionCode;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['accessToken'] = accessToken;
    map['reqRefNo'] = reqRefNo;
    map['gcifID'] = gcifID;
    map['corpId'] = corpId;
    map['loginId'] = loginId;
    map['vPassword'] = password;
    map['MPIN'] = mpin;
    map['languageCode'] = languageCode;
    map['location'] = location;
    map['ipAddr'] = ipAddr;
    map['os'] = os;
    map['deviceId'] = deviceId;
    map['deviceType'] = deviceType;
    map['appName'] = appName;
    map['appVersionCode'] = appVersionCode;
    map['requestFlag'] = requestFlag;
    return map;
  }

}