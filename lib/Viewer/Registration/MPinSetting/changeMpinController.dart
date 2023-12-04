import 'dart:convert';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../Helper/HttpUrl.dart';
import '../../../Helper/Networkservice.dart';
import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Helper/colors.dart';
import '../../../Helper/fonts.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/UpdateMpinModel.dart';


class ChngaeMpinController extends GetxController with StateMixin {
  TextEditingController newmPinController = TextEditingController();
  TextEditingController confirmMpinController = TextEditingController();
  TextEditingController oldMpinController = TextEditingController();
  RxBool isLoading = false.obs;
  bool errorText = false;
  bool sucessText = false;
  final GlobalKey<FormState> changefromKey = GlobalKey<FormState>();
  late UpdateMpinModel? updateMpinModel;
  AuthuModel? authuModel;
  String? access_token;
  String? osName;
  String? deviceName;
  String? deviceId;
  String? referenceNumber;
  RxBool editconfirm = false.obs;

  @override
  onInit() async {
    super.onInit();
    getCheckData();
    getDeviceInformation();
    generateReferenceNumber();
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


  //MpinRegistration
  mPinUpdate() async {
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.updateMpin,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json', // Adjust the content type if needed
      },
      body: {"userInfoVO": updateMpinModel}, // Convert your data to JSON
    ).then((response) async {
      isLoading.value = false;
      if (response != null) {
        if (response['statusCode'] == "0000") {
          showResetPopup();
        } else if (response['statusCode'] == "4005") {
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
    newmPinController.clear();
    confirmMpinController.clear();
    oldMpinController.clear();
  }



  showResetPopup() {
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Your MPIN has been \n changed successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: MyColors.darkGray,
              ),
            ),
            content: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoute.loginThroughMPIN);
                    },
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontSize: 15,
                        color: MyColors.primaryCustom,
                      ),
                    )),
              ],
            ),
          );
        });
  }

}