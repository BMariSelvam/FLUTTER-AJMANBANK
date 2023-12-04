import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';
import '../../Helper/size.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/LoginModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import 'ForgotPasswordController.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordController controller;

  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;

  String? access_token;
  String? vGcifNo;
  String? vLoginId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(ForgotPasswordController());
    getCheckData();
    controller.newPassword.clear();
    controller.confrimPassword.clear();
  }

  String? validationErrorText;

  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    access_token = authuModel?.accessToken;
    registrationFirstScreenRegModel = await PreferenceHelper.getUserData();
    vGcifNo = registrationFirstScreenRegModel?.userInfoVO?.vCorporateId;
    vLoginId = registrationFirstScreenRegModel?.userInfoVO?.vLoginId;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.offAllNamed(AppRoute.login);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.innerBackground),
                          fit: BoxFit.fill)),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Center(
                            child: Text(("Forgot Password"),
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: MyColors.mainTheme,
                                ))),
                      ),
                      Container(
                        width: width(context) / 1,
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              25.0), // Set the desired radius here
                          child: Card(
                              elevation: 0,
                              color: Colors.white.withOpacity(0.3),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: controller.newPassword,
                                      obscureText:
                                          controller.passwordNewVisibility,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLength: 16,
                                      decoration: InputDecoration(
                                          filled: true,
                                          counterText: "",
                                          hintText: 'New Password',
                                          hintStyle: TextStyle(
                                              fontFamily: MyFont.myFont),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                controller
                                                        .passwordNewVisibility =
                                                    !controller
                                                        .passwordNewVisibility;
                                              });
                                            },
                                            icon:
                                                controller.passwordNewVisibility
                                                    ? const Icon(
                                                        Icons.visibility_off,
                                                        color: Colors.grey,
                                                      )
                                                    : const Icon(
                                                        Icons.visibility,
                                                        color: Colors.grey,
                                                      ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 5, 20, 5)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the New Password';
                                        } else if (value.length < 10 ||
                                            value.length > 16) {
                                          return 'Password length must be between 10 and 16 characters';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 25),
                                    TextFormField(
                                      controller: controller.confrimPassword,
                                      obscureText:
                                          controller.passworconfrimVisibility,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLength: 16,
                                      decoration: InputDecoration(
                                          filled: true,
                                          counterText: "",
                                          hintText: 'Confirm Password',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                              fontFamily: MyFont.myFont),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                controller
                                                        .passworconfrimVisibility =
                                                    !controller
                                                        .passworconfrimVisibility;
                                              });
                                            },
                                            icon: controller
                                                    .passworconfrimVisibility
                                                ? const Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.visibility,
                                                    color: Colors.grey,
                                                  ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 5, 20, 5)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the Confirm Password';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 35),
                                    SizedBox(
                                      height: 45,
                                      width: width(context),
                                      child: (controller.isLoading.value ==
                                              true)
                                          ? Center(
                                              child:
                                                  const CircularProgressIndicator())
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                              onPressed: () {
                                                if (controller
                                                    .formKey.currentState!
                                                    .validate()) {
                                                  if (controller
                                                          .newPassword.text ==
                                                      controller.confrimPassword
                                                          .text) {
                                                    controller.loginModel =
                                                        LoginModel(
                                                      msgSourceChannelID: '120',
                                                      accessToken: access_token,
                                                      reqRefNo: controller
                                                          .referenceNumber,
                                                      gcifID: vGcifNo,
                                                      corpId: vGcifNo,
                                                      loginId: vLoginId,
                                                      password: controller
                                                          .confrimPassword.text,
                                                      mpin: '',
                                                      languageCode: "EN",
                                                      location: controller
                                                          .currentCity.value,
                                                      ipAddr: '120.10.0.1',
                                                      os: controller.osName,
                                                      deviceId:
                                                          controller.deviceId,
                                                      deviceType: 'mobileNo',
                                                      appName:
                                                          'Customer Portal',
                                                      appVersionCode: "1.0.0",
                                                      requestFlag: "N",
                                                    );
                                                    controller.forgotPassword();
                                                  } else {
                                                    PreferenceHelper.showSnackBar(
                                                        context: context,
                                                        msg:
                                                            'Passwords are mismatched');
                                                  }
                                                }
                                              },
                                              child: Text(
                                                'Proceed',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: MyFont.myFont,
                                                ),
                                              )),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  )),
            ],
          ),
        ));
  }
}
