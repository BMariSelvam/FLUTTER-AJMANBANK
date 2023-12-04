import 'dart:io';

import 'package:ajmanbank/Helper/Button.dart';
import 'package:ajmanbank/Helper/colors.dart';
import 'package:ajmanbank/Helper/fonts.dart';
import 'package:ajmanbank/Helper/size.dart';
import 'package:ajmanbank/Viewer/Registration/RegistrationFirst/registrationController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Helper/PreferenceHelper.dart';
import '../../../Helper/approute.dart';
import '../../../Helper/assets.dart';
import '../../../Model/RegistrationModel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationController controller;
  String? access_token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(RegistrationController());
    // controller.corporateIdController.text = "Mobile1";
    // controller.userIdController.text = "Mobile804";
    // controller.passwordController.text = "Mobile@12345";
    getCheckData();
  }

  getCheckData() async {
    await PreferenceHelper.getToken().then((value) =>
    setState((){
      access_token = value?.accessToken;
    })
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(builder: (logic) {
      return Form(
        key: controller.formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.registration), fit: BoxFit.fill)),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150, left: 45, right: 45),
                      child: ListView(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Card(
                                elevation: 0,
                                color: Colors.white.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20,
                                      10),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r"\s")), // Deny whitespace
                                          FilteringTextInputFormatter.deny(RegExp(r"[^\w\s]")), // Deny special characters
                                        ],
                                        controller: controller.corporateIdController,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        maxLength: 30,
                                        decoration: InputDecoration(
                                            filled: true,
                                            hintText: 'Corporate ID',
                                            fillColor: Colors.white,
                                            hintStyle:
                                            TextStyle(fontFamily: MyFont.myFont),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.circular(
                                                    10.0)
                                            ),
                                            counterText: "",
                                            contentPadding: const EdgeInsets
                                                .symmetric(
                                                vertical: 15, horizontal: 20)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter the Corporate ID";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: controller.userIdController,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        maxLength: 30,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r"\s")), // Deny whitespace
                                          FilteringTextInputFormatter.deny(RegExp(r"[^\w\s]")), // Deny special characters
                                        ],
                                        decoration: InputDecoration(
                                            filled: true,
                                            hintText: 'User Name',
                                            fillColor: Colors.white,
                                            hintStyle:
                                            TextStyle(fontFamily: MyFont.myFont),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.circular(
                                                    10.0)
                                            ),
                                            counterText: "",
                                            contentPadding: const EdgeInsets
                                                .symmetric(
                                                vertical: 15, horizontal: 20)),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter the User Name";
                                          } else if (value!.startsWith(' ')) {
                                            return 'Cannot start with a space';
                                          } else if (value!.endsWith(' ')) {
                                            return 'Cannot end with a space';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: controller.passwordController,
                                        autovalidateMode: AutovalidateMode
                                            .onUserInteraction,
                                        obscureText: controller.passwordVisibility,
                                        maxLength: 16,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: MyColors.white,
                                          hintText: 'Password',
                                          hintStyle:
                                          TextStyle(fontFamily: MyFont.myFont),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(
                                                  10.0)
                                          ),
                                          contentPadding: const EdgeInsets
                                              .symmetric(
                                              vertical: 15, horizontal: 20),
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
                                          counterText: ""
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter the Password";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        height: 45,
                                        width: width(context),
                                        child: (controller.isLoading.value == true)
                                            ? Center(
                                            child: const CircularProgressIndicator())
                                            : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10.0))),
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              if (controller.isLoading.value == false) {
                                                if (controller.formKey.currentState!
                                                    .validate()) {
                                                  controller.registrationModel =
                                                      RegistrationModel(
                                                        msgSourceChannelID: "120",
                                                        vSecureToken: access_token ??
                                                            "",
                                                        reqRefNo:
                                                        controller.referenceNumber,
                                                        vCorporateId: controller
                                                            .corporateIdController
                                                            .text,
                                                        vGcifNo: controller
                                                            .corporateIdController
                                                            .text,
                                                        vLoginId: controller
                                                            .userIdController.text,
                                                        password: controller
                                                            .passwordController
                                                            .text,
                                                        location:
                                                        controller.currentCity
                                                            .value,
                                                        vOSName: controller.osName,
                                                        vDeviceId: controller
                                                            .deviceId,
                                                        vDeviceModelName:
                                                        controller.deviceName,
                                                        appVersionCode: "1.0.0",
                                                        requestFlag: "N",
                                                      );
                                                  controller.getDivecList();
                                                  // controller.Registration();
                                                }
                                              }

                                              // Get.toNamed(AppRoute.registrationSecondScreen,arguments: false);
                                            },
                                            child: Text(
                                              'CONFIRM',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontFamily: MyFont.myFont,
                                              ),
                                            )),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                )),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: MyColors.black,
                                ),
                              ))
                        ],
                      ),
                    )),
              ),
            // ),
          ),
        ),
      );
    });
  }
}
