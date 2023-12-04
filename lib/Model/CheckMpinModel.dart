class CheckMpinModel {
  CheckMpinModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.vCorporateId, 
      this.vLoginId, 
      this.vGcifNo, 
      this.languageCode, 
      this.location, 
      this.ipAddr, 
      this.vOSName, 
      this.vDeviceId, 
      this.deviceType, 
      this.requestFlag,});


  CheckMpinModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['SecureToken'];
    vCorporateId = json['CorporateId'];
    vLoginId = json['LoginId'];
    vGcifNo = json['GcifNo'];
    languageCode = json['languageCode'];
    location = json['location'];
    ipAddr = json['ipAddr'];
    vOSName = json['OSName'];
    vDeviceId = json['DeviceId'];
    deviceType = json['deviceType'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? vCorporateId;
  String? vLoginId;
  String? vGcifNo;
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
    map['SecureToken'] = vSecureToken;
    map['CorporateId'] = vCorporateId;
    map['LoginId'] = vLoginId;
    map['GcifNo'] = vGcifNo;
    map['languageCode'] = languageCode;
    map['location'] = location;
    map['ipAddr'] = ipAddr;
    map['OSName'] = vOSName;
    map['DeviceId'] = vDeviceId;
    map['deviceType'] = deviceType;
    map['requestFlag'] = requestFlag;
    return map;
  }

}