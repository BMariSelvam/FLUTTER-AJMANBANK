class PageInfoModel {
  PageInfoModel({
    this.fromDate,
    this.toDate,
    this.creditDebit,
    this.amountFilter,
    this.amount,
    this.pageNo,
    this.requestId,
    this.rowsPerPage,
    this.fromRecord,
    this.fromAmount,
    this.toAmount,
    this.recordCount,
  });

  PageInfoModel.fromJson(dynamic json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    fromAmount = json['fromAmount'];
    toAmount = json['toAmount'];
    creditDebit = json['creditDebit'];
    amountFilter = json['amountFilter'];
    amount = json['amount'];
    pageNo = json['pageNo'];
    requestId = json['requestId'];
    rowsPerPage = json['rowsPerPage'];
    fromRecord = json['fromRecord'];
    recordCount = json['recordCount'];
  }

  String? fromDate;
  String? toDate;
  String? fromAmount;
  String? toAmount;
  String? creditDebit;
  String? amountFilter;
  String? amount;
  String? pageNo;
  String? requestId;
  String? rowsPerPage;
  String? fromRecord;
  String? recordCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fromDate'] = fromDate;
    map['toDate'] = toDate;
    map['creditDebit'] = creditDebit;
    map['amountFilter'] = amountFilter;
    map['amount'] = amount;
    map['pageNo'] = pageNo;
    map['requestId'] = requestId;
    map['rowsPerPage'] = rowsPerPage;
    map['fromRecord'] = fromRecord;
    map['recordCount'] = recordCount;
    map['toAmount'] = toAmount;
    map['fromAmount'] = fromAmount;
    return map;
  }
}
