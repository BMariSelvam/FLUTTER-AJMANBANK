
import 'package:ajmanbank/Model/MpinRegisterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Helper/assets.dart';
import '../../../Helper/colors.dart';
import '../../../Helper/fonts.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import 'MpinRegisterController.dart';

class MPinSettingScreen extends StatefulWidget {
  const MPinSettingScreen({Key? key}) : super(key: key);

  @override
  State<MPinSettingScreen> createState() => _MPinSettingScreenState();
}

class _MPinSettingScreenState extends State<MPinSettingScreen> {
  //OTPFieldDecoration
  final defaultTheme = PinTheme(
      height: 50,
      width: 65,
      textStyle: TextStyle(
        fontFamily: MyFont.myFont,
        fontSize: 20,
        color: MyColors.black,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            // Set the shadow color and opacity
            spreadRadius: 2,
            // Adjust the spread radius of the shadow
            blurRadius: 4,
            // Adjust the blur radius of the shadow
            offset: Offset(
                0, 2), // The position of the shadow relative to the container
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: MyColors.white,
      ));
  late MpinRegisterController controller;
  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;
  String? access_token;
  String? vGcifNo;
  String? vLoginId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(MpinRegisterController());
    controller.isRegister.value = Get.arguments ?? false;
    getCheckData();
  }

  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    registrationFirstScreenRegModel = await PreferenceHelper.getUserData();
    access_token = authuModel?.accessToken;
    vGcifNo = registrationFirstScreenRegModel?.userInfoVO?.vCorporateId;
    vLoginId = registrationFirstScreenRegModel?.userInfoVO?.vLoginId;
  }

  String? validationErrorText;

  @override
  Widget build(BuildContext context) {
      return Form(
        key: controller.mpinKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.innerBackground),
                          fit: BoxFit.fill)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      SafeArea(
                          child: (controller.isRegister.value) ? Text("") :
                          IconButton(
                              onPressed: () {
                                Get.offAllNamed(AppRoute.login);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              ))
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Text(
                          'Setting up',
                          style: TextStyle(
                              fontFamily: MyFont.myFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1.0,
                              color: MyColors.gray),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Text(
                          'Your MPIN Code',
                          style: TextStyle(
                              fontFamily: MyFont.myFont,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: MyColors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'To set up your ',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                    color: MyColors.darkGray)),
                            TextSpan(
                                text: 'MPIN ',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: MyColors.black)),
                            TextSpan(
                                text: 'create ',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                    color: MyColors.darkGray)),
                            TextSpan(
                                text: '6 digit code ',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: MyColors.black)),
                            TextSpan(
                                text: '\nthen confirm it below ',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                    color: MyColors.darkGray)),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                        child: Text(
                          'ENTER NEW MPIN',
                          style: TextStyle(
                              fontFamily: MyFont.myFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              letterSpacing: 1.0,
                              color: MyColors.darkGray),
                         ),
                     ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Pinput(
                            controller: controller.newmPinController,
                            length: 6,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r"\s")), // Deny whitespace
                              FilteringTextInputFormatter.deny(RegExp(r"[^\w\s]")), // Deny special characters
                            ],
                            enabled: true,
                            defaultPinTheme: defaultTheme,
                            separator: SizedBox(
                              width: 20,
                              height: 30,
                            ),
                            focusedPinTheme: defaultTheme.copyWith(
                                decoration: BoxDecoration(
                                    color: MyColors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: MyColors.black))),
                            onChanged: (value) {
                              if (controller.newmPinController.text.length == 6 && controller.confirmMpinController.text != "") {
                                if (controller.newmPinController.text !=
                                    controller.confirmMpinController.text) {
                                  setState(() {
                                    controller.errorText = true;
                                    controller.sucessText = false;
                                  });
                                } else if (controller.newmPinController.text ==
                                    controller.confirmMpinController.text) {
                                  setState(() {
                                    controller.errorText = false;
                                    controller.sucessText = true;
                                  });
                                }  else {
                                  setState(() {
                                    controller.sucessText = true;
                                    controller.errorText = false;
                                  });
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the  NEW MPIN';
                              } else if (PreferenceHelper.hasRepeatedDigits(value,6)) {
                                setState(() {
                                  controller.editconfirm.value = true;
                                });
                                return 'MPIN Should Not Contain Repeated Digits.';
                              }
                              setState(() {
                                controller.editconfirm.value = false;
                              });
                              return null; // Return null if validation passes.
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                        child: Text(
                          'CONFIRM NEW MPIN',
                          style: TextStyle(
                              fontFamily: MyFont.myFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              letterSpacing: 1.0,
                              color: MyColors.darkGray),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Pinput(
                            controller: controller.confirmMpinController,
                            length: 6,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r"\s")), // Deny whitespace
                              FilteringTextInputFormatter.deny(RegExp(r"[^\w\s]")), // Deny special characters
                            ],
                            enabled: !controller.editconfirm.value,
                            obscureText: true,
                            defaultPinTheme: defaultTheme,
                            separator: SizedBox(width: 20, height: 30),
                            onChanged: (value){
                              setState(() {
                                controller.errorText = false;
                                controller.sucessText = false;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  controller.errorText = false;
                                  controller.sucessText = false;
                                });
                                return 'Please enter the CONFIRM MPIN';
                              } else if (controller.newmPinController.text !=
                                  controller.confirmMpinController.text) {
                                setState(() {
                                  controller.errorText = true;
                                  controller.sucessText = false;
                                });
                              } else if (controller.newmPinController.text ==
                                  controller.confirmMpinController.text) {
                                setState(() {
                                  controller.errorText = false;
                                  controller.sucessText = true;
                                });
                              }  else {
                                setState(() {
                                  controller.sucessText = true;
                                  controller.errorText = false;
                                });
                              }
                              return null;
                            },

                            focusedPinTheme: defaultTheme.copyWith(
                                decoration: BoxDecoration(
                                    color: MyColors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: MyColors.black,
                                    ))),
                          ),
                        ),
                      ),
                      (controller.errorText) ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20),
                        child: Text('Your MPIN codes are mismatch',
                          style: TextStyle(color: Colors.red, fontSize: 15),),
                      ) : Text(""),
                      (controller.sucessText) ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Your MPIN codes are same ${" ✔"}",
                          style: TextStyle(color: Colors.green, fontSize: 15),),
                      ) : Text("")
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (controller.mpinKey.currentState!.validate()) {
                          if (controller.errorText == false) {
                            controller.mpinRegisterModel = MpinRegisterModel(
                                msgSourceChannelID: "120",
                                vSecureToken: access_token,
                                vCorporateId: vGcifNo,
                                vLoginId: vLoginId,
                                vGcifNo: vGcifNo,
                                mpin: controller.confirmMpinController.text,
                                languageCode: "EN",
                                location: controller.currentCity.value,
                                ipAddr: "120.10.0.1",
                                vOSName: controller.osName,
                                vDeviceId: controller.deviceId,
                                deviceType: "mobileNo",
                                requestFlag: "N");
                            controller.mPinRegisert();
                            // controller.showPopup(true);
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  (controller.isRegister.value) ?
                  Center(
                    child: TextButton(
                        onPressed: () {
                          controller.showPopup(false);
                        },
                        child: Text('Skip This Step',
                            style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: MyColors.primaryCustom))),
                  ) : Container()
                ],
              ),
            ),
          ),
        ),
      );
  }
}
