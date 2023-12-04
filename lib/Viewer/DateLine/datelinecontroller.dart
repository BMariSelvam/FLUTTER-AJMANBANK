import 'dart:convert';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import '../../Helper/HttpUrl.dart';
import '../../Helper/Networkservice.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/fonts.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/GetDeviceReqModel.dart';
import '../../Model/ListModel/PendingList.dart';
import '../../Model/MpinCheckModel.dart';
import '../../Model/PageInfoModel.dart';
import '../../Model/RemoveDeviceModel.dart';
import '../../Model/ResponseModel/GetDeviceListModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../Model/UserInfoModel.dart';

class DateLineController extends GetxController with StateMixin {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController fromAmountController = TextEditingController();
  TextEditingController toAmountController = TextEditingController();
  TextEditingController rejectReason = TextEditingController();
  RxBool isClick = true.obs;
  DateTime fromFilterDate = DateTime.now();
  DateTime ToFilteDate = DateTime.now();
  RxBool isDateLineClick = false.obs;
  RxBool isLoading = false.obs;
  RxBool isRejectLoading = false.obs;
  RxBool isApprovedLoading = false.obs;
  late PageInfoModel? pageInfoModel;
  late UserInfoModel? userInfoModel;
  late UserInfoModel? ApproveuserInfoModel;
  List<PendingListModel> pendingListmodel = [];
  String? access_token;
  UserModel? registrationFirstScreenRegModel;
  AuthuModel? authuModel;
  String? fromDate;
  String? toDate;
  String? referenceNumber;
  String? deviceId;
  String? osName;
  String? vGcifNo;
  String? vLoginId;
  String? mobileNo;
  String? vEmilId;
  final RxString currentCity = RxString('');
  bool mPinCheck = false;
  String? withOutFDate;
  String? withOutEadate;
  RxBool clearFilter = false.obs;
  int totalPages = 1;
  int currentPage = 1;
  int PendingSize = 0;

  @override
  onInit() async {
    super.onInit();
    getCheckData();
    DatePicker();
    getCurrentCity();
    getDeviceInformation();
    generateReferenceNumber();
    ApprovedPendingList(fromDate, toDate, false, false, null, null);
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
    await PreferenceHelper.getUserData().then((value) {
      vGcifNo = value?.userInfoVO?.vCorporateId;
      vLoginId = value?.userInfoVO?.vLoginId;
      mobileNo = value?.userInfoVO?.vmobile;
      vEmilId = value?.userInfoVO?.vEmailId;
    });
  }

  //DeviceInfo get mobile
  getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(Get.context!).platform == TargetPlatform.iOS) {
      // For iOS devices
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      osName = 'ios';
      deviceId = iosDeviceInfo.identifierForVendor;
    } else {
      // For Android devices
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      osName = 'Android';
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

  //location
  getCurrentCity() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      currentCity.value = 'Location services are disabled';
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      currentCity.value =
          'Location permissions are permanently denied, we cannot request permissions.';
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        currentCity.value =
            'Location permissions are denied (actual value: $permission).';
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String? city = placemark.locality;
      currentCity.value = city!;
    } else {
      currentCity.value = 'City not found';
    }
  }

  ApprovedPendingList(String? fromDate, String? toDate, bool? filter,
      bool isPagination, String? fromAmount, String? toAmount) async {
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
      HttpUrl.pendingList,
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
          PendingSize = response['listSize'];
          change(null, status: RxStatus.success());
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
          change(null, status: RxStatus.success());
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

  ApprovedFile() async {
    pageInfoModel = PageInfoModel(
        fromDate: fromDate,
        toDate: toDate,
        creditDebit: "C",
        amountFilter: "01",
        amount: "",
        pageNo: "1",
        requestId: "01",
        rowsPerPage: "20",
        fromRecord: "1",
        recordCount: "3000");

    change(null, status: RxStatus.loading());
    isApprovedLoading.value = true;
    await NetworkManager.post(
      HttpUrl.fileApproved,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"pagingInfo": pageInfoModel, "userInfoVO": ApproveuserInfoModel},
    ).then((response) async {
      if (response != null) {
        if (response['statusCode'] == "0000") {
          isApprovedLoading.value = false;
          Get.back();
          SuccesPop(true);
          change(null, status: RxStatus.success());
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

  SuccesPop(bool? approve) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Get.offAllNamed(AppRoute.dateLineScreen);
          });
          return AlertDialog(
            title: Column(
              children: [
                (approve == true)
                    ? Image.asset(Assets.approve)
                    : Image.asset(Assets.reject),
                Text(
                  (approve == true)
                      ? 'The file has been \napproved successfully'
                      : 'The file has been \nrejected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFont.myFont,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          );
        });
  }

  RejectFile() async {
    pageInfoModel = PageInfoModel(
        fromDate: fromDate,
        toDate: toDate,
        creditDebit: "C",
        amountFilter: "01",
        amount: "",
        pageNo: "1",
        requestId: "01",
        rowsPerPage: "20",
        fromRecord: "1",
        recordCount: "3000");

    change(null, status: RxStatus.loading());
    isRejectLoading.value = true;
    await NetworkManager.post(
      HttpUrl.fileReject,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"pagingInfo": pageInfoModel, "userInfoVO": ApproveuserInfoModel},
    ).then((response) async {
      if (response != null) {
        if (response['statusCode'] == "0000") {
          isRejectLoading.value = false;
          Get.back();
          SuccesPop(false);
          change(null, status: RxStatus.success());
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
