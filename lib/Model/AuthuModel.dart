class AuthuModel {
  AuthuModel({
      this.accessToken, 
      this.tokenType, 
      this.expiresIn, 
      this.scope,});

  AuthuModel.fromJson(dynamic json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    scope = json['scope'];
  }
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? scope;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    map['expires_in'] = expiresIn;
    map['scope'] = scope;
    return map;
  }

}