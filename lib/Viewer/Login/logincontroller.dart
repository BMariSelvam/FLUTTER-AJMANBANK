import 'dart:convert';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../Helper/BiometricAuth.dart';
import '../../Helper/ConnectionScreen.dart';
import '../../Helper/HttpUrl.dart';
import '../../Helper/Networkservice.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/colors.dart';
import '../../Helper/constants.dart';
import '../../Helper/fonts.dart';
import '../../Model/AuthuModel.dart';
import 'package:http/http.dart' as http;
import '../../Model/LoginModel.dart';
import '../../Model/MpinCheckModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';

class LoginController extends GetxController with StateMixin {
  RxBool isMPinClick = true.obs;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  final formKey1 = GlobalKey<FormState>();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mpinController = TextEditingController();
  bool passwordVisibility = true;
  late LoginModel? loginModel;
  late MpinCheckModel? checkMpinModel;
  AuthuModel? authuModel;
  String? access_token;
  String? osName;
  String? deviceName;
  String? deviceId;
  String? referenceNumber;
  final RxString currentCity = RxString('');
  UserModel? registrationFirstScreenRegModel;
  String? vGcifNo;
  String? vLoginId;

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
    registrationFirstScreenRegModel = await PreferenceHelper.getUserData();
    vGcifNo = registrationFirstScreenRegModel?.userInfoVO?.vCorporateId;
    vLoginId = registrationFirstScreenRegModel?.userInfoVO?.vLoginId;
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
        LoginApi();
      });
    } else {
      PreferenceHelper.showSnackBar(context: Get.context!, msg: "Unauthorized");
    }
  }

  //LoginApi
  LoginApi() async {
    change(null, status: RxStatus.loading());
    isLoading.value = true;
   loginModel = LoginModel(
          msgSourceChannelID: '120',
          accessToken: access_token,
          reqRefNo: referenceNumber,
          gcifID: vGcifNo,
          corpId: vGcifNo,
          loginId: userIdController.text,
          password: passwordController.text,
          mpin: '',
          languageCode: "EN",
          location: currentCity.value,
          ipAddr: '120.10.0.1',
          os: osName,
          deviceId: deviceId,
          deviceType: 'mobileNo',
          appName: 'Customer Portal',
          appVersionCode: "1.0.0",
          requestFlag: "N",
        );
    await NetworkManager.post(
      HttpUrl.logIn,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json',
      },
      body: {"loginInfo": loginModel},
    ).then((response) async {
      isLoading.value = false;
      change(null, status: RxStatus.success());
      if (response != null) {
        if (response['statusCode'] == "0000") {
          Get.offAllNamed(AppRoute.homeScreen);
        } else if (response['statusCode'] == "1005"){
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
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

  //CheckMpin Api
  CheckMpin() async {
    try {
      change(null, status: RxStatus.loading());
      isLoading1.value = true;
      await NetworkManager.post(
        HttpUrl.checkMpin,
        headers: {
          'access_token': access_token ?? "",
          'Content-Type': 'application/json',
        },
        body: {"loginInfo": checkMpinModel},
      ).then((response) async {
        isLoading1.value = false;
        print(response);
        change(null, status: RxStatus.success());
        if (response != null) {
          if (response['statusCode'] == "0000") {
            Get.toNamed(AppRoute.loginThroughMPIN);
          } else if (response['statusCode'] == "4004") {
            showPopup();
            print("11111111111");
          }
        } else {
          change(null, status: RxStatus.error());
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: "InValied Data");
        }
      });
    } catch (e) {
      if (e is Exception && e.toString() == 'No Internet Connection') {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => CheckInternetScreen(),
          ),
        );
      }
    }
  }

  showPopup() {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text(
              'Do you want to create MPIN \n for ease access?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: MyColors.darkGray,
              ),
            ),
            content: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                     Navigator.pop(Get.context!);
                      Get.toNamed(AppRoute.mPinSettingScreen,arguments: false);
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(Get.context!);
                    },
                    child: Text('No'))
              ],
            ),
          );
        });
  }
}
