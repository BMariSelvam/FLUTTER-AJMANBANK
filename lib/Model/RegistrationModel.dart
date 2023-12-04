class RegistrationModel {
  RegistrationModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.reqRefNo, 
      this.vCorporateId, 
      this.vGcifNo, 
      this.vLoginId, 
      this.password, 
      this.location, 
      this.vOSName, 
      this.vDeviceId, 
      this.vDeviceModelName, 
      this.appVersionCode, 
      this.requestFlag,});

  RegistrationModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    reqRefNo = json['reqRefNo'];
    vCorporateId = json['vCorporateId'];
    vGcifNo = json['vGcifNo'];
    vLoginId = json['vLoginId'];
    password = json['vPassword'];
    location = json['location'];
    vOSName = json['vOSName'];
    vDeviceId = json['vDeviceId'];
    vDeviceModelName = json['vDeviceModelName'];
    appVersionCode = json['appVersionCode'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? reqRefNo;
  String? vCorporateId;
  String? vGcifNo;
  String? vLoginId;
  String? password;
  String? location;
  String? vOSName;
  String? vDeviceId;
  String? vDeviceModelName;
  String? appVersionCode;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['reqRefNo'] = reqRefNo;
    map['vCorporateId'] = vCorporateId;
    map['vGcifNo'] = vGcifNo;
    map['vLoginId'] = vLoginId;
    map['vPassword'] = password;
    map['location'] = location;
    map['vOSName'] = vOSName;
    map['vDeviceId'] = vDeviceId;
    map['vDeviceModelName'] = vDeviceModelName;
    map['appVersionCode'] = appVersionCode;
    map['requestFlag'] = requestFlag;
    return map;
  }

}