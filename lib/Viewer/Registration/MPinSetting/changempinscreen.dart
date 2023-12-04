import 'package:ajmanbank/Helper/approute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/assets.dart';
import '../../../Helper/colors.dart';
import '../../../Helper/fonts.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../../Model/UpdateMpinModel.dart';
import 'changeMpinController.dart';

class ChangeMPINScreen extends StatefulWidget {
  const ChangeMPINScreen({Key? key}) : super(key: key);

  @override
  State<ChangeMPINScreen> createState() => _ChangeMPINScreenState();
}

class _ChangeMPINScreenState extends State<ChangeMPINScreen> {
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

  late ChngaeMpinController controller;
  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;
  String? access_token;
  String? vGcifNo;
  String? vLoginId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(ChngaeMpinController());
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
      key: controller.changefromKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.innerBackground),
                          fit: BoxFit.fill)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              )),
                        )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
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
                                  text: 'MPIN',
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Text(
                            'ENTER OLD MPIN',
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
                              controller: controller.oldMpinController,
                              length: 6,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r"[^\w\s]")),
                              ],
                              keyboardType: TextInputType.number,
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
                                      border:
                                          Border.all(color: MyColors.black))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the OLD MPIN';
                                } else if (value.length != 6) {
                                  return 'MPIN Must Be Exactly 6 Characters Long.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                                // Deny whitespace
                                FilteringTextInputFormatter.deny(
                                    RegExp(r"[^\w\s]")),
                                // Deny special characters
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
                                      border:
                                          Border.all(color: MyColors.black))),
                              onChanged: (value) {
                                if (controller.confirmMpinController.text !=
                                        "" &&
                                    controller.newmPinController.text.length ==
                                        6) {
                                  if (controller.newmPinController.text !=
                                      controller.confirmMpinController.text) {
                                    setState(() {
                                      controller.errorText = true;
                                      controller.sucessText = false;
                                      // validationErrorText = "Your MPIN codes are mismatch";
                                    });
                                  } else if (controller
                                          .newmPinController.text ==
                                      controller.confirmMpinController.text) {
                                    setState(() {
                                      controller.errorText = false;
                                      controller.sucessText = true;
                                      // validationErrorText = "Your MPIN codes are mismatch";
                                    });
                                  } else {
                                    setState(() {
                                      controller.sucessText = false;
                                      controller.errorText = false;
                                      // validationErrorText = "Your MPIN codes are same";
                                    });
                                  }
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  controller.errorText = false;
                                  controller.sucessText = false;
                                  return 'Please enter the NEW MPIN';
                                } else if (PreferenceHelper.hasRepeatedDigits(
                                    value, 6)) {
                                  setState(() {
                                    controller.editconfirm.value = true;
                                  });
                                  return 'mPin Should Not Contain Repeated Digits.';
                                }
                                setState(() {
                                  controller.editconfirm.value = false;
                                });
                                return null;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                                // Deny whitespace
                                FilteringTextInputFormatter.deny(
                                    RegExp(r"[^\w\s]")),
                                // Deny special characters
                              ],
                              keyboardType: TextInputType.number,
                              enabled: !controller.editconfirm.value,
                              obscureText: true,
                              defaultPinTheme: defaultTheme,
                              separator: SizedBox(width: 20, height: 30),
                              onChanged: (value) {
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
                                    // validationErrorText = "Your MPIN codes are mismatch";
                                  });
                                } else if (controller.newmPinController.text ==
                                    controller.confirmMpinController.text) {
                                  setState(() {
                                    controller.errorText = false;
                                    controller.sucessText = true;
                                    // validationErrorText = "Your MPIN codes are mismatch";
                                  });
                                } else {
                                  setState(() {
                                    controller.sucessText = false;
                                    controller.errorText = false;
                                    // validationErrorText = "Your MPIN codes are same";
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
                        (controller.errorText)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'Your MPIN codes are mismatch',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                              )
                            : Text(""),
                        (controller.sucessText)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Your MPIN codes are same ${" ✔"}",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                              )
                            : Text("")
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                      if (controller.confirmMpinController.text.length == 6 &&
                          controller.newmPinController.text.length == 6) {
                        if (controller.changefromKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          if (controller.errorText == false) {
                            if (controller.oldMpinController.text !=
                                controller.newmPinController.text) {
                              controller.updateMpinModel = UpdateMpinModel(
                                  vLoginId: vLoginId,
                                  vOSName: controller.deviceName,
                                  msgSourceChannelID: "120",
                                  vSecureToken: access_token,
                                  vCorporateId: vGcifNo,
                                  vDeviceId: controller.deviceId,
                                  requestFlag: "N",
                                  mpin: controller.confirmMpinController.text,
                                  deviceType: "mobileNo",
                                  ipAddr: "120.10.0.1",
                                  languageCode: "EN",
                                  oldMPIN: controller.oldMpinController.text);
                              controller.mPinUpdate();
                            } else {
                              PreferenceHelper.showSnackBar(
                                  context: context,
                                  msg:
                                      'Old MPIN and New MPIN should not be same');
                            }
                          }
                        }
                      } else {
                        PreferenceHelper.showSnackBar(
                            context: context,
                            msg: 'Please Enter the 6 Digits MPIN');
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
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',
                          style: TextStyle(
                              fontFamily: MyFont.myFont,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                              color: MyColors.primaryCustom))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showResetPopup() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Your MPIN \nreset successfully',
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
                      Get.toNamed(AppRoute.homeScreen);
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
