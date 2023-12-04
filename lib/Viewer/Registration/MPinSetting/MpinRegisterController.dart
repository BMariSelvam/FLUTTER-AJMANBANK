import 'dart:convert';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../Helper/BiometricAuth.dart';
import '../../../Helper/HttpUrl.dart';
import '../../../Helper/Networkservice.dart';
import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Helper/colors.dart';
import '../../../Helper/fonts.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/MpinRegisterModel.dart';

class MpinRegisterController extends GetxController with StateMixin {
  TextEditingController newmPinController = TextEditingController();
  TextEditingController confirmMpinController = TextEditingController();
  final GlobalKey<FormState> mpinKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  bool errorText = false;
  bool sucessText = false;
  bool closeText = false;
  late MpinRegisterModel mpinRegisterModel;
  AuthuModel? authuModel;
  String? access_token;
  String? osName;
  String? deviceName;
  String? deviceId;
  String? referenceNumber;
  RxBool isRegister = false.obs;
  final RxString currentCity = RxString('');
  bool? biocheck;
  RxBool editconfirm = false.obs;

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
    biocheck = await PreferenceHelper.getIsBiometricEnabled();
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

  //MpinRegistration
  mPinRegisert() async {
    isLoading.value = true;
    await NetworkManager.post(
      HttpUrl.mPinRegister,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json', // Adjust the content type if needed
      },
      body: {"userInfoVO": mpinRegisterModel}, // Convert your data to JSON
    ).then((response) async {
      isLoading.value = false;
      if (response != null) {
        if (response['statusCode'] == "0000") {
          await PreferenceHelper.saveMpinRegister(
              isMpinRegistration: true);
          showPopup(true);
          bool santhosh = await PreferenceHelper.getMpinRegister();
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
  }

  showPopup(bool success) {
    return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext) {
          return (biocheck == true) ? AlertDialog(
            title: Column(
              children: [
                (success)?
                Text("Your MPIN is created successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFont.myFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.green,
                  )):Text(""),
                Text(
                  'Do you want to enable \n Touch ID/Face ID ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFont.myFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: MyColors.darkGray,
                  ),
                ) ,
              ],
            ),
            content:  ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      bool authenticate = await BiometricAuth().authenticate();
                      if (authenticate) {
                        await PreferenceHelper.saveIsBiometricEnabled(
                            isBioMetricEnabled: false);
                        Get.offAllNamed(AppRoute.registrationFaceIDSuccessfully);
                      }
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () async {
                      await PreferenceHelper.saveIsBiometricEnabled(
                          isBioMetricEnabled: true);
                        Get.offAllNamed(AppRoute.login);
                    },
                    child: Text('No'))
              ],
            )
          ) : AlertDialog(
            title: Text(
              'Your MPIN is created successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: MyColors.green,
              ),
            ),
            content: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Get.offAndToNamed(AppRoute.loginThroughMPIN);
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontSize: 18,
                        color: MyColors.primaryCustom,
                      ),
                    )),
              ],
            ),
          );
        });
  }
}
