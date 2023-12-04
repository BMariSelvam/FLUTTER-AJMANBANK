class UserInfoModel {
  UserInfoModel({
      this.msgSourceChannelID, 
      this.vSecureToken, 
      this.reqRefNo, 
      this.vCorporateId, 
      this.vLoginId, 
      this.fileReferenceNo, 
      this.vDeviceId, 
      this.requestFlag,
    this.vCheckerRemarks,
    this.vEmailId,
    this.vGcifNo,
    this.appVersionCode,
    this.vOSName,
  this.vBatchRunId});

  UserInfoModel.fromJson(dynamic json) {
    msgSourceChannelID = json['msgSourceChannelID'];
    vSecureToken = json['vSecureToken'];
    reqRefNo = json['reqRefNo'];
    vCorporateId = json['vCorporateId'];
    vLoginId = json['vLoginId'];
    fileReferenceNo = json['fileReferenceNo'];
    vDeviceId = json['vDeviceId'];
    requestFlag = json['requestFlag'];
    vBatchRunId = json['vBatchRunId'];
    vCheckerRemarks = json['vCheckerRemarks'];
    vGcifNo = json['vGcifNo'];
    vEmailId = json['vEmailId'];
    vOSName = json['vOSName'];
    appVersionCode = json['appVersionCode'];
  }
  String? msgSourceChannelID;
  String? vSecureToken;
  String? reqRefNo;
  String? vCorporateId;
  String? vLoginId;
  String? fileReferenceNo;
  String? vDeviceId;
  String? requestFlag;
  String? vBatchRunId;
  String? vCheckerRemarks;
  String? vGcifNo;
  String? vEmailId;
  String? vOSName;
String? appVersionCode;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgSourceChannelID'] = msgSourceChannelID;
    map['vSecureToken'] = vSecureToken;
    map['reqRefNo'] = reqRefNo;
    map['vCorporateId'] = vCorporateId;
    map['vLoginId'] = vLoginId;
    map['fileReferenceNo'] = fileReferenceNo;
    map['vDeviceId'] = vDeviceId;
    map['requestFlag'] = requestFlag;
    map['vBatchRunId'] = vBatchRunId;
    map['vCheckerRemarks'] = vCheckerRemarks;
    map['vGcifNo'] = vGcifNo;
    map['vEmailId'] = vEmailId;
    map['vOSName'] = vOSName;
    map['appVersionCode'] = appVersionCode;
    return map;
  }

}