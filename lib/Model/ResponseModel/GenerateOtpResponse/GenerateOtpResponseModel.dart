import 'OtpInfo.dart';

class GenerateOtpResponseModel {
  GenerateOtpResponseModel({
      this.otpInfo, 
      this.statusCode, 
      this.statusDesc,});

  GenerateOtpResponseModel.fromJson(dynamic json) {
    otpInfo = json['otpInfo'] != null ? OtpInfo.fromJson(json['otpInfo']) : null;
    statusCode = json['statusCode'];
    statusDesc = json['statusDesc'];
  }
  OtpInfo? otpInfo;
  String? statusCode;
  String? statusDesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (otpInfo != null) {
      map['otpInfo'] = otpInfo?.toJson();
    }
    map['statusCode'] = statusCode;
    map['statusDesc'] = statusDesc;
    return map;
  }

}