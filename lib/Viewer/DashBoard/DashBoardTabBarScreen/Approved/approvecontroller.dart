import 'dart:convert';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Helper/HttpUrl.dart';
import '../../../../Helper/Networkservice.dart';
import '../../../../Helper/PreferenceHelper.dart';
import '../../../../Model/AuthuModel.dart';
import '../../../../Model/ListModel/PendingList.dart';
import '../../../../Model/PageInfoModel.dart';
import '../../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../../../Model/UserInfoModel.dart';
import 'package:intl/intl.dart';

class ApproveController extends GetxController with StateMixin {
  RxBool isClick = false.obs;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromAmountController = TextEditingController();
  TextEditingController toAmountController = TextEditingController();
  DateTime fromFilterDate = DateTime.now();
  DateTime ToFilteDate = DateTime.now();
  RxBool isLoading = false.obs;
  late PageInfoModel? pageInfoModel;
  late UserInfoModel? userInfoModel;
  List<PendingListModel> pendingListmodel = [];
  String? access_token;
  UserModel? registrationFirstScreenRegModel;
  AuthuModel? authuModel;
  String? fromDate;
  String? toDate;
  String? referenceNumber;
  String? deviceId;
  int totalPages = 1;
  int currentPage = 1;
  int ApprovedListSize = 0;
  String? withOutFDate;
  String? withOutEadate;
  RxBool clearFilter = false.obs;


  @override
  onInit() async {
    super.onInit();
    getCheckData();
    DatePicker();
    getDeviceInformation();
    generateReferenceNumber();
    ApproveList(fromDate, toDate, false, false,null, null);
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DatePicker() {
    DateTime currentDate = DateTime.now();
    DateTime lastYearDate =
        DateTime(currentDate.year - 1, currentDate.month, currentDate.day);
    toDate = formatDate(currentDate);
    fromDate = formatDate(lastYearDate);
    withOutFDate = formatDate(currentDate);
    withOutEadate = formatDate(lastYearDate);
  }

  //Get Access_Token
  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    access_token = authuModel?.accessToken;
  }

  //DeviceInfo get mobile
  getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(Get.context!).platform == TargetPlatform.iOS) {
      // For iOS devices
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;
    } else {
      // For Android devices
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId;
    }
  }

  //RerefNumber auto generate
  generateReferenceNumber() {
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final bytes = List.generate(
        32, (index) => chars.codeUnitAt(random.nextInt(chars.length)));
    referenceNumber = base64Url.encode(bytes).toUpperCase();
    return referenceNumber!;
  }

  ApproveList(
      String? fromDate, String? toDate, bool? filter, bool isPagination, String? fromAmount, String? toAmount) async {
    String? vGcifNo, vLoginId;
    await PreferenceHelper.getUserData().then((value) {
      vGcifNo = value?.userInfoVO?.vCorporateId;
      vLoginId = value?.userInfoVO?.vLoginId;
    });
    pageInfoModel = PageInfoModel(
        fromDate: fromDate,
        toDate: toDate,
        fromAmount: fromAmount,
        toAmount: toAmount,
        creditDebit: "C",
        amountFilter: "01",
        amount: "",
        pageNo: "$currentPage",
        requestId: "01",
        rowsPerPage: "20",
        fromRecord: "1",
        recordCount: "3000");

    userInfoModel = UserInfoModel(
        msgSourceChannelID: "120",
        vSecureToken: access_token,
        reqRefNo: referenceNumber,
        vLoginId: vLoginId,
        vCorporateId: vGcifNo,
        fileReferenceNo: null,
        vDeviceId: deviceId,
        requestFlag: "N");

    change(null, status: RxStatus.loadingMore());
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.approveList,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"pagingInfo": pageInfoModel, "userInfoVO": userInfoModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          if (!isPagination) {
            pendingListmodel.clear();
          }
          ApprovedListSize = response['listSize'];
          if (response['statusDesc'] != "No Record Found.") {
            pendingListmodel.addAll((response['fileInfoList'] as List)
                .map((item) => PendingListModel.fromJson(item))
                .toList());
            if (filter == true) {
              Get.back();
            }
          } else {
            pendingListmodel ?? [];
            if (filter == true) {
              Get.back();
            }
          }
          double result = response['listSize'] / 20;
          int roundedResult = result.ceil();
          totalPages = roundedResult;
          currentPage++;
        } else if (response['statusCode'] == "2001") {
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        } else if (response['statusCode'] == "2020") {
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        }
      } else {
        change(null, status: RxStatus.error());
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
  }

}
