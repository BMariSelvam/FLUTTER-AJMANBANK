import 'dart:convert';
import 'dart:math';
import 'package:ajmanbank/Helper/constants.dart';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'Helper/HttpUrl.dart';
import 'Helper/Networkservice.dart';
import 'Helper/PreferenceHelper.dart';
import 'Helper/approute.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Model/AuthuModel.dart';
import 'Model/GetDeviceReqModel.dart';
import 'Model/ResponseModel/GetDeviceListModel.dart';
import 'Model/ResponseModel/RegistrationFirstScreenRegModel.dart';

class SplashScreenController extends GetxController with StateMixin {
  UserModel? userModel;
  bool isRegistrationDone = false;
  late GetDeviceReqModel? getDeviceReqModel;
  List<GetDeviceListModel> getdeviceList = [];
  RxBool isLoading = false.obs;
  String? access_token;
  AuthuModel? authuModel;
  String? referenceNumber;
  String? deviceId;
  String? osName;
  String? vGcifNo;
  String? vLoginId;
  String? mobileNo;
  String? vEmilId;

  @override
  onInit() async {
    super.onInit();
    userModel = await PreferenceHelper.getUserData();
    vLoginId = userModel?.userInfoVO?.vLoginId;
    vGcifNo = userModel?.userInfoVO?.vCorporateId;
    vGcifNo = userModel?.userInfoVO?.vCorporateId;
    mobileNo = userModel?.userInfoVO?.vmobile;
    isRegistrationDone = await PreferenceHelper.getIsRegistrationDone();
    makePostRequest();
    getDeviceInformation();
    generateReferenceNumber();
  }


  String basicAuth(String username, String password) {
    final token = base64.encode(utf8.encode('$username:$password'));
    return 'Basic $token';
  }

  makePostRequest() async {
    var url = HttpUrl.authu;
    var headers = {
      'Authorization': basicAuth(Constants.userName, Constants.password),
      'Content-Type': 'application/json',
    };
    var body = '{}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      Map<dynamic, dynamic>? customerJson = json.decode(response.body);
      await PreferenceHelper.saveToken(customerJson ?? {}).then((value) async {
        access_token = customerJson?['access_token'];
        if (userModel != null && isRegistrationDone) {
          print(">>>>>>>>>>>>>>>Removed Device");
          // Get.offAndToNamed(AppRoute.login);
           getDivecList(false);
        } else {
          print("==================================new one");
         Get.offAndToNamed(AppRoute.registrationFirstScreen);
        }
      });
    } else {
      PreferenceHelper.showSnackBar(context: Get.context!, msg: "Unauthorized");
    }
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


  getDivecList(bool? newUser) async {
    print("===$vLoginId======$mobileNo=======$access_token=======$deviceId=======");
    change(null, status: RxStatus.loading());
    isLoading.value = true;
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
      isLoading.value = false;
      change(null, status: RxStatus.success());
      print(response);
      if (response != null) {
        if (response['statusCode'] == "0000") {
          getdeviceList = (response['mobileDeviceList'] as List)
              .map((item) => GetDeviceListModel.fromJson(item))
              .toList();
       if (newUser == false) {
         if (getdeviceList.any((getdeviceList) =>
         getdeviceList.deviceId == deviceId)) {
           print("==================================old one0000000000000000000000");
           Get.offAndToNamed(AppRoute.login);
         } else {
           print("==================================new one00000000000000000000000");
           await PreferenceHelper.clearUserData().then((value) {
             Get.toNamed(AppRoute.registrationFirstScreen);
           });
         }
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

}
