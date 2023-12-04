class UpdateMpinModel {
  UpdateMpinModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.vCorporateId, 
      this.vLoginId, 
      this.oldMPIN, 
      this.mpin, 
      this.languageCode, 
      this.ipAddr, 
      this.vOSName, 
      this.vDeviceId, 
      this.deviceType, 
      this.requestFlag,});

  UpdateMpinModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    vCorporateId = json['vCorporateId'];
    vLoginId = json['vLoginId'];
    oldMPIN = json['oldMPIN'];
    mpin = json['MPIN'];
    languageCode = json['languageCode'];
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
  String? oldMPIN;
  String? mpin;
  String? languageCode;
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
    map['oldMPIN'] = oldMPIN;
    map['MPIN'] = mpin;
    map['languageCode'] = languageCode;
    map['ipAddr'] = ipAddr;
    map['vOSName'] = vOSName;
    map['vDeviceId'] = vDeviceId;
    map['deviceType'] = deviceType;
    map['requestFlag'] = requestFlag;
    return map;
  }

}