import 'dart:convert';

import 'package:ajmanbank/Helper/constants.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AuthuModel.dart';
import '../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';

class PreferenceHelper {
  static void log(dynamic value) {
    if (value != null && true) {
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern.allMatches(value).forEach((match) => debugPrint(match.group(0)));
    }
  }

  static showSnackBar(
      {required BuildContext context, String? msg, Duration? duration}) {
    if (msg != null && msg.isNotEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
        content: Text(msg),
        duration: duration ?? const Duration(seconds: 2),
      ));
    }
  }

  static Future<AuthuModel?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user_token';
    if (prefs.containsKey(key)) {
      final value = json.decode(prefs.getString(key)!);
      if (value != null) {
        PreferenceHelper.log('Get User Data: $value');
        return AuthuModel.fromJson(value);
      }
    }
    return null;
  }

  static Future<bool> saveToken(Map userData) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user_token';
    final value = json.encode(userData);
    PreferenceHelper.log('Save User Data $value');

    return prefs.setString(key, value);
  }

  static Future<bool> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user_token';
    await prefs.remove(key);
    return true;
  }

  static Future<bool> saveUserData(Map userData) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user_data';
    final value = json.encode(userData);
    PreferenceHelper.log('Save User Data $value');

    return prefs.setString(key, value);
  }

  static Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'user_data';
    if (prefs.containsKey(key)) {
      final value = json.decode(prefs.getString(key)!);
      if (value != null) {
        PreferenceHelper.log('Get User Data: $value');
        return UserModel.fromJson(value);
      }
    }
    return null;
  }


  static Future<void> clearUserData() async {
    print(">>>>>>>>>>>clearUserdata");
    final prefs = await SharedPreferences.getInstance();
    const key = 'user_data';
    await prefs.remove(key);
    PreferenceHelper.log('User data cleared.');
  }


  static Future<void> saveIsRegistrationDone(
      {required bool isRegistrationDone}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isRegistrationDone, isRegistrationDone);
  }

  static Future<bool> getIsRegistrationDone() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(Constants.isRegistrationDone) ?? false;
  }

  static Future<void> saveIsBiometricEnabled(
      {required bool isBioMetricEnabled}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isBioMetricEnabled, isBioMetricEnabled);
  }

  static Future<bool> getIsBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.isBioMetricEnabled) ?? false;
  }


  static Future<void> saveMpinRegister(
      {required bool isMpinRegistration}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isMpinRegistration, isMpinRegistration);
  }

  static Future<bool> getMpinRegister() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(Constants.isMpinRegistration) ?? false;
  }


  static WhiteSnackBar({
    required BuildContext context,
    String? msg,
    Duration? duration,
  }) {
    if (msg != null && msg.isNotEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
        content: Text(msg, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        duration: duration ?? const Duration(seconds: 2),
      ));
    }
  }


  // static hasRepeatedDigits(String value) {
  //   for (int i = 0; i < value.length - 1; i++) {
  //     if (value[i] == value[i + 1]) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  static bool hasRepeatedDigits(String value, int repeatCount) {
    int count = 0;
    for (int i = 0; i < value.length - 1; i++) {
      if (value[i] == value[i + 1]) {
        count++;
        if (count >= repeatCount - 1) {
          return true;
        }
      } else {
        count = 0;
      }
    }
    return false;
  }

  static hasContinuousNumbers(String value) {
    for (int i = 0; i < value.length - 2; i++) {
      int? currentDigit = int.tryParse(value[i]);
      int? nextDigit = int.tryParse(value[i + 1]);
      int? secondNextDigit = int.tryParse(value[i + 2]);

      if (currentDigit != null && nextDigit != null && secondNextDigit != null) {
        if (currentDigit + 1 == nextDigit && nextDigit + 1 == secondNextDigit) {
          return true;
        }
      }
    }
    return false;
  }

}
