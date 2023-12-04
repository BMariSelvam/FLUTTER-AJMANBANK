import 'dart:async';

import 'package:ajmanbank/Helper/colors.dart';
import 'package:ajmanbank/Helper/fonts.dart';
import 'package:ajmanbank/Helper/size.dart';
import 'package:ajmanbank/Model/OtpInfo.dart';
import 'package:ajmanbank/Model/OtpUserInfoVo.dart';
import 'package:ajmanbank/Viewer/Registration/RegistrationSecond/mobileOtpVerificationController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:quiver/async.dart';
import '../../../Helper/HttpUrl.dart';
import '../../../Helper/Networkservice.dart';
import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Helper/assets.dart';
import '../../../Model/AuthuModel.dart';
import '../../../Model/GenerateOtpModel.dart';
import '../../../Model/MobileNumberValidationModel.dart';
import '../../../Model/ResponseModel/GenerateOtpResponse/GenerateOtpResponseModel.dart';
import '../../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../../sample.dart';

class MobileOtpVerification extends StatefulWidget {
  const MobileOtpVerification({Key? key}) : super(key: key);

  @override
  State<MobileOtpVerification> createState() => _MobileOtpVerificationState();
}

class _MobileOtpVerificationState extends State<MobileOtpVerification> {
  late RegistrationSecondController controller;

  // RegistrationFirstScreenRegModel? registrationFirstScreenRegModel;
  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;
  String? access_token;
  String? vGcifNo;
  String? vLoginId;

