class MpinRegisterModel {
  MpinRegisterModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.vCorporateId, 
      this.vLoginId, 
      this.vGcifNo, 
      this.mpin, 
      this.languageCode, 
      this.location, 
      this.ipAddr, 
      this.vOSName, 
      this.vDeviceId, 
      this.deviceType, 
      this.requestFlag,});

  MpinRegisterModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    vCorporateId = json['vCorporateId'];
    vLoginId = json['vLoginId'];
    vGcifNo = json['vGcifNo'];
    mpin = json['MPIN'];
    languageCode = json['languageCode'];
    location = json['location'];
    ipAddr = json['ipAddr'];
    vOSName = json['vOSName'];
    vDeviceId = json['vDeviceId'];
    deviceType = json['deviceType'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? vCorporateId;
  String? vLoginId;
  String? vGcifNo;
  String? mpin;
  String? languageCode;
  String? location;
  String? ipAddr;
  String? vOSName;
  String? vDeviceId;
  String? deviceType;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['vCorporateId'] = vCorporateId;
    map['vLoginId'] = vLoginId;
    map['vGcifNo'] = vGcifNo;
    map['MPIN'] = mpin;
    map['languageCode'] = languageCode;
    map['location'] = location;
    map['ipAddr'] = ipAddr;
    map['vOSName'] = vOSName;
    map['vDeviceId'] = vDeviceId;
    map['deviceType'] = deviceType;
    map['requestFlag'] = requestFlag;
    return map;
  }

}