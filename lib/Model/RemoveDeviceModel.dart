class RemoveDeviceModel {
  RemoveDeviceModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.vMobileNo, 
      this.vCorporateId, 
      this.vLoginID, 
      this.vDeviceId, 
      this.requestFlag,});

  RemoveDeviceModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    vMobileNo = json['vMobileNo'];
    vCorporateId = json['vCorporateId'];
    vLoginID = json['vLoginId'];
    vDeviceId = json['vDeviceId'];
    requestFlag = json['requestFlag'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? vMobileNo;
  String? vCorporateId;
  String? vLoginID;
  String? vDeviceId;
  String? requestFlag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['vMobileNo'] = vMobileNo;
    map['vCorporateId'] = vCorporateId;
    map['vLoginId'] = vLoginID;
    map['vDeviceId'] = vDeviceId;
    map['requestFlag'] = requestFlag;
    return map;
  }

}