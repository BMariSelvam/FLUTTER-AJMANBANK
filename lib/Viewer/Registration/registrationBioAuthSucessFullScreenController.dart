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
import '../../../Model/RegistrationModel.dart';
import '../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';

class BioAuthuControllerSucessFullController extends GetxController with StateMixin {
  String? osName;
  String? deviceName;
  String? deviceId;
  RxBool isLoading = false.obs;


  @override
  onInit() async {
    super.onInit();
    getDeviceInformation();
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

}
