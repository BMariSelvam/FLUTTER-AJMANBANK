import 'package:ajmanbank/Helper/CommonFunction.dart';
import 'package:ajmanbank/Viewer/DashBoard/DashBoardTabBarScreen/Pending/pendingcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Helper/PonitValueallow.dart';
import '../../../../Helper/assets.dart';
import '../../../../Helper/colors.dart';
import '../../../../Helper/fonts.dart';
import '../../../../Helper/size.dart';
import 'package:intl/intl.dart';

import '../../../../Model/ListModel/PendingList.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  late PendingController _controller;
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = Get.put(PendingController());
    _scrollController.addListener(_scrollListener);
  }

  TextEditingController searchController = TextEditingController();
  List<PendingListModel> filteredList = [];

  String search = "";

  List<PendingListModel> filterList(String query) {
    return _controller.pendingListmodel.where((item) {
      return item.batchRefNo!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (_controller.currentPage <= _controller.totalPages &&
          !_controller.status.isLoadingMore) {
        await _controller.PendingList(
            _controller.fromDate, _controller.toDate, false, true, null, null);
      }
    }
  }

  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PendingController>(builder: (logic) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width(context) / 1.3,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                      onChanged: (String? value) {
                        setState(() {
                          search = value.toString();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    splashRadius: 20.0,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _showFiltter(context);
                    },
                    icon: Image.asset(Assets.filtration),
                  )
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: (_controller.PendingSize != 0)
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: search.isEmpty
                            ? _controller.pendingListmodel.length
                            : filterList(search).length,
                        itemBuilder: (context, index) {
                          final item = search.isEmpty
                              ? _controller.pendingListmodel[index]
                              : filterList(search)[index];
                          String? originalDateTimeString = item.uploadedOn;
                          DateTime parsedDateTime =
                              DateTime.parse(originalDateTimeString!);
                          return Column(
                            children: [
                              ExpansionTile(
                                title: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          item.isOpen = !item.isOpen;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'File Reference',
                                                  style: TextStyle(
                                                    fontFamily: MyFont.myFont,
                                                    fontSize: 15,
                                                    color: MyColors.darkGray,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '${item.batchRefNo}',
                                                  style: TextStyle(
                                                    fontFamily: MyFont.myFont,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color:
                                                        MyColors.primaryCustom,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Pending',
                                              style: TextStyle(
                                                fontFamily: MyFont.myFont,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: MyColors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      item.isOpen = !item.isOpen;
                                    });
                                  },
                                  icon: item.isOpen
                                      ? Image.asset(Assets.arrowUp)
                                      : Image.asset(Assets.arrowDown),
                                ),
                              ),
                              item.isOpen
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        color: MyColors.lightGray,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 10, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Serial No.',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      color: MyColors.darkGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item.serialNo}',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Amount',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      color: MyColors.darkGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    'AED ${item.totalAmount}',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Uploaded On',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      color: MyColors.darkGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${parsedDateTime.toLocal().toString().split('.')[0]}',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Uploaded By',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      color: MyColors.darkGray,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item.uploadedBy}',
                                                    style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Divider(
                                      thickness: 1.0,
                                      indent: 15,
                                      endIndent: 15,
                                    )
                            ],
                          );
                        })
                    : Center(
                        child: Text(
                          "No Record Found",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey)
                        ),
                      ),
              ),
              if (_controller.status.isLoadingMore)
                Center(
                  child: CircularProgressIndicator(),
                ),
              Visibility(
                visible: search.isNotEmpty && filterList(search).isEmpty,
                child: Center(
                  child: Text(
                    "No Record Found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey)                  ),
                ),
              ),
              (_controller.clearFilter.value)
                  ? SizedBox(
                      height: 45,
                      width: width(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () {
                              _controller.currentPage = 1;
                              _controller.PendingList(
                                  _controller.withOutEadate,
                                  _controller.withOutFDate,
                                  false,
                                  false,
                                  null,
                                  null);
                              _controller.clearFilter.value = false;
                              _controller.fromDateController.text = "";
                              _controller.toDateController.text = "";
                              _controller.fromAmountController.text = "";
                              _controller.toAmountController.text = "";
                            },
                            child: Text(
                              'CLEAR ALL FILTER',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                              ),
                            )),
                      ),
                    )
                  : Container(),
            ],
          ));
    });
  }

  _showFiltter(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: formKey1,
              child: Container(
                height: height(context) / 1.5,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FILTER BY : ',
                          style: TextStyle(
                              fontFamily: MyFont.myFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.5,
                              color: MyColors.darkGray),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                    Divider(
                      color: MyColors.black,
                      thickness: 1.0,
                    ),
                    Text(
                      'Select amount or date to view transactions',
                      style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          color: MyColors.gray),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Select Amount ',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 25),
                        IconButton(
                            onPressed: () {
                              _controller.fromAmountController.text = "";
                              _controller.toAmountController.text = "";
                            },
                            icon: Icon(Icons.close,size: 20,)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context) / 2.5,
                          child: TextFormField(
                            controller: _controller.fromAmountController,
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2, maxDigitsBeforeDecimal: 5)
                            ],
                            keyboardType: TextInputType.numberWithOptions(decimal: true),                            decoration: InputDecoration(
                              hintText: 'From Amount',
                              hintStyle: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: MyColors.darkGray),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width(context) / 2.5,
                          child: TextFormField(
                            controller: _controller.toAmountController,
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2, maxDigitsBeforeDecimal: 5)
                            ],
                            keyboardType: TextInputType.numberWithOptions(decimal: true),                            decoration: InputDecoration(
                              hintText: 'To Amount',
                              hintStyle: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: MyColors.darkGray),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'OR Select Date',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 25),
                        IconButton(
                            onPressed: () {
                              _controller.fromDateController.text = "";
                              _controller.toDateController.text = "";
                            },
                            icon: Icon(Icons.close,size: 20,)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width(context) / 2.5,
                          child: TextFormField(
                            controller: _controller.fromDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'From Date',
                              hintStyle: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: MyColors.darkGray),
                            ),
                            onTap: () async {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now())
                                  .then((value) {
                                setState(() {
                                  _controller.fromFilterDate = value!;
                                  _controller.fromDateController.text =
                                      DateFormat('dd-MM-yyyy').format(value);
                                  _controller.fromDate =
                                      DateFormat('yyyy-MM-dd').format(value);
                                });
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: width(context) / 2.5,
                          child: TextFormField(
                            controller: _controller.toDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'To Date',
                              hintStyle: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: MyColors.darkGray),
                            ),
                            onTap: () async {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: _controller.fromFilterDate,
                                      lastDate: DateTime.now())
                                  .then((value) {
                                setState(() {
                                  _controller.ToFilteDate = value!;
                                  print(value);
                                  _controller.toDateController.text =
                                      DateFormat('dd-MM-yyyy').format(value);
                                  _controller.toDate =
                                      DateFormat('yyyy-MM-dd').format(value);
                                });
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          onPressed: () {

                            if (_controller
                                        .fromAmountController.text.isNotEmpty &&
                                    _controller
                                        .toAmountController.text.isNotEmpty ||
                                _controller
                                        .fromDateController.text.isNotEmpty &&
                                    _controller
                                        .toDateController.text.isNotEmpty) {
                              _controller.currentPage = 1;
                              _controller.PendingList(
                                  _controller.fromDate,
                                  _controller.toDate,
                                  true,
                                  false,
                                  (_controller
                                          .fromAmountController.text.isEmpty)
                                      ? null
                                      : _controller.fromAmountController.text,
                                  (_controller.toAmountController.text.isEmpty)
                                      ? null
                                      : _controller.toAmountController.text);
                             _controller.clearFilter.value = true;
                            } else {
                              _showPopup(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 10),
                            child: Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Remove default padding
          content: ClipRRect(
            borderRadius: BorderRadius.circular(20.0), // Set the border radius
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white, // Set your desired background color
              child: Text('Please select atleast one filter'),
            ),
          ),
        );
      },
    );
  }
}
