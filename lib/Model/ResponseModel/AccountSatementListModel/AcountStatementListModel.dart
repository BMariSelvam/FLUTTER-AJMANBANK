class Transaction {
  final String valueDate;
  final String transDesc;
  final String referenceNo;
  final String postDate;
  final String transAmount;
  final String creditDebit;
  final String otherAmount1;
  final String otherAmount2;
  final String addDetails1;
  final String addDetails2;
  final String addDate1;
  final String addDate2;

  Transaction({
    required this.valueDate,
    required this.transDesc,
    required this.referenceNo,
    required this.postDate,
    required this.transAmount,
    required this.creditDebit,
    required this.otherAmount1,
    required this.otherAmount2,
    required this.addDetails1,
    required this.addDetails2,
    required this.addDate1,
    required this.addDate2,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      valueDate: json['valueDate'],
      transDesc: json['transDesc'],
      referenceNo: json['referenceNo'],
      postDate: json['postDate'],
      transAmount: json['transAmount'],
      creditDebit: json['creditDebit'],
      otherAmount1: json['otherAmount1'],
      otherAmount2: json['otherAmount2'],
      addDetails1: json['addDetails1'],
      addDetails2: json['addDetails2'],
      addDate1: json['addDate1'],
      addDate2: json['addDate2'],
    );
  }
}

