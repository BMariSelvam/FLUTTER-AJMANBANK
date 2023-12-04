class OtpInfo {
  OtpInfo({
      this.otpId, 
      this.otpValue,});

  OtpInfo.fromJson(dynamic json) {
    otpId = json['otpId'];
    otpValue = json['otpValue'];
  }
  String? otpId;
  String? otpValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otpId'] = otpId;
    map['otpValue'] = otpValue;
    return map;
  }

}