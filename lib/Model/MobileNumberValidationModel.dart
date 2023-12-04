class MobileNumberValidationModel {
  MobileNumberValidationModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.vMobileNo, 
      this.vCorporateId, 
      this.vLoginId, 
      this.vDeviceId, 
      this.requestFlag,});

  MobileNumberValidationModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    vMobileNo = json['vMobileNo'];
    vCorporateId = json['vCorporateId'];
    vLoginId = json['vLoginId'];
    vDeviceId = json['vDeviceId'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? vMobileNo;
  String? vCorporateId;
  String? vLoginId;
  String? vDeviceId;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['vMobileNo'] = vMobileNo;
    map['vCorporateId'] = vCorporateId;
    map['vLoginId'] = vLoginId;
    map['vDeviceId'] = vDeviceId;
    map['requestFlag'] = requestFlag;
    return map;
  }

}