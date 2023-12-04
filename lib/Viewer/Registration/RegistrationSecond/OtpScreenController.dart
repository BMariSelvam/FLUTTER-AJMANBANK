import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';
import '../../../Helper/HttpUrl.dart';
import '../../../Helper/Networkservice.dart';
import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Helper/colors.dart';
import '../../../Helper/fonts.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/GenerateOtpModel.dart';
import '../../../Model/MobileNumberValidationModel.dart';
import '../../../Model/MpinCheckModel.dart';
import '../../../Model/OtpInfo.dart';
import '../../../Model/ResponseModel/GenerateOtpResponse/GenerateOtpResponseModel.dart';
import '../../../Model/OtpUserInfoVo.dart';
import '../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../../sample.dart';

class OtpScreenController extends GetxController with StateMixin {
  RxBool sendOTP = false.obs;
  RxBool editMobile = false.obs;
  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  TextEditingController threeController = TextEditingController();
  TextEditingController fourController = TextEditingController();
  TextEditingController fiveController = TextEditingController();
  TextEditingController sixController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isVerfiyLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  late GenerateOtpResponseModel registrationFirstScreenRegModel;
  late MobileNumberValidationModel mobileNumberValidationModel;
  late GenerateOtpModel? generateOtpModel;
  late OtpInfo? otpInfo;
  late OtpUserInfoVO? userInfoVO;
  RxBool istime = false.obs;
  late MpinCheckModel? checkMpinModel;

  // bool? istime = false;
  String? mobileNumber;
  int? otpId;
  String? osName;
  String? deviceName;
  String? deviceId;
  String? referenceNumber;
  UserModel? userModel;
  String? vGcifNo;
  String? vLoginId;
  AuthuModel? authuModel;
  String? access_token;
  final RxString currentCity = RxString('');
  String? otpValue;
  bool mobilevalid = false;
  final RxInt clickCount = 0.obs;



  //ResendOTPTimer
  CountdownTimer? countdownTimer;
  CountdownTimers? timer;
  final int totalDuration = 120; // 2 minutes in seconds
  Rx<String> formattedDuration = '02.00'.obs;

  int start = 30;

  @override
  onInit() async {
    super.onInit();
    getCheckData();
    generateReferenceNumber();
  }


  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    userModel = await PreferenceHelper.getUserData();
    access_token = authuModel?.accessToken;
    vGcifNo = userModel?.userInfoVO?.vCorporateId;
    vLoginId = userModel?.userInfoVO?.vLoginId;
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

  //RerefNumber auto generate
  generateReferenceNumber() {
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final bytes = List.generate(
        32, (index) => chars.codeUnitAt(random.nextInt(chars.length)));
    referenceNumber = base64Url.encode(bytes).toUpperCase();
    return referenceNumber!;
  }

  //DeviceInfo get mobile
  getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(Get.context!).platform == TargetPlatform.iOS) {
      // For iOS devices
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      osName = 'ios';
      deviceName = iosDeviceInfo.name;
      deviceId = iosDeviceInfo.identifierForVendor;
    } else {
      // For Android devices
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      osName = 'android';
      deviceName = androidDeviceInfo.model;
      deviceId = androidDeviceInfo.androidId;
    }
  }



  VerifyOtp() async {
    isVerfiyLoading.value = true;
    await NetworkManager.post(
      HttpUrl.verifyOtp,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json', // Adjust the content type if needed
      },
      body: {
        'otpInfo': otpInfo?.toJson(),
        'userInfoVO': userInfoVO?.toJson(),
      }, // Convert your data to JSON
    ).then((response) async {
      isVerfiyLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        print(response);
        if (response['statusCode'] == "0000") {
          await PreferenceHelper.saveIsRegistrationDone(
              isRegistrationDone: true);
          showResetPopup();
            Timer(const Duration(milliseconds: 1300), () async {
              CheckMpin();
            });
        } else {
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
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
      change(null, status: RxStatus.success());
      print(response);
      if (response != null) {
        print(response);
        if (response['statusCode'] == "0000") {
          // showPopup();
          Get.offAllNamed(AppRoute.loginThroughMPIN);
        } else if (response['statusCode'] == "4004") {
          Get.offAllNamed(AppRoute.mPinSettingScreen, arguments: true);
          // PreferenceHelper.showSnackBar(
          //     context: Get.context!, msg: response['statusDesc']);
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

  showResetPopup() {
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'OTP validation \n successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: MyColors.green,
              ),
            ),
          );
        });
  }
}
