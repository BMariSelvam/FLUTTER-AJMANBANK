class PendingListModel {
  PendingListModel({
      this.batchId, 
      this.batchRunId, 
      this.fileName, 
      this.fileType, 
      this.statusCode, 
      this.statusDesc, 
      this.uploadedOn,
      this.uploadedBy,
    this.rejectedOn,
    this.rejectedBy,
      this.serialNo,
     this.batchRefNo,this.totalAmount});

  PendingListModel.fromJson(dynamic json) {
    batchId = json['batchId'];
    batchRunId = json['batchRunId'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    statusCode = json['statusCode'];
    statusDesc = json['statusDesc'];
    uploadedOn = json['uploadedOn'];
    uploadedBy = json['uploadedBy'];
    serialNo = json['serialNo'];
    batchRefNo = json['batchRefNo'];
    totalAmount = json['totalAmount'];
    approvedBy = json['approvedBy'];
    approvedOn = json['approvedOn'];
    rejectReason = json['rejectReason'];
    rejectedOn = json['rejectedOn'];
    rejectedBy = json['rejectedBy'];
  }
  int? batchId;
  int? batchRunId;
  String? fileName;
  String? fileType;
  String? statusCode;
  String? statusDesc;
  String? uploadedOn;
  String? uploadedBy;
  String? serialNo;
  String? batchRefNo;
  String? totalAmount;
  String? approvedBy;
  String? approvedOn;
  String? rejectReason;
  String? approveLength;
  String? pendingLength;
  String? rejectedLength;
  String? processLength;
  String? failedLength;
  String? rejectedOn;
  String? rejectedBy;

  bool isOpen = false;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['batchId'] = batchId;
    map['batchRunId'] = batchRunId;
    map['fileName'] = fileName;
    map['fileType'] = fileType;
    map['statusCode'] = statusCode;
    map['statusDesc'] = statusDesc;
    map['uploadedOn'] = uploadedOn;
    map['uploadedBy'] = uploadedBy;
    map['serialNo'] = serialNo;
    map['batchRefNo'] = batchRefNo;
    map['totalAmount'] = totalAmount;
    map['approvedOn'] = approvedOn;
    map['approvedBy'] = approvedBy;
    map['rejectReason'] = rejectReason;
    map['rejectedOn'] = rejectedOn;
    map['rejectedBy'] = rejectedBy;
    return map;
  }

}