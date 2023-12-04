class UserInfoVo {
  UserInfoVo({
      this.vUserId, 
      this.vLoginId, 
      this.vEmailId, 
      this.vCrtIp, 
      this.vCustIdType, 
      this.vWorkflowID, 
      this.vFUNCTIONALITYID, 
      this.vRoleID, 
      this.vFunctinalityID, 
      this.vCurrworkflowStatusId, 
      this.vUplId, 
      this.vCorporateId, 
      this.vVatView, 
      this.vVatDownload, 
      this.vSiSetup, 
      this.vSiApproval, 
      this.vSiMonitoring, 
      this.vSiManualSubmission, 
      this.menuid, 
      this.vSecureToken, 
      this.vDeviceId, 
      this.reqRefNo, 
      this.vOSName, 
      this.mobileNoVerified, 
      this.vFailedPwdAttemptCount,});

  UserInfoVo.fromJson(dynamic json) {
    vUserId = json['vUserId'];
    vLoginId = json['vLoginId'];
    vEmailId = json['vEmailId'];
    vCrtIp = json['vCrtIp'];
    vCustIdType = json['vCustIdType'];
    vWorkflowID = json['vWorkflowID'];
    vmobile = json['vMobileNo'];
    vFUNCTIONALITYID = json['vFUNCTIONALITYID'];
    vRoleID = json['vRoleID'];
    vFunctinalityID = json['vFunctinalityID'];
    vCurrworkflowStatusId = json['vCurrworkflowStatusId'];
    vUplId = json['vUplId'];
    vCorporateId = json['vCorporateId'];
    vVatView = json['vVatView'];
    vVatDownload = json['vVatDownload'];
    vSiSetup = json['vSiSetup'];
    vSiApproval = json['vSiApproval'];
    vSiMonitoring = json['vSiMonitoring'];
    vSiManualSubmission = json['vSiManualSubmission'];
    menuid = json['MENUID'];
    vSecureToken = json['vSecureToken'];
    vDeviceId = json['vDeviceId'];
    reqRefNo = json['reqRefNo'];
    vOSName = json['vOSName'];
    mobileNoVerified = json['mobileNoVerified'];
    vFailedPwdAttemptCount = json['vFailedPwdAttemptCount'];
  }
  int? vUserId;
  String? vLoginId;
  String? vEmailId;
  String? vCrtIp;
  String? vCustIdType;
  String? vmobile;
  int? vWorkflowID;
  int? vFUNCTIONALITYID;
  int? vRoleID;
  int? vFunctinalityID;
  int? vCurrworkflowStatusId;
  int? vUplId;
  String? vCorporateId;
  bool? vVatView;
  bool? vVatDownload;
  bool? vSiSetup;
  bool? vSiApproval;
  bool? vSiMonitoring;
  bool? vSiManualSubmission;
  int? menuid;
  String? vSecureToken;
  String? vDeviceId;
  String? reqRefNo;
  String? vOSName;
  bool? mobileNoVerified;
  int? vFailedPwdAttemptCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vUserId'] = vUserId;
    map['vLoginId'] = vLoginId;
    map['vEmailId'] = vEmailId;
    map['vCrtIp'] = vCrtIp;
    map['vCustIdType'] = vCustIdType;
    map['vWorkflowID'] = vWorkflowID;
    map['vMobileNo'] = vmobile;
    map['vFUNCTIONALITYID'] = vFUNCTIONALITYID;
    map['vRoleID'] = vRoleID;
    map['vFunctinalityID'] = vFunctinalityID;
    map['vCurrworkflowStatusId'] = vCurrworkflowStatusId;
    map['vUplId'] = vUplId;
    map['vCorporateId'] = vCorporateId;
    map['vVatView'] = vVatView;
    map['vVatDownload'] = vVatDownload;
    map['vSiSetup'] = vSiSetup;
    map['vSiApproval'] = vSiApproval;
    map['vSiMonitoring'] = vSiMonitoring;
    map['vSiManualSubmission'] = vSiManualSubmission;
    map['MENUID'] = menuid;
    map['vSecureToken'] = vSecureToken;
    map['vDeviceId'] = vDeviceId;
    map['reqRefNo'] = reqRefNo;
    map['vOSName'] = vOSName;
    map['mobileNoVerified'] = mobileNoVerified;
    map['vFailedPwdAttemptCount'] = vFailedPwdAttemptCount;
    return map;
  }

}