  //OTPFieldDecoration
  final defaultTheme = PinTheme(
      height: 50,
      width: 45,
      textStyle: TextStyle(
        fontFamily: MyFont.myFont,
        fontSize: 20,
        color: MyColors.black,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.3), // Set the shadow color and opacity
            spreadRadius: 2, // Adjust the spread radius of the shadow
            blurRadius: 4, // Adjust the blur radius of the shadow
            offset: Offset(
                0, 2), // The position of the shadow relative to the container
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: MyColors.white,
      ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(RegistrationSecondController());
    getCheckData();
  }

  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    registrationFirstScreenRegModel = await PreferenceHelper.getUserData();
    access_token = authuModel?.accessToken;
    vGcifNo = registrationFirstScreenRegModel?.userInfoVO?.vCorporateId;
    vLoginId = registrationFirstScreenRegModel?.userInfoVO?.vLoginId;
    // controller.ischange = Get.arguments as bool;
  }

  int start =120;
  bool complete = false;

  void _startCountdowns() {
    const onsec = Duration(seconds: 1); // Change to seconds
     Timer.periodic(onsec, (Timer timer) {
      if (start == 0) {
        timer.cancel();
        setState(() {
          complete = true;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  //ResendOTPTimer
  CountdownTimer? _countdownTimer;
  int _totalDuration = 122; // 2 minutes in seconds
  String _formattedDuration = '02:00';

  void startCountdowns() {
    _countdownTimer = CountdownTimer(
      Duration(seconds: _totalDuration),
      const Duration(seconds: 1),
    );

    _countdownTimer?.listen((event) {
      setState(() {
        final minutes = event.remaining.inMinutes;
        final seconds = event.remaining.inSeconds % 60;
        _formattedDuration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    }, onDone: () {
      setState(() {
        complete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationSecondController>(builder: (logic) {
      return Form(
        key: controller.formKey,
        child: SafeArea(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeArea(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                  )),
                            )),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: Text(
                                'Setting up',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    letterSpacing: 1.0,
                                    color: MyColors.darkGray),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    fontFamily: MyFont.myFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    // letterSpacing: 1.0,
                                    color: MyColors.black),
                              ),
                            ),
                            Obx(() {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 40),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(
                                            0.3), // Set the shadow color and opacity
                                        spreadRadius: 2,
                                        // Adjust the spread radius of the shadow
                                        blurRadius:
                                            4, // Adjust the blur radius of the shadow
                                        offset: Offset(
                                            2, 4), // Adjust the shadow offset
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(
                                        13), // Set the same borderRadius as the commented out border property in InputDecoration
                                    // color: Colors.white, // Set the background color of the container to match the filled color in InputDecoration
                                  ),
                                  child: TextFormField(
                                    controller:
                                        controller.phoneNumberController,
                                    keyboardType: TextInputType.number,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    enabled: !controller.editMobile.value,
                                    maxLength: 9,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    decoration: InputDecoration(
                                        counterText: "",
                                        filled: true,
                                        fillColor: MyColors.white,
                                        hintText: 'Enter Mobile Number',
                                        hintStyle: TextStyle(
                                          fontFamily: MyFont.myFont,
                                          fontWeight: FontWeight.w600,
                                          color: MyColors.gray,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 5, 20, 5)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the Mobile Number';
                                      }
                                      return null; // Return null if the input is valid
                                    },
                                  ),
                                ),
                              );
                            }),
                            if (controller.sendOTP.value)
                              Obx(() {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          (controller.istime == false)
                                              ? Text(
                                                  'OTP has been send',
                                                  style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: MyColors.green),
                                                )
                                              : Text(''),
                                          (complete == true)
                                              ? TextButton(
                                                  onPressed: () {
                                                    if (controller
                                                            .clickCount.value <
                                                        2) {
                                                      controller
                                                          .clickCount.value++;
                                                      controller
                                                              .mobileNumberValidationModel =
                                                          MobileNumberValidationModel(
                                                        requestFlag: "N",
                                                        vDeviceId:
                                                            controller.deviceId,
                                                        vCorporateId: vGcifNo,
                                                        vLoginId: vLoginId,
                                                        vSecureToken:
                                                            access_token,
                                                        msgSourceChannelID:
                                                            "120",
                                                        vMobileNo: controller
                                                            .phoneNumberController
                                                            .text,
                                                      );
                                                      MobileMuberValidationApi(true);
                                                      setState(() {
                                                        _formattedDuration = '02:00';
                                                         complete =false;
                                                      });
                                                    } else {
                                                      Get.dialog(
                                                        AlertDialog(
                                                          content: Text(
                                                              'OTP limit exist'),
                                                        ),
                                                      );
                                                      Timer(
                                                          const Duration(
                                                              milliseconds:
                                                                  1500),
                                                          () async {
                                                          Get.offAllNamed(
                                                              AppRoute.login);
                                                      });
                                                    }
                                                  },
                                                  child: Text("Resend OTP",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              MyFont.myFont,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          color: MyColors
                                                              .mainTheme)))
                                              : Text(
                                                  'Resend OTP $_formattedDuration'
                                                      // ' ${(start ~/ 60).toString().padLeft(
                                                      // 2, '0')}:${(start % 60).toString().padLeft(
                                                      // 2, '0')}'
                                                      ,
                                                  // 'Resend OTP ${controller.start}',
                                                  style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      color: MyColors.gray),
                                                ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1.5,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20),
                                      child: Text(
                                        'Enter OTP',
                                        style: TextStyle(
                                            fontFamily: MyFont.myFont,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: MyColors.darkGray),
                                      ),
                                    ),
                                    Center(
                                      child: Pinput(
                                        controller: controller.otpController,
                                        length: 6,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r"\s")), // Deny whitespace
                                          FilteringTextInputFormatter.deny(RegExp(
                                              r"[^\w\s]")), // Deny special characters
                                        ],
                                        enabled: true,
                                        separator: SizedBox(
                                          width: 15,
                                          height: 30,
                                        ),
                                        defaultPinTheme: defaultTheme,
                                        focusedPinTheme: defaultTheme.copyWith(
                                            decoration: BoxDecoration(
                                                color: MyColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: MyColors.gray))),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the OTP';
                                          } else if (value.length != 6) {
                                            return 'OTP must be maximum 6 characters long';
                                          }
                                          return null; // Return null if validation passes.
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Center(
                                        child: Text(
                                      "${controller.otpValue ?? ""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                  ],
                                );
                              })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar:
                    _buildProceedButton(isOtpSent: controller.sendOTP.value)),
          ),
        ),
      );
    });
  }

  Padding _buildProceedButton({required bool isOtpSent}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
      child: SizedBox(
        height: 45,
        width: width(context),
        child: (controller.isLoading == true)
            ? Center(child: const CircularProgressIndicator())
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onPressed: () {

                  FocusScope.of(context).unfocus();
                  if (!isOtpSent) {
                    print(controller.phoneNumberController.text);
                    // controller.sendOTP.value = !controller.sendOTP.value;
                    if (controller.formKey.currentState!.validate()) {
                      if (controller.phoneNumberController.text.length == 9) {
                        controller.mobileNumberValidationModel =
                            MobileNumberValidationModel(
                          requestFlag: "N",
                          vDeviceId: controller.deviceId,
                          vCorporateId: vGcifNo,
                          vLoginId: vLoginId,
                          vSecureToken: access_token,
                          msgSourceChannelID: "120",
                          vMobileNo: controller.phoneNumberController.text,
                        );
                       MobileMuberValidationApi(false);
                      } else {
                        PreferenceHelper.showSnackBar(
                            context: context,
                            msg: 'Mobile Number must be 9 Digits');
                      }
                    }
                  } else {
                    if (controller.formKey.currentState!.validate()) {
                      controller.otpInfo = OtpInfo(
                          otpId: "${controller.otpId}",
                          otpValue: controller.otpController.text);
                      controller.userInfoVO = OtpUserInfoVO(
                        msgSourceChannelID: '120',
                        requestFlag: "N",
                        vDeviceId: controller.deviceId,
                        isMpinCreated: false,
                        reqRefNo: controller.referenceNumber,
                        vCorporateId: vGcifNo,
                        vGcifNo: vGcifNo,
                        vLoginId: vLoginId,
                        vMobileNo: controller.phoneNumberController.text,
                        vOSName: controller.osName,
                        vSecureToken: access_token,
                      );
                      controller.VerifyOtp();
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    isOtpSent ? 'Submit' : "Send OTP",
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
    );
  }

  MobileMuberValidationApi(bool isResend) async {
   setState(() {
     controller.isLoading.value = true;
   });

    await NetworkManager.post(
      HttpUrl.mobieNumberVAlidation,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json', // Adjust the content type if needed
      },
      body: {
        "userInfoVO": controller.mobileNumberValidationModel
      }, // Convert your data to JSON
    ).then((response) async {
      setState(() {
        controller.isLoading.value = false;
      });
      if (response != null) {
        print(response);
        if (response['statusCode'] == '0000') {
          print(response['statusDesc']);
          controller.sendOTP.value = true;
          controller.editMobile.value = true;
          if (isResend) {
            GenerateOtp(true);
          } else {
            GenerateOtp(false);
          }
        } else if (response['statusCode'] == "9999") {
          PreferenceHelper.showSnackBar(
              context: Get.context!, msg: response['statusDesc']);
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: "InValied Data");
      }
    });
  }

  GenerateOtp(bool isResned) async {
    controller.otpController.clear();
    controller.generateOtpModel = GenerateOtpModel(
      msgSourceChannelID: "120",
      vSecureToken: access_token,
      reqRefNo: controller.referenceNumber,
      vMobileNo: controller.phoneNumberController.text,
      vGcifNo: vGcifNo,
      vCorporateId: vGcifNo,
      vLoginId: vLoginId,
      vDeviceId: controller.deviceId,
      requestFlag: "N",
    );
    setState(() {
      controller.isLoading.value = true;
    });
    await NetworkManager.post(
      HttpUrl.otpGenerate,
      headers: {
        'access_token': access_token ?? "",
        'Content-Type': 'application/json', // Adjust the content type if needed
      },
      body: {"userInfoVO": controller.generateOtpModel}, // Convert your data to JSON
    ).then((response) async {
      setState(() {
        controller.isLoading.value = false;
      });
      if (response != null) {
        print(response);
        if (response['statusCode'] == '0000') {
          Map<dynamic, dynamic>? customerJson = response;
          GenerateOtpResponseModel generateOtpResponseModel =
          GenerateOtpResponseModel.fromJson(customerJson);
          if (isResned == true) {
            PreferenceHelper.WhiteSnackBar(
                context: Get.context!, msg: "OTP has been Resend");
          }
          controller.otpId = generateOtpResponseModel.otpInfo?.otpId;
          controller.otpValue = generateOtpResponseModel.otpInfo?.otpValue;
          controller.istime.value = false;
          _totalDuration = 122;
          startCountdowns();
        } else {
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
