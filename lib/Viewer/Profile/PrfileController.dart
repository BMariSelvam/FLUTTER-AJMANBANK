import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import '../../Helper/HttpUrl.dart';
import '../../Helper/Networkservice.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/GetDeviceReqModel.dart';
import '../../Model/MpinCheckModel.dart';
import '../../Model/RemoveDeviceModel.dart';
import '../../Model/ResponseModel/GetDeviceListModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';

class ProfileController extends GetxController with StateMixin {
  RxBool isClick = true.obs;
  RxBool isRemoveClick = false.obs;
  RxBool isLoading = false.obs;
  late GetDeviceReqModel? getDeviceReqModel;
  late RemoveDeviceModel? removeDeviceModel;
  List<GetDeviceListModel> getdeviceList = [];
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
  String? lastLoginTime = "";
  late MpinCheckModel checkMpinModel;
  final RxString currentCity = RxString('');
  // bool mPinCheck = false;
  RxBool mPinCheck = false.obs;
  @override
  onInit() async {
    super.onInit();
    getCheckData();
    getDeviceInformation();
    generateReferenceNumber();
    getCurrentCity();
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
      deviceId = iosDeviceInfo.identifierForVendor;
      osName = "ios";
    } else {
      // For Android devices
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.androidId;
      osName = "Android";
    }
    CheckMpin();
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



  getDivecList() async {
    change(null, status: RxStatus.loading());
    getDeviceReqModel=GetDeviceReqModel(
        reqRefNo: referenceNumber,
        requestFlag: "N",
        vDeviceId: deviceId,
        vCorporateId: vGcifNo,
        vSecureToken: access_token,
        msgSourceChannelID: "120",
        vMobileNo: mobileNo,
        appVersionCode: "1.0.0",
        vOSName: osName,
        vGcifNo: vGcifNo,
        vEmailId: vEmilId,
        gloinId: vLoginId
    );
    await NetworkManager.post(
      HttpUrl.getTrustedDevices,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"userInfoVO": getDeviceReqModel},
    ).then((response) async {
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          getdeviceList = (response['mobileDeviceList'] as List)
              .map((item) => GetDeviceListModel.fromJson(item))
              .toList();
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



  RemoveDevice() async {
    change(null, status: RxStatus.loading());
    // isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.removeTrustedDevices,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"userInfoVO": removeDeviceModel},
    ).then((response) async {
      // isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          Get.offAndToNamed(AppRoute.homeScreen);
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


  //CheckMpin Api
  CheckMpin() async {
    checkMpinModel = MpinCheckModel(
        msgSourceChannelID: '120',
        languageCode: "EN",
        location: currentCity.value,
        ipAddr: "120.10.0.1",
        deviceType: 'mobileNo',
        requestFlag: 'N',
        reqRefNo: referenceNumber,
        accessToken: access_token,
        appName: 'mobileApp',
        appVersionCode: '',
        corpId: vGcifNo,
        gcifID: vGcifNo,
        deviceId: deviceId,
        loginId: vLoginId,
        mpin: "",
        os: osName,
        password: "");
    change(null, status: RxStatus.loading());
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.checkMpin,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"loginInfo": checkMpinModel},
    ).then((response) async {
      isLoading.value = false;
      String approvedOnDateTimeString = response['loginInfo']['lastLoginTime'];
      DateTime approvedOn = DateTime.parse(approvedOnDateTimeString);
      lastLoginTime = approvedOn.toLocal().toString().split('.')[0];
      print("lastLoginTime");
      print(lastLoginTime);
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          mPinCheck.value = true;
        } else if (response['statusCode'] == "4004") {
          mPinCheck.value = false;
        }
      } else if (response['statusCode'] == "2020") {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: response['statusDesc']);
      } else {
        change(null, status: RxStatus.error());
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
  }


  //Logout
  logoutfun() async {
    change(null, status: RxStatus.loading());
    isLoading.value = true;
    getDeviceReqModel=GetDeviceReqModel(
        reqRefNo: referenceNumber,
        requestFlag: "N",
        vDeviceId: deviceId,
        vCorporateId: vGcifNo,
        vSecureToken: access_token,
        msgSourceChannelID: "120",
        vGcifNo: vGcifNo,
        gloinId: vLoginId
    );
    await NetworkManager.post(
      HttpUrl.logutApi,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"userInfoVO": getDeviceReqModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          await PreferenceHelper.clearToken().then((value) =>
              Get.offAllNamed(AppRoute.login)
          );
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
