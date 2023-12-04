class GenerateOtpModel {
  GenerateOtpModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.reqRefNo, 
      this.vMobileNo, 
      this.vGcifNo, 
      this.vCorporateId, 
      this.vLoginId, 
      this.vDeviceId, 
      this.requestFlag,});

  GenerateOtpModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    reqRefNo = json['reqRefNo'];
    vMobileNo = json['vMobileNo'];
    vGcifNo = json['vGcifNo'];
    vCorporateId = json['vCorporateId'];
    vLoginId = json['vLoginId'];
    vDeviceId = json['vDeviceId'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? reqRefNo;
  String? vMobileNo;
  String? vGcifNo;
  String? vCorporateId;
  String? vLoginId;
  String? vDeviceId;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['reqRefNo'] = reqRefNo;
    map['vMobileNo'] = vMobileNo;
    map['vGcifNo'] = vGcifNo;
    map['vCorporateId'] = vCorporateId;
    map['vLoginId'] = vLoginId;
    map['vDeviceId'] = vDeviceId;
    map['requestFlag'] = requestFlag;
    return map;
  }

}