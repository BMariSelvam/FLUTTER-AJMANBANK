class OtpInfo {
  OtpInfo({
      this.otpValue, 
      this.otpKey, 
      this.otpId,});

  OtpInfo.fromJson(dynamic json) {
    otpValue = json['otpValue'];
    otpKey = json['otpKey'];
    otpId = json['otpId'];
  }
  String? otpValue;
  String? otpKey;
  int? otpId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otpValue'] = otpValue;
    map['otpKey'] = otpKey;
    map['otpId'] = otpId;
    return map;
  }

}