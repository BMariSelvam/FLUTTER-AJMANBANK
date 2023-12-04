import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';
import '../../Helper/size.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/MpinCheckModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import 'logincontroller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginController controller;

  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;

  String? access_token;
  String? vGcifNo;
  String? vLoginId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(LoginController());
    getCheckData();
    checkUser();
  }

  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    access_token = authuModel?.accessToken;
    registrationFirstScreenRegModel = await PreferenceHelper.getUserData();
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
    return GetBuilder<LoginController>(builder: (logic) {
      return Form(
        key: controller.formKey1,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.registration),
                          fit: BoxFit.fill)),
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
                            const SizedBox(height: 10),
                            Container(
                              width: width(context)/1,
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0), // Set the desired radius here
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
                                            controller: controller.userIdController,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            maxLength: 30,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(RegExp(r"\s")), // Deny whitespace
                                              FilteringTextInputFormatter.deny(RegExp(r"[^\w\s]")), // Deny special characters
                                            ],
                                            decoration: InputDecoration(
                                                filled: true,
                                                hintText: 'User Name',
                                                fillColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    fontFamily: MyFont.myFont),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              counterText: "",
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter the User Name';
                                              } else if (value!.startsWith(' ')) {
                                                return 'Cannot start with a space';
                                              } else if (value!.endsWith(' ')) {
                                                return 'Cannot end with a space';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            controller: controller.passwordController,
                                            obscureText: controller.passwordVisibility,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            maxLength: 16,
                                            decoration: InputDecoration(
                                                filled: true,
                                                hintText: 'Password',
                                              counterText: "",
                                                fillColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    fontFamily: MyFont.myFont),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      controller.passwordVisibility =
                                                      !controller.passwordVisibility;
                                                    });
                                                  },
                                                  icon: controller.passwordVisibility
                                                      ? const Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey,
                                                  )
                                                      : const Icon(
                                                    Icons.visibility,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10.0)
                                              ),
                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter the Password';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 35),
                                          SizedBox(
                                            height: 45,
                                            width: width(context),
                                            child: (controller.isLoading.value == true) ? Center(child: const CircularProgressIndicator()) : ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0))),
                                                onPressed: () {
                                                  FocusScope.of(context).unfocus();
                                                  if (controller.formKey1.currentState!
                                                      .validate()) {
                                                    controller.makePostRequest();
                                                    // controller.loginModel =
                                                    //     LoginModel(
                                                    //   msgSourceChannelID: '120',
                                                    //   accessToken: controller.access_token,
                                                    //   reqRefNo:
                                                    //       controller.referenceNumber,
                                                    //   gcifID: vGcifNo,
                                                    //   corpId: vGcifNo,
                                                    //   loginId: vLoginId,
                                                    //   password: controller
                                                    //       .passwordController.text,
                                                    //   mpin: '',
                                                    //   languageCode: "EN",
                                                    //   location: controller
                                                    //       .currentCity.value,
                                                    //   ipAddr: '120.10.0.1',
                                                    //   os: controller.osName,
                                                    //   deviceId: controller.deviceId,
                                                    //   deviceType: 'mobileNo',
                                                    //   appName: 'Customer Portal',
                                                    //   appVersionCode: "1.0.0",
                                                    //   requestFlag: "N",
                                                    // );
                                                  }
                                                  // Get.toNamed(AppRoute.homeScreen);
                                                },
                                                child: Text(
                                                  'LOGIN',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: MyFont.myFont,
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed(AppRoute.registrationSecondScreen,arguments: true);
                                                // Get.offAllNamed(AppRoute.registrationSecondScreen,arguments: true);
                                              },
                                              child: Container(
                                                height: 32,
                                                width: width(context),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(""),
                                                    Text(
                                                      'Need help logging in?',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                          fontFamily: MyFont.myFont,
                                                          color: MyColors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
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
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    onPressed: () {
                                      controller.checkMpinModel = MpinCheckModel(
                                          msgSourceChannelID: '120',
                                          languageCode: "EN",
                                          location: controller.currentCity.value,
                                          ipAddr: "120.10.0.1",
                                          deviceType: 'mobileNo',
                                          requestFlag: 'N',
                                          reqRefNo: controller.referenceNumber,
                                          accessToken: access_token,
                                          appName: 'mobileApp',
                                          appVersionCode: '',
                                          corpId: vGcifNo,
                                          gcifID: vGcifNo,
                                          deviceId: controller.deviceId,
                                          loginId: vLoginId,
                                          mpin: "",
                                          os: controller.osName,
                                          password: "");
                                      controller.CheckMpin();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        'MPIN or Touch ID',
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
                        )
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}


