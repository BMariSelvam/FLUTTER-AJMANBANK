class AccountListModel {
  AccountListModel({
      this.wfid, 
      this.custID, 
      this.accCifID, 
      this.cifID, 
      this.accID, 
      this.accNo, 
      this.accName, 
      this.accStatus, 
      this.prdId, 
      this.accLvl, 
      this.custId, 
      this.statusCode, 
      this.iban,});

  AccountListModel.fromJson(dynamic json) {
    wfid = json['WFID'];
    custID = json['custID'];
    accCifID = json['accCifID'];
    cifID = json['cifID'];
    accID = json['accID'];
    accNo = json['accNo'];
    accName = json['accName'];
    accStatus = json['accStatus'];
    prdId = json['prdId'];
    accLvl = json['accLvl'];
    custId = json['custId'];
    statusCode = json['statusCode'];
    iban = json['iban'];
  }
  int? wfid;
  int? custID;
  int? accCifID;
  int? cifID;
  int? accID;
  String? accNo;
  String? accName;
  String? accStatus;
  int? prdId;
  int? accLvl;
  int? custId;
  int? statusCode;
  String? iban;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['WFID'] = wfid;
    map['custID'] = custID;
    map['accCifID'] = accCifID;
    map['cifID'] = cifID;
    map['accID'] = accID;
    map['accNo'] = accNo;
    map['accName'] = accName;
    map['accStatus'] = accStatus;
    map['prdId'] = prdId;
    map['accLvl'] = accLvl;
    map['custId'] = custId;
    map['statusCode'] = statusCode;
    map['iban'] = iban;
    return map;
  }

}