import 'package:ajmanbank/Model/VerifyMpinModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../Helper/BiometricAuth.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';
import '../../Helper/size.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/LoginModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../../Model/ValidMpinModel.dart';
import 'MpinLOginController.dart';
import 'logincontroller.dart';

class LoginThroughMPIN extends StatefulWidget {
  const LoginThroughMPIN({Key? key}) : super(key: key);

  @override
  State<LoginThroughMPIN> createState() => _LoginThroughMPINState();
}

class _LoginThroughMPINState extends State<LoginThroughMPIN> {
  //OTPFieldDecoration
  final defaultTheme = PinTheme(
      height: 40,
      width: 45,
      textStyle: TextStyle(
        fontFamily: MyFont.myFont,
        fontSize: 20,
        color: MyColors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: MyColors.white,
      ));

  late MpinLoginController controller;

  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;

  String? access_token;
  String? vGcifNo;
  String? vLoginId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(MpinLoginController());
    // BioAuthu();
    getCheckData();
    checkUser();
  }

  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    registrationFirstScreenRegModel = await PreferenceHelper.getUserData();
    access_token = authuModel?.accessToken;
    vGcifNo = registrationFirstScreenRegModel?.userInfoVO?.vCorporateId;
  }

  checkUser() async {
    await PreferenceHelper.getUserData().then((value) =>
        setState(() {
          vLoginId = value?.userInfoVO?.vLoginId;
        })
    );
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MpinLoginController>(builder: (logic) {
      return Form(
      key: controller.formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.registration), fit: BoxFit.fill)),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 130,left: 45,right: 45),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          'Hi, ${vLoginId ?? ""}',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: MyColors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: width(context)/1,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Card(
                              elevation: 0,
                              color: Colors.white.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        'Enter 6 digit login MPIN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: MyFont.myFont,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Center(
                                      child: Pinput(
                                        controller: controller.otpController,
                                        length: 6,
                                        keyboardType: TextInputType.number,
                                        enabled: true,
                                        obscureText: true,
                                        cursor: SizedBox(height: 0),
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
                                            return 'Please enter the MPIN';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextButton(
                                        onPressed: () async {
                                          if (await BiometricAuth.getInstance
                                              .authenticateWithBiometrics()) {
                                            Get.offAllNamed(
                                                AppRoute.homeScreen);
                                          }
                                        },
                                        child: Text(
                                          'Use Touch ID',
                                          style: TextStyle(
                                              fontFamily: MyFont.myFont,
                                              color: MyColors.primaryCustom),
                                        )),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 45,
                                      width: width(context),
                                      child: (controller.isLoading.value == true) ? Center(child: const CircularProgressIndicator()) : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0))),
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            if (controller.formKey.currentState!.validate()) {
                                              controller.verifyMpinModel = ValidMpinModel(
                                                msgSourceChannelID: '120',
                                                mpin: controller.otpController.text,
                                                languageCode: "EN",
                                                ipAddr: '120.10.0.1',
                                                deviceType: 'mobileNo',
                                                requestFlag: "N",
                                                vSecureToken: access_token,
                                                vCorporateId: vGcifNo,
                                                vLoginId: vLoginId,
                                                vDeviceId: controller.deviceId,
                                                vOSName: controller.osName,
                                              );
                                              controller.MpinLoginApi();
                                            }
                                          },
                                          child: Text(
                                            'LOGIN',
                                            style: TextStyle(
                                              fontFamily: MyFont.myFont,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text('Or, login with',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          height: 45,
                          width: width(context),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.white,
                                  side: const BorderSide(
                                      color: MyColors.primaryCustom),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Do you want to login \n using User ID & Password?',
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
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0))),
                                                onPressed: () {
                                                  Get.back();
                                                  Get.offAllNamed(AppRoute.login);
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      fontWeight: FontWeight.w600),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontFamily: MyFont.myFont,
                                                      fontWeight: FontWeight.w600),
                                                ))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'User ID & Password',
                                  style: TextStyle(
                                      fontFamily: MyFont.myFont,
                                      fontSize: 15,
                                      color: MyColors.primaryCustom),
                                ),
                              )),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                wordSpacing: 2.0,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                color: MyColors.black,
                              ),
                            )),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    });
  }
  BioAuthu() async {
    if (await BiometricAuth.getInstance
        .authenticateWithBiometrics()) {
    Get.offAllNamed(
    AppRoute.homeScreen);
    } else {
      Get.toNamed(
          AppRoute.loginThroughMPIN);
    }
  }
}
