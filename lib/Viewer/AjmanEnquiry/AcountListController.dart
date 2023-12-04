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
import '../../Model/MpinCheckModel.dart';
import '../../Model/RemoveDeviceModel.dart';
import '../../Model/ResponseModel/AccountListModel.dart';
import '../../Model/ResponseModel/GetDeviceListModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../Model/UserInfoModel.dart';

class AcountListController extends GetxController with StateMixin {
  RxBool isLoading = false.obs;
  RxBool isClick = true.obs;
  late UserInfoModel? userInfoModel;
  List<AccountListModel> accoutListModel = [];
  String? access_token;
  UserModel? registrationFirstScreenRegModel;
  AuthuModel? authuModel;
  String? referenceNumber;
  String? deviceId;
  String? osName;
  String? vGcifNo;
  String? vLoginId;
  String? mobileNo;
  String? vEmilId;
  final RxString currentCity = RxString('');
  bool mPinCheck = false;

  @override
  onInit() async {
    super.onInit();
    getCheckData();
    getDeviceInformation();
    generateReferenceNumber();
    AccountList();
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
    if (Theme
        .of(Get.context!)
        .platform == TargetPlatform.iOS) {
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


  AccountList() async {
    String? vGcifNo, vLoginId;
    await PreferenceHelper.getUserData().then((value) {
      vGcifNo = value?.userInfoVO?.vCorporateId;
      vLoginId = value?.userInfoVO?.vLoginId;
    });

    userInfoModel = UserInfoModel(
        msgSourceChannelID: "120",
        vSecureToken: access_token,
        reqRefNo: referenceNumber,
        vLoginId: vLoginId,
        vCorporateId: vGcifNo,
        fileReferenceNo: null,
        vDeviceId: deviceId,
        vOSName: osName,
        vGcifNo: vGcifNo,
        vEmailId: vEmilId,
        appVersionCode: "1.0.0",
        requestFlag: "N");

    change(null, status: RxStatus.loading());
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.accountList,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"userInfoVO": userInfoModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        print(response);
        if (response['statusCode'] == "0000") {
          if (response['accountDTO'] != null) {
            accoutListModel = (response['accountDTO'] as List)
                .map((item) => AccountListModel.fromJson(item))
                .toList();
            print("=========");
            print(accoutListModel.first.accNo);
          } else {
            PreferenceHelper.showSnackBar(
                context: Get.context!, msg: response['statusDesc']);
          }
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


}
