import 'UserInfoVo.dart';

class UserModel {
  UserModel({
      this.userInfoVO, 
      this.statusCode, 
      this.statusDesc,});

  UserModel.fromJson(dynamic json) {
    userInfoVO = json['userInfoVO'] != null ? UserInfoVo.fromJson(json['userInfoVO']) : null;
    statusCode = json['statusCode'];
    statusDesc = json['statusDesc'];
  }
  UserInfoVo? userInfoVO;
  String? statusCode;
  String? statusDesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userInfoVO != null) {
      map['userInfoVO'] = userInfoVO?.toJson();
    }
    map['statusCode'] = statusCode;
    map['statusDesc'] = statusDesc;
    return map;
  }

}