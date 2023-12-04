class OtpUserInfoVO {
  bool isMpinCreated;
  String? msgSourceChannelID;
  String? reqRefNo;
  String? requestFlag;
  String? vCorporateId;
  String? vDeviceId;
  String? vGcifNo;
  String? vLoginId;
  String? vMobileNo;
  String? vOSName;
  String? vSecureToken;

  OtpUserInfoVO({
    required this.isMpinCreated,
    required this.msgSourceChannelID,
    required this.reqRefNo,
    required this.requestFlag,
    required this.vCorporateId,
    required this.vDeviceId,
    required this.vGcifNo,
    required this.vLoginId,
    required this.vMobileNo,
    required this.vOSName,
    required this.vSecureToken,
  });

  factory OtpUserInfoVO.fromJson(Map<String, dynamic> json) {
    return OtpUserInfoVO(
      isMpinCreated: json['isMpinCreated'],
      msgSourceChannelID: json['msgSourceChannelID'],
      reqRefNo: json['reqRefNo'],
      requestFlag: json['requestFlag'],
      vCorporateId: json['vCorporateId'],
      vDeviceId: json['vDeviceId'],
      vGcifNo: json['vGcifNo'],
      vLoginId: json['vLoginId'],
      vMobileNo: json['vMobileNo'],
      vOSName: json['vOSName'],
      vSecureToken: json['vSecureToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMpinCreated': isMpinCreated,
      'msgSourceChannelID': msgSourceChannelID,
      'reqRefNo': reqRefNo,
      'requestFlag': requestFlag,
      'vCorporateId': vCorporateId,
      'vDeviceId': vDeviceId,
      'vGcifNo': vGcifNo,
      'vLoginId': vLoginId,
      'vMobileNo': vMobileNo,
      'vOSName': vOSName,
      'vSecureToken': vSecureToken,
    };
  }
}