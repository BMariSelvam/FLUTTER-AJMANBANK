class AcountStateMentReqModel {
  AcountStateMentReqModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.reqRefNo, 
      this.vGcifNo, 
      this.vCorporateId, 
      this.vAccountNo, 
      this.vLoginID, 
      this.vOSName, 
      this.vDeviceId, 
      this.appVersionCode, 
      this.requestFlag,});

  AcountStateMentReqModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    reqRefNo = json['reqRefNo'];
    vGcifNo = json['vGcifNo'];
    vCorporateId = json['vCorporateId'];
    vAccountNo = json['vAccountNo'];
    vLoginID = json['vLoginID'];
    vOSName = json['vOSName'];
    vDeviceId = json['vDeviceId'];
    appVersionCode = json['appVersionCode'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? reqRefNo;
  String? vGcifNo;
  String? vCorporateId;
  String? vAccountNo;
  String? vLoginID;
  String? vOSName;
  String? vDeviceId;
  String? appVersionCode;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['reqRefNo'] = reqRefNo;
    map['vGcifNo'] = vGcifNo;
    map['vCorporateId'] = vCorporateId;
    map['vAccountNo'] = vAccountNo;
    map['vLoginId'] = vLoginID;
    map['vOSName'] = vOSName;
    map['vDeviceId'] = vDeviceId;
    map['appVersionCode'] = appVersionCode;
    map['requestFlag'] = requestFlag;
    return map;
  }

}