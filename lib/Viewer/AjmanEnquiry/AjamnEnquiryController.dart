import 'dart:convert';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../Helper/HttpUrl.dart';
import '../../Helper/Networkservice.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Model/AcountStateMentReqModel.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/MpinCheckModel.dart';
import '../../Model/PageInfoModel.dart';
import '../../Model/ResponseModel/AccountListModel.dart';
import '../../Model/ResponseModel/AccountSatementListModel/AcountStatementListModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import 'package:intl/intl.dart';

class StateMentListController extends GetxController with StateMixin {
  RxBool isLoading = false.obs;
  RxBool isClick = true.obs;
  late AcountStateMentReqModel? userInfoModel;
  String? access_token;
  UserModel? registrationFirstScreenRegModel;
  AuthuModel? authuModel;
  String? referenceNumber;
  late PageInfoModel? pageInfoModel;
  String? deviceId;
  String? osName;
  String? vGcifNo;
  String? vLoginId;
  String? mobileNo;
  String? vEmilId;
  String? fromDate;
  String? toDate;
  AccountListModel? accountListModel;
  List<Transaction> transaction = [];
  String startBalence = "";
  String endBalence = "";
  String moreRecord = "";
  late MpinCheckModel checkMpinModel;
  final RxString currentCity = RxString('');
  bool mPinCheck = false;


  @override
  onInit() async {
    super.onInit();
    getCheckData();
    DatePicker();
    accountListModel = Get.arguments as AccountListModel;
    getDeviceInformation();
    generateReferenceNumber();
    getCurrentCity();
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
    AccountStatementList();
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
      currentCity.value = 'Location permissions are permanently denied, we cannot request permissions.';
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

  AccountStatementList() async {
    String? vGcifNo, vLoginId;
    await PreferenceHelper.getUserData().then((value) {
      vGcifNo = value?.userInfoVO?.vCorporateId;
      vLoginId = value?.userInfoVO?.vLoginId;
    });
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
    userInfoModel = AcountStateMentReqModel(
        msgSourceChannelID: "120",
        vSecureToken: access_token,
        reqRefNo: referenceNumber,
        vCorporateId: vGcifNo,
        vAccountNo: accountListModel?.accNo,
        vLoginID: vLoginId,
        vDeviceId: deviceId,
        vOSName: osName,
        vGcifNo: vGcifNo,
        appVersionCode: "1.0.0",
        requestFlag: "N");
    change(null, status: RxStatus.loading());
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.accountStatement,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"pagingInfo": pageInfoModel, "userInfoVO": userInfoModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        print(response);
        print("-===========");
        print(response['accStatement']);
        if (response['statusCode'] == "0000") {
          if (response['accStatement'] != null) {
            startBalence = response['accStatement']['startBalance'];
            endBalence = response['accStatement']['endBalance'];
            moreRecord = response['accStatement']['moreRecords'];
            transaction = (response['accStatement']['transactionList'] as List)
                .map((item) => Transaction.fromJson(item))
                .toList();
          } else {
            PreferenceHelper.showSnackBar(
                context: Get.context!, msg: response['statusDesc']);
          }
        } else if (response['statusCode'] == "1010") {

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
