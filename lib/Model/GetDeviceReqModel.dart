class GetDeviceReqModel {
  GetDeviceReqModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.reqRefNo, 
      this.vGcifNo, 
      this.vCorporateId, 
      this.gloinId,
      this.vMobileNo, 
      this.vEmailId, 
      this.vOSName, 
      this.vDeviceId, 
      this.appVersionCode, 
      this.requestFlag,});

  GetDeviceReqModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    reqRefNo = json['reqRefNo'];
    vGcifNo = json['vGcifNo'];
    vCorporateId = json['vCorporateId'];
    gloinId = json['vLoginId'];
    vMobileNo = json['vMobileNo'];
    vEmailId = json['vEmailId'];
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
  String? vMobileNo;
  String? vEmailId;
  String? vOSName;
  String? vDeviceId;
  String? appVersionCode;
  String? requestFlag;
  String? gloinId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['reqRefNo'] = reqRefNo;
    map['vGcifNo'] = vGcifNo;
    map['vCorporateId'] = vCorporateId;
    map['vLoginId'] = gloinId;
    map['vMobileNo'] = vMobileNo;
    map['vEmailId'] = vEmailId;
    map['vOSName'] = vOSName;
    map['vDeviceId'] = vDeviceId;
    map['appVersionCode'] = appVersionCode;
    map['requestFlag'] = requestFlag;
    return map;
  }

}