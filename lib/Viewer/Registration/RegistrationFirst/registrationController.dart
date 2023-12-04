import 'dart:convert';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../Helper/HttpUrl.dart';
import '../../../Helper/Networkservice.dart';
import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/GenerateOtpModel.dart';
import '../../../Model/GetDeviceReqModel.dart';
import '../../../Model/GetInitalDeviceListModel.dart';
import '../../../Model/RegistrationModel.dart';
import '../../../Model/ResponseModel/GenerateOtpResponse/GenerateOtpResponseModel.dart';
import '../../../Model/ResponseModel/GetDeviceListModel.dart';
import '../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';

class RegistrationController extends GetxController with StateMixin {
  bool passwordVisibility = true;
  RxBool isLoading = false.obs;
  TextEditingController corporateIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? osName;
  String? deviceName;
  String? deviceId;
  String? referenceNumber;
  final RxString currentCity = RxString('');
  final formKey = GlobalKey<FormState>();
  late RegistrationModel? registrationModel;
  late GetInitalDeviceListModel? getDeviceReqModel;
  AuthuModel? authuModel;
  String? access_token;
  UserModel? userModel;
  String? vGcifNo;
  String? vLoginId;
  String? mobileNo;
  String? vEmilId;
  List<GetDeviceListModel> getdeviceList = [];
  String? mobileNumber;
  int? otpId;
  String? otpValue;

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
    userModel = await PreferenceHelper.getUserData();
    vLoginId = userModel?.userInfoVO?.vLoginId;
    vGcifNo = userModel?.userInfoVO?.vCorporateId;
    vGcifNo = userModel?.userInfoVO?.vCorporateId;
    mobileNo = userModel?.userInfoVO?.vmobile;
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

  //5 Registration only Allowed
  getDivecList() async {
    change(null, status: RxStatus.loading());
    isLoading.value = true;
    getDeviceReqModel = GetInitalDeviceListModel(
      msgSourceChannelID: "120",
      requestFlag: "N",
      languageCode: "En",
      ipAddr: "120.10.0.1",
      deviceType: "mobileNo",
      mpin: "",
      appVersionCode: "1.0.0",
    reqRefNo: referenceNumber,
      password: passwordController.text,
      os: osName,
      loginId: userIdController.text,
      deviceId: deviceId,
      gcifID: corporateIdController.text,
      corpId: corporateIdController.text,
      appName: "Customer Portal",
      accessToken: access_token,
      location: currentCity.value
    );

    await NetworkManager.post(
      HttpUrl.getDeiveForRegistration,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"loginInfo": getDeviceReqModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          getdeviceList = (response['mobileDeviceList'] as List)
              .map((item) => GetDeviceListModel.fromJson(item))
              .toList();
          if (getdeviceList.length <= 4) {
            Registration();
          } else {
           bool DeviceId = getdeviceList.any((element) => element.deviceId == deviceId);
           if (DeviceId) {
             Registration();
           } else{
             PreferenceHelper.showSnackBar(
                 context: Get.context!, msg: "Cannot Register More Than 5 Devices!");
           }
          }
        } else if (response['statusCode'] == "2001") {
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        } else if (response['statusCode'] == "9999") {
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

  //Registration Api CAll
  Registration() async {
    change(null, status: RxStatus.loading());
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.Registration,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"userInfoVO": registrationModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        Map<dynamic, dynamic>? customerJson = response;
        UserModel registrationFirstScreenRegModel =
            UserModel.fromJson(customerJson);
        if (registrationFirstScreenRegModel.statusCode == "0000") {
          await PreferenceHelper.saveUserData(customerJson ?? {}).then((value){
            print("customerJson?['userInfoVO']['vMobileNo']");
            print(customerJson?['userInfoVO']['vMobileNo']);
            mobileNumber = customerJson?['userInfoVO']['vMobileNo'];
          });
          if  (mobileNumber != null && mobileNumber!.isNotEmpty) {
            GenerateOtp();
          } else {
            PreferenceHelper.showSnackBar(
                context: Get.context!, msg: "InValied Data");
          }
        } else if (registrationFirstScreenRegModel.statusCode == "2222") {
          PreferenceHelper.showSnackBar(
              context: Get.context!,
              msg: registrationFirstScreenRegModel.statusDesc);
        } else if (registrationFirstScreenRegModel.statusCode == "1111") {
          PreferenceHelper.showSnackBar(
              context: Get.context!,
              msg: registrationFirstScreenRegModel.statusDesc);
        } else if (registrationFirstScreenRegModel.statusCode == "9999") {
          PreferenceHelper.showSnackBar(
              context: Get.context!,
              msg: registrationFirstScreenRegModel.statusDesc);
        } else if (registrationFirstScreenRegModel.statusCode == "1005"){
          PreferenceHelper.showSnackBar(
              context: Get.context!,
              msg: registrationFirstScreenRegModel.statusDesc);
        }
      } else {
        change(null, status: RxStatus.error());
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
  }

  late GenerateOtpModel? generateOtpModel;

  otpFunc() async {
    await PreferenceHelper.getUserData().then((value) {
      mobileNumber = value?.userInfoVO?.vmobile;
    }
    ).then((value) =>  GenerateOtp());
  }

  GenerateOtp() async {
   generateOtpModel = GenerateOtpModel(
      msgSourceChannelID: "120",
      vSecureToken: access_token,
      reqRefNo: referenceNumber,
      vMobileNo: mobileNumber,
      vGcifNo: corporateIdController.text,
      vCorporateId: corporateIdController.text,
      vLoginId: userIdController.text,
      vDeviceId: deviceId,
      requestFlag: "N",
    );
      isLoading.value = true;
   change(null, status: RxStatus.loading());
   await NetworkManager.post(
      HttpUrl.otpGenerate,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json', // Adjust the content type if needed
      },
      body: {"userInfoVO": generateOtpModel}, // Convert your data to JSON
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        print(response);
        if (response['statusCode'] == '0000') {
          Map<dynamic, dynamic>? customerJson = response;
          GenerateOtpResponseModel generateOtpResponseModel =
          GenerateOtpResponseModel.fromJson(customerJson);
          otpId = generateOtpResponseModel.otpInfo?.otpId;
          otpValue = generateOtpResponseModel.otpInfo?.otpValue;
          if (otpValue != null && otpValue!.isNotEmpty) {
            Get.toNamed(AppRoute.otpScreen);
          }
        } else if (response['statusCode'] == '2028') {
          print("object");
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
  }

}
